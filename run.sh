#!/bin/bash

# --- Config ---
REPO_DIR="/home/user/tools/loop_shell"
SHELL_FILE="$REPO_DIR/shell.txt"
PORT_FILE="$REPO_DIR/ports.txt"
BRANCH="main"
GIT_USER="anaprivate"
GIT_EMAIL="anathike4@gmail.com"

# --- Step 0: Read token from environment variable ---
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable not set!"
    exit 1
fi

# --- Step 1: Go to repo directory ---
cd "$REPO_DIR" || { echo "Repo not found!"; exit 1; }

# --- Step 2: Configure Git identity ---
git config user.name "$GIT_USER"
git config user.email "$GIT_EMAIL"

# --- Step 3: Start ngrok ---
ngrok start --all > /dev/null &
sleep 5  # wait for tunnels to start

# --- Step 4: Get ngrok public URLs ---
NGROK_URL_4443=$(curl -s http://127.0.0.1:4040/api/tunnels | \
  jq -r '.tunnels[] | select(.config.addr=="localhost:4443") | .public_url')

NGROK_URL_4444=$(curl -s http://127.0.0.1:4040/api/tunnels | \
  jq -r '.tunnels[] | select(.config.addr=="localhost:4444") | .public_url')

# --- Step 5: Extract host and port ---
PORT_4443=$(echo "$NGROK_URL_4443" | cut -d':' -f3)
HOST_4443=$(echo "$NGROK_URL_4443" | cut -d'/' -f3 | cut -d':' -f1)

PORT_4444=$(echo "$NGROK_URL_4444" | cut -d':' -f3)
HOST_4444=$(echo "$NGROK_URL_4444" | cut -d'/' -f3 | cut -d':' -f1)

# --- Step 6: Save ports to ports.txt ---
echo "4443: $PORT_4443 ($HOST_4443)" > "$PORT_FILE"
echo "4444: $PORT_4444 ($HOST_4444)" >> "$PORT_FILE"

# --- Step 7: Replace $port and $host in shell.txt ---
sed -i "s/\$port/$PORT_4443/g" "$SHELL_FILE"
sed -i "s/\$host/$HOST_4443/g" "$SHELL_FILE"

# --- Step 8: Set remote URL with token (from environment variable) ---
git remote set-url origin "https://$GIT_USER:$GITHUB_TOKEN@github.com/$GIT_USER/loop_shell.git"

# --- Step 9: Commit & push safely ---
git add .
git commit -m "Updated shell.txt and ports.txt with new ngrok host & port $(date)"

# Pull remote first to avoid conflicts
git pull --rebase origin "$BRANCH"

# Push to GitHub
git push origin "$BRANCH"

echo "Done! shell.txt and ports.txt updated and pushed automatically."
