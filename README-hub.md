<a href="https://gitlab.com/MarcusHoltz/i2p-party-line"><img src="https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--invisible-internet-project-i2p-garlic-roter.jpg" alt="I2P Party Line"></a>

<table><tr>
<td><a href="https://geti2p.net/"><img src="https://img.shields.io/badge/built%20for-I2P-ffc337?style=for-the-badge" alt="Built for I2P"></a></td>
<td><a href="https://gitlab.com/MarcusHoltz/i2p-party-line/-/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="License: MIT"></a></td>
<td><a href="https://gitlab.com/MarcusHoltz/i2p-party-line"><img src="https://img.shields.io/badge/source-GitLab-orange?style=for-the-badge&logo=gitlab" alt="Source: GitLab"></a></td>
<td><a href="https://github.com/MarcusHoltz/i2p-party-line"><img src="https://img.shields.io/badge/source-GitHub-black?style=for-the-badge&logo=github" alt="Source: GitHub"></a></td>
</tr></table>

# marcusholtz/i2p-party-line

Encrypted push-to-talk voice and group party line over [I2P](https://geti2p.net/en/docs/how/intro). No accounts, no phone numbers, no servers, no open ports.

## Supported Architectures

| Architecture | Tag |
| :---: | --- |
| x86-64 | `amd64` |

## Quick Start: Interactive Calling

Pull and run the interactive menu. Make calls, listen for calls, set secrets, test audio.

### docker-compose (recommended)

Save as `docker-compose.yml`, then run `docker compose run --rm partyline`:

```yaml
services:
  partyline:
    image: marcusholtz/i2p-party-line:latest
    container_name: i2p-party-line
    restart: unless-stopped
    stdin_open: true
    tty: true
    security_opt:
      - label:disable
    devices:
      - /dev/snd:/dev/snd
    volumes:
      - ./data/docker/partyline:/data/.partyline
      - ./secrets:/run/secrets:ro
      - ${XDG_RUNTIME_DIR:-/run/user/1000}/pulse:/run/user/${UID:-1000}/pulse
    environment:
      - TERM=${TERM:-xterm-256color}
      - SHARED_SECRET_FILE=/run/secrets/shared_secret.txt
      - PULSE_SERVER=unix:/run/user/${UID:-1000}/pulse/native
      - XDG_RUNTIME_DIR=/run/user/${UID:-1000}
```

### docker cli

```bash
docker run -it --rm \
  --name i2p-party-line \
  --security-opt label:disable \
  --device /dev/snd:/dev/snd \
  -v ./data/docker/partyline:/data/.partyline \
  -v ./secrets:/run/secrets:ro \
  -v ${XDG_RUNTIME_DIR}/pulse:/run/user/$(id -u)/pulse \
  -e TERM=${TERM} \
  -e SHARED_SECRET_FILE=/run/secrets/shared_secret.txt \
  -e PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native \
  -e XDG_RUNTIME_DIR=/run/user/$(id -u) \
  marcusholtz/i2p-party-line:latest
```

### First run

1. i2pd reseeds and builds tunnels (~23 s for relay, ~86 s for calls from cold start)
2. Your `.b32.i2p` address appears (no ports needed; I2P routes through tunnel gateways)
3. Press **1** to set a shared secret (both sides need the same one)
4. Share your address + secret, one side listens, the other calls

Your destination key persists in `./data/docker/partyline/` across restarts.

## Quick Start: Always-On Relay

Run a persistent group bridge. Callers dial your `.b32.i2p` and are bridged together.

### docker-compose

Using the same `docker-compose.yml` above:

```bash
# Start relay in background (i2pd builds tunnels, group bridge opens)
docker compose up -d

# Watch live activity
docker compose logs -f

# Stop
docker compose down
```

### docker cli

```bash
docker run -d \
  --name i2p-party-line-relay \
  --restart unless-stopped \
  --security-opt label:disable \
  -v ./data/docker/partyline:/data/.partyline \
  -v ./secrets:/run/secrets:ro \
  -e SHARED_SECRET_FILE=/run/secrets/shared_secret.txt \
  marcusholtz/i2p-party-line:latest \
  relay
```

No audio mounts needed for relay mode (it forwards encrypted blobs, never decodes audio).

## Parameters

| Parameter | Function |
| :---: | --- |
| `-e SHARED_SECRET_FILE` | Path to secret file inside container. Default: `/run/secrets/shared_secret.txt` |
| `-e OPUS_BITRATE=16` | Opus encoding bitrate in kbps |
| `-e LISTEN_PORT=7777` | TCP listen port |
| `-e I2P_SOCKS_PORT=4457` | i2pd SOCKS proxy port (loopback-only) |
| `-e CIPHER=aes-256-cbc` | Encryption cipher (21 options) |
| `-e HMAC_AUTH=1` | HMAC-sign protocol messages (`0`/`1`) |
| `-e SINGLE_HOP=0` | Faster, less anonymous (`0`/`1`) |
| `-e AUTO_LISTEN=0` | Auto-listen when i2pd is ready (`0`/`1`) |
| `-e ALSA_DEVICE=` | Force ALSA capture device, e.g. `plughw:2,0` |
| `-e ALSA_PLAY_DEVICE=` | Force ALSA playback device, e.g. `plughw:0,0` |
| `-e PULSE_SERVER` | PulseAudio/PipeWire socket path |
| `-v /data/.partyline` | Config, I2P key, encrypted secret (persistent) |
| `-v /run/secrets` | Shared secret file (read-only mount) |
| `-v /run/user/$UID/pulse` | Host audio socket |
| `--device /dev/snd` | ALSA fallback for bare-ALSA hosts |

## Shared Secret

The secret is **not** an environment variable. It is a bind-mounted file:

```bash
mkdir -p secrets
echo -n 'your-shared-secret' > secrets/shared_secret.txt
chmod 600 secrets/shared_secret.txt
```

Per-run override: `docker compose run --rm partyline call <addr> --secret 'my-secret'`

A relay does not need a secret.

## Audio

Audio routes through the host's PulseAudio/PipeWire socket. ALSA direct (`/dev/snd`) is the fallback.

```bash
arecord -l    # find capture devices on the host
aplay -l      # find playback devices on the host
```

## Security

| Property | Detail |
| --- | --- |
| Encryption | AES-256-CBC + PBKDF2 + HMAC-SHA256 |
| Relay | Zero-knowledge: forwards blobs, never has the secret |
| Authentication | `.b32.i2p` address + pre-shared secret |
| Forward secrecy | None; rotate secrets between conversations |
| Source | Single bash script, no binaries, no telemetry |

## The Party Line Trifecta

Three networks, same app, same encryption:

| | | |
|---|---|---|
| [![I2P Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--invisible-internet-project-i2p-garlic-roter.jpg)](https://hub.docker.com/r/marcusholtz/i2p-party-line) | [![Reticulum Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--reticulum-network-stack.jpg)](https://hub.docker.com/r/marcusholtz/reticulum-party-line) | [![Tor Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--tor-onion-router-overlay-network.jpg)](https://hub.docker.com/r/marcusholtz/tor-party-line) |
| **I2P Party Line** | [Reticulum Party Line](https://hub.docker.com/r/marcusholtz/reticulum-party-line) | [Tor Party Line](https://hub.docker.com/r/marcusholtz/tor-party-line) |

## License

MIT
