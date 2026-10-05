<a href="https://gitlab.com/MarcusHoltz/i2p-party-line"><img src="https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--invisible-internet-project-i2p-garlic-roter.jpg" alt="I2P Party Line"></a>

<table><tr>
<td><a href="https://geti2p.net/"><img src="https://img.shields.io/badge/built%20for-I2P-ffc337?style=for-the-badge" alt="Built for I2P"></a></td>
<td><a href="https://distrobox.it/"><img src="https://img.shields.io/badge/distrobox-ready-blue?style=for-the-badge" alt="Distrobox"></a></td>
<td><a href="https://gitlab.com/MarcusHoltz/i2p-party-line/-/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="License: MIT"></a></td>
<td><a href="https://gitlab.com/MarcusHoltz/i2p-party-line"><img src="https://img.shields.io/badge/source-GitLab-orange?style=for-the-badge&logo=gitlab" alt="Source: GitLab"></a></td>
<td><a href="https://github.com/MarcusHoltz/i2p-party-line"><img src="https://img.shields.io/badge/source-GitHub-black?style=for-the-badge&logo=github" alt="Source: GitHub"></a></td>
</tr></table>

# marcusholtz/i2p-party-line-box

Distrobox-ready image for encrypted push-to-talk voice and group party line over [I2P](https://geti2p.net/en/docs/how/intro). No accounts, no phone numbers, no servers, no open ports.

Built for [Distrobox](https://distrobox.it/), not Docker Compose. Your mic, speakers, and network are shared with the container automatically. Ideal for immutable or atomic Linux distros (Bazzite, Silverblue, SteamOS, etc.).

> For Docker Compose or standalone Docker usage, see [`marcusholtz/i2p-party-line`](https://hub.docker.com/r/marcusholtz/i2p-party-line).

## Supported Architectures

| Architecture | Tag |
| :---: | --- |
| x86-64 | `amd64` |

## Quick Start

### Create and enter

```bash
distrobox create --image marcusholtz/i2p-party-line-box:latest --name partyline-i2p
distrobox enter partyline-i2p
```

### Run the party line

Once inside the container:

```bash
i2p-party-line.sh
```

### Add to the application menu

Optional. Once inside the container, run:

```bash
distrobox-export --app /usr/share/applications/i2p-party-line.desktop
```

Use the full path (`/usr/share/applications/tor-party-line.desktop`). 

"I2P Party Line (on partyline-i2p)" appears in your host application menu with its own icon and opens in a terminal. Remove it with the same command plus `--delete`.

To also run it from your host shell:

```bash
distrobox-export --bin /usr/local/bin/i2p-party-line.sh --export-path ~/.local/bin
```

### Alternative registries

```bash
# GitHub Container Registry
distrobox create --image ghcr.io/marcusholtz/i2p-party-line-box:latest --name partyline-i2p

# GitLab Container Registry
distrobox create --image registry.gitlab.com/marcusholtz/i2p-party-line/box:latest --name partyline-i2p
```

### One-command setup with distrobox.ini

A `distrobox.ini` manifest is included in the [source repo](https://gitlab.com/MarcusHoltz/i2p-party-line). It creates the container, exports `i2p-party-line.sh` to `~/.local/bin`, and adds no menu entries:

```bash
distrobox assemble create --file distrobox.ini
```

After assembly, run `i2p-party-line.sh` directly from your host shell.

For an application menu (`.desktop`) entry, uncomment the `exported_apps` line in `distrobox.ini` before assembling, or use the `distrobox-export` command above.

## First Run

1. i2pd reseeds and builds tunnels (~23 s for relay, ~86 s for calls from cold start)
2. Your `.b32.i2p` address appears (no ports needed; I2P routes through tunnel gateways)
3. Press **1** to set a shared secret (both sides need the same one)
4. Share your address + secret, one side listens, the other calls

Your destination key persists inside the distrobox home directory across restarts.

## What's Inside

Everything pre-installed, no first-run dependency installation needed:

- i2pd
- Opus codec, OpenSSL, socat
- PulseAudio utilities, ALSA utilities
- QR code generation (`qrencode`)
- `pcm_rms` (compiled C audio level meter)
- `i2p-party-line.sh` at `/usr/local/bin/`

## How It Differs from the Docker Image

| | Docker image | Distrobox image |
| --- | --- | --- |
| Image | `i2p-party-line` | `i2p-party-line-box` |
| Run with | `docker compose` / `docker run` | `distrobox create` + `distrobox enter` |
| Audio | PulseAudio socket bind-mount + `/dev/snd` | Automatic host audio passthrough |
| Network | Container networking | Host network (shared) |
| User mapping | Container root | Mapped to your host user |
| Entrypoint | Custom entrypoint | None (distrobox manages init) |

## Security

| Property | Detail |
| --- | --- |
| Encryption | AES-256-CBC + PBKDF2 + HMAC-SHA256 |
| Relay | Zero-knowledge: forwards blobs, never has the secret |
| Authentication | `.b32.i2p` address + pre-shared secret |
| Forward secrecy | None; rotate secrets between conversations |
| Source | Single bash script, no binaries, no telemetry |

## The Party Line Trifecta (Distrobox)

Three networks, same app, same encryption:

| | | |
|---|---|---|
| [![I2P Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--invisible-internet-project-i2p-garlic-roter.jpg)](https://hub.docker.com/r/marcusholtz/i2p-party-line-box) | [![Reticulum Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--reticulum-network-stack.jpg)](https://hub.docker.com/r/marcusholtz/reticulum-party-line-box) | [![Tor Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--tor-onion-router-overlay-network.jpg)](https://hub.docker.com/r/marcusholtz/tor-party-line-box) |
| **I2P Party Line** | [Reticulum Party Line](https://hub.docker.com/r/marcusholtz/reticulum-party-line-box) | [Tor Party Line](https://hub.docker.com/r/marcusholtz/tor-party-line-box) |

## License

MIT
