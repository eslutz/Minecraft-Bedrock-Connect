# BedrockConnect Docker Setup for Raspberry Pi

This repository contains a containerized setup for running [BedrockConnect](https://github.com/Pugmatt/BedrockConnect) on a Raspberry Pi running Pi OS.

## What is BedrockConnect?

BedrockConnect is a serverlist software that allows Minecraft Bedrock Edition players (Nintendo Switch, Xbox, PlayStation) to connect to any server IP. It provides an in-game server list interface where players can add, manage, and connect to their favorite servers.

## Prerequisites

- Raspberry Pi (Model 3 or newer recommended)
- Pi OS (Raspberry Pi OS) installed
- Docker and Docker Compose installed

### Installing Docker on Raspberry Pi

```bash
# Update package list
sudo apt-get update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add your user to docker group (optional, to run without sudo)
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt-get install -y docker-compose

# Reboot to apply group changes
sudo reboot
```

## Quick Start

1. **Clone or download this repository:**

   ```bash
   cd ~/
   git clone <your-repo-url>
   cd Minecraft-Bedrock-Connect
   ```

2. **Create the data directory:**

   ```bash
   mkdir -p data/players
   ```

3. **Build and start the container:**

   ```bash
   docker-compose up -d
   ```

4. **Check the logs:**

   ```bash
   docker-compose logs -f
   ```

5. **Configure your game console:**
   - On your Nintendo Switch, Xbox, or PlayStation, set the DNS to your Raspberry Pi's IP address
   - Open Minecraft and connect through a Featured Server entry

## Configuration

### Memory Settings

Edit the `JAVA_OPTS` environment variable in `docker-compose.yml` based on your Raspberry Pi model:

- **Pi 4 (4GB or more):** `-Xms512M -Xmx1G` or `-Xms1G -Xmx2G`
- **Pi 4 (2GB):** `-Xms256M -Xmx512M` or `-Xms512M -Xmx1G`
- **Pi 3 or less:** `-Xms256M -Xmx512M`

### BedrockConnect Configuration

You can configure BedrockConnect using either:

1. **Environment Variables (Recommended):**
   Add variables to `docker-compose.yml` with the `BC_` prefix:

   ```yaml
   environment:
     - BC_PORT=19132
     - BC_SERVER_LIMIT=100
     - BC_DEBUG=false
   ```

2. **Configuration File:**
   Uncomment the config volume in `docker-compose.yml` and create `config.yml`:

   ```yaml
   port: 19132
   server_limit: 100
   kick_inactive: true
   user_servers: true
   featured_servers: true
   ```

### Custom Servers

To pre-configure servers for your players:

1. Create a `custom_servers.json` file:

   ```json
   {
     "servers": [
       {
         "name": "My Server",
         "iconUrl": "https://example.com/icon.png",
         "address": "play.myserver.net",
         "port": 19132
       }
     ]
   }
   ```

2. Uncomment the custom servers volume in `docker-compose.yml`:

   ```yaml
   - ./custom_servers.json:/app/custom_servers.json:ro
   ```

3. Add the environment variable:

   ```yaml
   environment:
     - BC_CUSTOM_SERVERS=/app/custom_servers.json
   ```

## Troubleshooting

### Container won't start

- Check logs: `docker-compose logs`
- Ensure port 19132 is not already in use: `sudo netstat -tulpn | grep 19132`
- Verify sufficient disk space: `df -h`

### Out of memory errors

- Reduce Java heap size in `docker-compose.yml`
- Check available RAM: `free -h`
- Consider closing other applications

### Players can't connect

- Verify the container is running: `docker-compose ps`
- Check firewall rules: `sudo ufw status`
- Ensure port 19132/UDP is forwarded on your router
- Verify the Raspberry Pi's IP address hasn't changed

## Additional Resources

- [BedrockConnect GitHub](https://github.com/Pugmatt/BedrockConnect)
- [BedrockConnect Wiki](https://github.com/Pugmatt/BedrockConnect/wiki)
- [Configuration Options](https://github.com/Pugmatt/BedrockConnect/wiki/Configuration)
- [Troubleshooting Guide](https://github.com/Pugmatt/BedrockConnect/wiki/Troubleshooting)

## License

This Docker setup is provided as-is. BedrockConnect is licensed under GPL-3.0 by Pugmatt.
