#!/bin/bash

# Function to find an available terminal emulator
find_terminal() {
    for term in "xfce4-terminal" "gnome-terminal" "x-terminal-emulator" "konsole" "xterm" "lxterminal" "mate-terminal" "terminator"; do
        if command -v $term &>/dev/null; then
            echo $term
            return
        fi
    done
    echo "[!] No terminal emulator found!" >&2
    exit 1
}

TERMINAL=$(find_terminal)

# Ensure dependencies are installed
if ! command -v ngrok &> /dev/null; then
    echo "[!] ngrok not found. Please install it first."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "[!] jq not found. Please install it with: sudo apt install jq"
    exit 1
fi

# Kill any process using port 3000
echo "[+] Checking for existing processes on port 3000..."
PORT_PROCESS=$(sudo lsof -i :3000 | awk 'NR>1 {print $2}')
if [[ ! -z "$PORT_PROCESS" ]]; then
    echo "[!] Killing existing process on port 3000..."
    sudo kill -9 $PORT_PROCESS
fi

# Start ngrok in a new terminal
echo "[+] Starting ngrok on port 3000..."
$TERMINAL -e "bash -c 'ngrok http 3000; exec bash'" &

# Wait for ngrok to initialize
echo "[+] Waiting for ngrok to start..."
sleep 5  # Give ngrok some time to initialize

# Get ngrok public URL
for i in {1..10}; do
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    if [[ ! -z "$NGROK_URL" && "$NGROK_URL" != "null" ]]; then
        break
    fi
    sleep 2
done

# Check if ngrok successfully started
if [[ -z "$NGROK_URL" || "$NGROK_URL" == "null" ]]; then
    echo "[!] Failed to get ngrok URL. Make sure ngrok is running!"
    exit 1
fi

# Extract only the hostname (remove "https://")
NGROK_HOST=$(echo "$NGROK_URL" | sed 's|https://||')

echo "[+] ngrok Host: $NGROK_HOST"

# BeEF config path
BEEF_CONFIG="$HOME/beef/config.yaml"

# Update ONLY the public.host line while keeping http.host unchanged
if [[ -f "$BEEF_CONFIG" ]]; then
    echo "[+] Updating BeEF config.yaml..."
    sed -i "/public:/,/host:/ s|^\(\s*host:\s*\)\".*\"|\\1\"$NGROK_HOST\"|" "$BEEF_CONFIG"
else
    echo "[!] BeEF config.yaml not found at $BEEF_CONFIG"
    exit 1
fi

# Start BeEF in a new terminal
echo "[+] Starting BeEF..."
cd "$HOME/beef" || exit
$TERMINAL -e "bash -c './beef; exec bash'" &

echo "[+] Setup complete! BeEF is running."
