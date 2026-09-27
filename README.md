<h1 align="center">🧄 I2P Party Line</h1>

<p align="center">
  <strong>Encrypted push-to-talk voice &amp; group party line over I2P.</strong><br>
  No accounts. No phone numbers. No servers. No open ports. Garlic-routed end-to-end.
</p>


---



<p align="center">
  <img src="https://img.shields.io/badge/built%20for-I2P-ffc337" alt="Built on I2P">
  <img src="https://img.shields.io/badge/Supported%20on-Linux%20%7C%20macOS%20%7C%20Android%20%7C%20Docker-blue" alt="Supported Systems">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT">
  </p>

<p align="center">
  <a href="#-quickstart">Quick Start</a> ·
  <a href="#-what-youll-see">Terminal Screen</a> ·
  <a href="#-usage">Usage</a> ·
  <a href="#%EF%B8%8F-troubleshooting">Troubleshooting</a> ·
  <a href="#-reference">Reference</a> ·
  <a href="#-faq">FAQ</a>
</p>


---

## 👍 Overview

Enjoy the experience of a walkie-talkie over [I2P](https://geti2p.net/en/docs/how/intro).

Want to talk? Agree on a shared secret — hold a key, speak, release. The other side hears it.

---


## The Party Line Trifecta

Three networks, one app. The Party Line ships in triplicate. Same TUI, same encryption. Pick the transport that matches your threat model:

| | | |
|---|---|---|
| [![I2P Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--invisible-internet-project-i2p-garlic-roter.jpg)](/#) | [![Reticulum Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--reticulum-network-stack.jpg)](https://gitlab.com/MarcusHoltz/reticulum-party-line) | [![Tor Party Line](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/header/header--partyline--tor-onion-router-overlay-network.jpg)](https://gitlab.com/MarcusHoltz/tor-party-line) |
| **I2P Party Line** | [Reticulum Party Line](https://gitlab.com/MarcusHoltz/reticulum-party-line) | [Tor Party Line](https://gitlab.com/MarcusHoltz/tor-party-line) |


<p align="center">
  <a href="https://gitlab.com/MarcusHoltz/party-line-pager">
    <img src="https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/posts/party-line-pager--tor-i2p-rns-call-pager.svg" alt="PartylinePager" width="25%">
  </a>
</p>

 <img src="https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/refs/heads/main/assets/img/posts/party-line-pager--tor-i2p-rns-call-pager.svg" alt="PartylinePager" height="14"> **[PartylinePager](https://gitlab.com/MarcusHoltz/party-line-pager)** completes the suite: **Message** the party line **address** to anyone **subscribed** across **chat** networks Telegram, Matrix, Signal, IRC, XMPP, Mastodon, Email, and more.


---

## 🚀 Quickstart


### Script

Run the script. 

```bash
chmod +x i2p-party-line.sh && ./i2p-party-line.sh
```


---

### Docker

Run docker interactively.

```bash
docker compose run --rm partyline
```

The container runs as a non-root `partyline` user (uid 1000). No
separate entrypoint script is needed: the Dockerfile's inline
`ENTRYPOINT` drops privileges via `setpriv` and launches
`i2p-party-line.sh` directly.

> **Podman / rootless Docker:** works out of the box. One cosmetic
> gotcha: without `--userns=keep-id`, bind-mounted files (the
> `data/` directory) are owned by a subordinate uid on the host
> (e.g. 100999) instead of your user. The container itself is
> unaffected. To get host-owned files, pass `--userns=keep-id`:
>
> ```bash
> podman run --rm --userns=keep-id \
>   -v ./data:/data \
>   <image> i2p-party-line.sh
> ```


---

### On first run

1. ⏳ i2pd reseeds and builds tunnels — progress is shown on screen.
   Measured on a cold container: **~40 s** before a relay is callable,
   **~90 s** from nothing before you can place a call.

2. 🧄 Your permanent `.b32.i2p` address is generated and displayed

3. 🔑 Press **1** → set a shared secret (both callers need the same one)

4. 📡 Share your `.b32.i2p` + secret → one side listens, the other calls

The address appears almost immediately, but the app deliberately waits until
your destination is actually *published* before saying it is ready. That gap is
real (a published address is not the same as a reachable one), and announcing
readiness too early is what makes callers see an unexplained "not found".


---

## 📺 What You'll See

**Main menu** — after i2pd is up and your secret is set:

```text
  ╦┌─┐╔═╗  ╔═╗┌─┐┬─┐┌┬┐┬ ┬  ╦  ┬┌┐┌┌─┐
  ║╔═╝╠═╝  ╠═╝├─┤├┬┘ │ └┬┘  ║  ││││├┤
  ╩╚═╝╩    ╩  ┴ ┴┴└─ ┴  ┴   ╩═╝┴┘└┘└─┘
       Invisible Internet Project

  ───────────────────────────────────────────
  Address: jhqkryidp2cyfcil...b32.i2p
  Secret: ●  I2P: ●  Tunnels: 3-hop  Auto-listen: ●  PTT: [SPACE]
  ▸ Ready. Press 4 to listen, or 5 to call.

  ═══ SETUP ═══
  1 │ Set shared secret   (both ends need the same secret)
  2 │ Audio setup & test  (mic, speakers, diagnostics)
  3 │ Share my address    (QR code)
    ─────────────────────────────────────
  ═══ CALL ═══
  4 │ Listen for calls
  5 │ Call a .b32.i2p address
  6 │ Host party line     (relay / group bridge)
    ─────────────────────────────────────
  ═══ SYSTEM ═══
  7 │ Settings
  8 │ Status
  r │ Restart i2pd
  n │ New I2P address     (rotate)
    ─────────────────────────────────────
  0 │ Exit

  Select:
```

<table>
<tr>
<td width="50%" valign="top">

**In a call** — 1-to-1, connected:

```text
 CALL CONNECTED  jhqkryidp2cyfcil...b32.i2p

  ● Local cipher:  AES-256-CBC
  ● Remote cipher: AES-256-CBC

  Last sent:  --
  Last recv:  --
  Remote:     Idle

   Ready  [SPACE]=Talk [T]=Chat [S]=Settings [Q]=Hang up
```

</td>
<td width="50%" valign="top">

**Hosting a party line** — live caller count:

```text
 CALL CONNECTED

  ● Local cipher:  AES-256-CBC
  ● Mode:          RELAY (group call)

  Group:      4 callers

   Ready  [SPACE]=Talk [T]=Chat [S]=Settings [Q]=Hang up
```

</td>
</tr>
</table>


---

## 📖 Usage

Now that you're up and running... let's dive into how you can *really* use this I2P Party Line!


---

### Sharing your address + secret

Before a call, both people need your `.b32.i2p` address **and** the shared secret. 

```text
address: jhqkryidp2cyfcil...b32.i2p
secret: your-shared-secret-here
```

The safest handoff is a one-time link that self-destructs after a single read — the plaintext is never stored:

> Try [yopass.se](https://share.yopass.se) <--- click the link! It is free, open-source, and [self-hostable](https://github.com/jhaals/yopass).


---

### Menu reference

| Key | Action |
|-----|--------|
| 1 | Set shared secret (required before any call is heard) |
| 2 | Audio setup & test |
| 3 | Share my address (QR code) |
| 4 | Listen for a call |
| 5 | Call a `.b32.i2p` address |
| 6 | Host party line (group bridge) |
| 7 | Settings (cipher, bitrate, PTT mode, HMAC, I2P, audio, security) |
| 8 | Status (i2pd, address, reachability, config) |
| 0 | Exit |

- `r` restart i2pd · `n` rotate your address. Script-only: `9` install deps · `u` uninstall.



---

### In-call keys

| Key | Action |
|-----|--------|
| **Hold SPACE** | Record; sends on release (hold-to-talk) |
| **T** | Send encrypted text |
| **S** | Mid-call settings (fix audio, change push-to-talk) |
| **M** | Mute/unmute mic (full-duplex only) |
| **Q** | Hang up |

> **Hold-to-talk:** press SPACE, wait a beat, *then* speak; release to send. 

> Prefer tap-to-talk? Make that change! → **Settings → 4 (PTT mode) → toggle**: tap to start, tap to stop and send. Android uses toggle automatically (its keyboard fires on key release, not press).


---

### Script commands & flags

**command** picks the action; **flags** override options for that run.

```text
Commands: listen | call [ADDR] | relay | status | test | config | install | uninstall | help

  -s, --secret S        Shared secret this run (must match all parties)
      --save-secret     Persist --secret to disk (chmod 600)
  -a, --address ADDR    .b32.i2p to call
  -p, --port N          Listen / I2P destination port               [7777]
      --socks-port N    i2pd SOCKS port (loopback only)             [4457]
  -c, --cipher NAME     OpenSSL cipher (aes-256-cbc, chacha20…)    [aes-256-cbc]
  -b, --bitrate N       Opus bitrate kbps                           [16]
      --hmac            HMAC-sign protocol messages    (--no-hmac)        [on]
      --single-hop      1-hop tunnels (faster, no anon) (--no-single-hop) [off]
      --auto-listen     Auto-listen once i2pd is ready  (--no-auto-listen) [off]
      --dial-attempts N Retry initial dial N times                      [3]
      --dial-timeout N  Per-attempt SOCKS timeout in seconds            [40]
      --full-duplex    Live bidirectional audio (single-hop) (--no-full-duplex)[off]
      --start-muted    Begin full-duplex calls muted     (--no-start-muted)[on]
      --save            Persist all supplied options to config
  -h, --help   -V, --version
```

Full-duplex mode replaces push-to-talk with live bidirectional audio.
It requires `--single-hop` because standard I2P tunnel latency is too
high for continuous streaming. It also requires `python3` and `libopus`
(the shared library, not just the CLI tools). Half-duplex (walkie-talkie)
mode is pure shell and has no Python dependency. The dependency installer
(menu option 9) asks whether you want full-duplex and installs python3
if you say yes.

By default, full-duplex sessions start muted. Press **[M]** to unmute
when ready to speak. To start with the mic live, pass `--no-start-muted`
or toggle in **Settings > f (Start muted)**.

```bash
# Full-duplex mode (requires --single-hop for tolerable latency)
docker compose run --rm partyline listen --single-hop --full-duplex --secret 'shhhsecretshere'
docker compose run --rm partyline call <addr>.b32.i2p --single-hop --full-duplex --secret 'shhhsecretshere'
```


---

## 🔨 Troubleshooting

Say it isnt so, this script didnt work instantly? Woe is not without effort:


---

### Sharing address + secret

Getting your address and secret to someone, securely. Hand them a one-time link that self-destructs after one read. Both sides set the same secret (menu → **1**), then one listens, one calls.

> Visit: **[yopass.se](https://share.yopass.se)** → paste `address:` + `secret:`, set a 1-hour expiry, send the link. 


---

### No sound / silence on calls

Almost always the wrong input/output device. A device can "open" in a test and still be silent — only your ears decide.

1. **Find a working speaker:** Settings → 7 → Audio devices → **4 (Test all outputs)** plays white noise to each device in turn. On PipeWire/PulseAudio, pick *"System default output (server)"* first — it avoids the raw-ALSA device-busy trap where disconnected ports "play" silently. Enter the number you **actually hear**; that exact route is what live calls use.

2. **Verify:** Test audio pipeline — if you hear your voice, calls work.

3. **Still stuck:** Settings → 7 → **6 (Audio diagnostics)** shows the backend, the live call route, and any muted/0% sink (the common "command succeeds, nothing comes out" cause).

4. Or set the correct mic/speakers as the system default in your desktop sound settings (GNOME, KDE, `pavucontrol`). With nothing pinned, the app follows the system default. Multi-card box? `pactl info | grep Default` shows what's selected — mic and speakers can be on different cards.


---

### Remote hears nothing / red ● in call header

**Cipher mismatch** — decryption fails silently when both sides differ. Agree on the same cipher in Settings, or change mid-call via **S → Settings**.


---

### i2pd stuck / address never appears / "Building I2P tunnels…" forever

A cold start is roughly **40 s to be callable** and **~90 s to place a call**. If
it sits far past that, it is almost always **reseed**.

i2pd bootstraps by downloading a signed router list from one reseed server
picked at random, and that fetch has **no timeout** — a single black-holed
server wedges the router at `0 routers` indefinitely. You will see this in the
log, with no key ever being created:

```text
Reseed: Downloading SU3 from https://<some-host>/i2pseeds.su3
NetDbReq: No known routers, reseed seems to be totally failed
```

Two things already handle this for you:

- the app pins a **curated reseed list** (dead and hanging hosts removed)
  instead of trusting whatever list your distro's i2pd shipped with, and
- if no destination key appears within 100 s, it **restarts i2pd automatically**
  to re-roll the server choice, up to three times.

If it still fails, your network is likely blocking the reseed hosts. Check the
log directly:

```bash
# Docker
docker compose exec partyline tail -30 /data/.partyline/run/i2pd/i2pd.log
# Script
tail -30 data/script/run/i2pd/i2pd.log
```

Press **r** to restart i2pd by hand at any time.


---

### i2pd crashes immediately / "Aborted (core dumped)"

**Symptom:** `i2pd` exits with `Aborted (core dumped)` within a second
of launching. The log file is empty. The script reports
`[FAIL] i2pd exited unexpectedly`.

**Cause:** Debian and Ubuntu ship an AppArmor profile for i2pd
(`/etc/apparmor.d/usr.bin.i2pd`) that restricts the binary to only
write under `~/.i2pd/` or `/var/lib/i2pd/`. When you run the script
from another location (e.g. `~/Projects/...` or `~/Downloads/...`),
i2pd cannot create its internal directories and aborts.

**What the script does:** On startup it detects AppArmor confinement
and automatically redirects i2pd's ephemeral runtime data to
`~/.i2pd/partyline/`. This is the **only** file the script creates
outside the directory you ran it from. Your identity key, config,
shared secret, and everything else stays in `./data/script/` next to
the script.

The `~/.i2pd/partyline/` directory contains only throwaway data
(netDb, peer profiles, router logs) that is regenerated on every
start. The uninstaller (`./i2p-party-line.sh uninstall`) offers to remove
it.

**If you want to avoid the fallback entirely**, you can remove the
AppArmor profile and reload:

```bash
sudo rm /etc/apparmor.d/usr.bin.i2pd /etc/apparmor.d/local/usr.bin.i2pd
sudo systemctl reload apparmor    # or: sudo apparmor_parser -R /etc/apparmor.d/usr.bin.i2pd
```

After that, i2pd runs unconfined and all data stays in the script
directory.


---

### Call hangs on "Connecting..." but others connect fine

**Symptom:** One client sits at `Connecting... 38s (1/3)` while other
clients connect to the same relay immediately.

**Cause:** i2pd picked a degraded outbound tunnel for the SOCKS LeaseSet
lookup. The tunnel is alive enough that socat doesn't error, but too broken
to complete the lookup. This is an I2P network property: tunnels have a
10-minute lifetime and are continuously rebuilt, so quality varies.

**What the app does:** Automatically retries up to `DIAL_ATTEMPTS` times
(default 3), killing socat between attempts to force i2pd to re-roll its
outbound tunnel selection. Progress shows elapsed time and attempt number.
Most connections that fail on attempt 1 succeed on attempt 2.

**If all attempts fail:** The peer is probably offline or unreachable. Check
that their i2pd is running and their destination is published.

**Tuning:** `--dial-timeout` controls how long each attempt waits (default
40s, research-backed for I2P timing). `--dial-attempts` controls how many
retries. Lower timeout = faster feedback loop but risks killing attempts
that would have succeeded. Persist with `--save`.


---

### Docker: first call after relay start fails to connect

**Symptom:** Client shows `Connecting...` then `[FAIL] Failed to connect` when
calling a relay that just started.

**Cause:** I2P LeaseSet propagation. A freshly started relay needs 3-5 minutes
for its destination to propagate across the I2P network. The relay shows
"Relay active" before remote nodes can actually route to it.

**Fix:** Wait 3-5 minutes after the relay reports "Relay active", then try
again. Subsequent calls connect immediately. This is an I2P network property,
not a code bug.


---

### Android call drops with the screen off

The app holds a partial wakelock via `termux-wake-lock` ([Termux:API](https://github.com/termux/termux-api)). Without it, Android deep-sleeps the process mid-call.

1. Install **Termux:API** from [F-Droid](https://f-droid.org/en/packages/com.termux.api/) (not the Play Store), then `pkg install termux-api` — without it the mic won't work either.

2. Android Settings → Apps → Termux → Battery → **Unrestricted**.

3. Genuine drops auto-reconnect silently up to `RECONNECT_ATTEMPTS` times.


---


## I hear a brief pause mid-message on Android

Nothing is wrong. Messages longer than `PTT_CHUNK_SECONDS` (default 10 s) are split into chunks and played back sequentially. On Android/Termux there is a ~300 ms gap between chunks while the media player loads to the next file — the audio resumes exactly where it left off.


---

### Running automated headless deployments

Skip the menu. Pass flags directly. No interactive prompts. Works on Docker and Script.


#### Run-once commands, removed when done

`docker compose run --rm` runs, exits when complete, as if running the script.

```bash
# Place a call
docker compose run --rm partyline call jhqkryidp2cyfcilgmbi37uh4ralpamymscbc6466llrdvntbo5a.b32.i2p --secret 'shhhsecretshere'

# 1-to-1: listen for an incoming call
docker compose run --rm partyline listen --secret 'shhhsecretshere'

# Diagnostics
docker compose run --rm partyline test
docker compose run --rm partyline status
```


#### Save some settings, then run without those flags

```bash
docker compose run --rm partyline config --secret 'shhhsecretshere' --port 7777 --hmac --save
docker compose run --rm partyline call jhqkryidp2cyfcilgmbi37uh4ralpamymscbc6466llrdvntbo5a.b32.i2p
```
> a .b32.i2p address is required per call; everything else above is saved and remembered


#### Compose up starts group bridge on auto-restart

By default, if you bring up this project it starts the relay, an always-on group bridge: callers dial your `.b32.i2p` and are bridged together... in a PARTY LINE!

`docker compose up -d` starts the group bridge directly — when no command is given and there is no interactive terminal attached (i.e. detached mode), the container auto-selects relay mode:

```bash
docker compose up -d       # start relay in background (i2pd builds tunnels, group bridge opens)
docker compose logs -f     # watch live activity
docker compose restart     # reload without losing your .b32.i2p address
docker compose down        # stop everything
```



#### Running this script detached, no auto-restart

You can apply any of the script's commands:

```bash
docker compose run -d partyline relay
```

To reattach to the running container's interactive session:

```bash
docker attach <container_id_or_name>
```

- Press **Ctrl+P then Ctrl+Q** to detach again without stopping the container.
- **Ctrl+C** will terminate the process inside the container — use with caution.

> Script usage is identical: `./i2p-party-line.sh call <address> --secret 'shhhsecretshere'`. For more info, see [Configuration & defaults](#config-and-defaults)


---

### Anti-flood limits

Tune any of these in the [Reference](#-reference) tables.

- Push-to-talk **auto-stops at `MAX_PTT_SECONDS`** (default 120 s) even if you keep holding — release and press again to continue. A clip over the size cap shows **`too long`** instead of sending. 

- Text messages are length-capped, and on a group call the relay **rate-limits each caller** (default 15 messages), so holding a key down or pasting a wall of text won't flood or mute the room — the excess is silently dropped. 


---


### Environment variable use

Environment variable take a precedence order: 

1. built-in defaults

2. .env

3. saved config

4. CLI flags


---

## 📚 Reference

<details>
<summary><strong>Audio setup (all platforms)</strong></summary>

<br>

| Platform | Backend | Device selection |
|----------|---------|-----------------|
| Linux Script | PipeWire → PulseAudio → ALSA (auto) | Desktop sound settings, in-app picker, or env vars |
| Linux Docker | ALSA direct | In-app picker or env vars |
| Android/Termux | termux-microphone-record + ffplay | OS routes automatically |
| macOS | ffmpeg (AVFoundation) | System Settings → Sound |

**Linux — in-app picker:** Settings → 7 → Audio devices. Lists devices by friendly name and offers *System default* (routes through your sound server to whatever you selected in your desktop settings — right for almost everyone). `← current` marks the active device; `[HDMI]` flags display-audio outputs.

**Backend order:** sound server (`parecord`/`paplay`, works with both [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) and [PipeWire](https://pipewire.org/)) → [ALSA](https://www.alsa-project.org/) direct. The app records a brief probe first; if the server corks the stream (Docker, headless, no socket), detection falls through to ALSA.

**Why the sound server wins on multi-card desktops:** ALSA opens capture devices in card order and picks the first that *opens* — but every card opens even with no mic attached, so it often picks the wrong one. The sound server already knows your selected default.

**Verify the full pipeline:**
```bash
docker compose run --rm partyline test   # Docker
./i2p-party-line.sh test                       # Script
```
Records 3 s, Opus-encodes, encrypts, decrypts, plays back. Hear yourself = the whole pipeline works. Output shows the backend used (e.g. `Playing back via pw-play`). Probing order: `pw-play` → `paplay` → `aplay -D default`/`pulse` → raw `plughw` (raw last — when PipeWire/PulseAudio owns the card, direct `plughw` hits `EBUSY`).

No sound-server tools at all?
```bash
sudo apt install pulseaudio-utils pipewire-bin   # Debian/Ubuntu
sudo dnf install pulseaudio-utils                # Fedora
```
Or menu → 9 (install dependencies).

**Forcing a specific ALSA device** (headless / bare-ALSA / Docker) — setting these env vars forces ALSA-direct and bypasses the sound server:
```bash
ALSA_DEVICE=plughw:1,0 ./i2p-party-line.sh    # Script, inline
# Docker: set in .env (copy .env.example first)
ALSA_DEVICE=plughw:0,0        # mic
ALSA_PLAY_DEVICE=plughw:0,0   # speakers
```
Find the numbers on the **host** (not inside Docker): `arecord -l` (mics), `aplay -l` (speakers). Format is `plughw:CARD,DEVICE`. Use `plughw:`, not `hw:` — the plug layer converts sample rates automatically; `hw` requires an exact match and fails otherwise. The in-app picker overrides `.env`.

**Android / Termux:** the OS controls routing — no per-device selection. Needs Termux + **Termux:API from F-Droid**, then `pkg install termux-api`. Bluetooth: pair in Android settings, enable the **Headset / HFP** profile for a mic (A2DP is music-only). Audio stuck on phone speaker → toggle Bluetooth off/on.

**macOS:** select input/output in **System Settings → Sound** before launch. [`ffmpeg`](https://ffmpeg.org/) routes through [AVFoundation](https://developer.apple.com/av-foundation/)/CoreAudio automatically. Apple Silicon under Rosetta: [Homebrew](https://brew.sh/) runs with `arch -arm64` transparently — no action needed.

</details>




<details id="config-and-defaults">
<summary><strong>Configuration & defaults</strong></summary>

<br>

Settings precedence (lowest → highest): **built-in defaults → `.env`** (Docker only) **→ saved config** (`data/.partyline/config`) **→ CLI flags**.

| Parameter | Default | Description |
|-----------|---------|-------------|
| `LISTEN_PORT` | `7777` | TCP port for incoming connections |
| `I2P_SOCKS_PORT` | `4457` | i2pd SOCKS proxy port. **Loopback only**, never exposed |
| `SINGLE_HOP` | `0` | 1-hop tunnels — much faster, but you lose your own anonymity (`0`/`1`) |
| `I2P_HOPS` | `3` | Tunnel hops each way when `SINGLE_HOP=0` (i2pd's own default) |
| `I2P_HOPS_FAST` | `1` | Tunnel hops each way when `SINGLE_HOP=1` |
| `I2P_HANDSHAKE_TIMEOUT` | `25` | Seconds to wait for a dialed peer's first line before declaring it unreachable |
| `OPUS_BITRATE` | `16` | Opus encoding bitrate (kbps) |
| `CIPHER` | `aes-256-cbc` | Encryption cipher |
| `AUTO_LISTEN` | `0` | Start listening automatically once i2pd is ready |
| `PTT_KEY` | `SPACE` | Push-to-talk key |
| `PTT_TOGGLE_MODE` | `0` | `0` = hold-to-talk, `1` = tap-start/tap-stop toggle |
| `HMAC_AUTH` | `1` | HMAC-sign all protocol messages (both sides must match) |
| `OVERWRITE_DELETE` | `0` | Overwrite temp files with random bytes before deletion |
| `SAMPLE_RATE` | `8000` | Audio sample rate (Hz) |
| `ALSA_DEVICE` | *(empty)* | Force a specific ALSA capture device (e.g. `plughw:1,0`); bypasses sound server |
| `ALSA_PLAY_DEVICE` | *(empty)* | Force a specific ALSA playback device (e.g. `plughw:0,0`); bypasses sound server |
| `PULSE_SOURCE` | *(empty)* | PipeWire/PulseAudio capture device name; empty = system default |
| `PULSE_SINK` | *(empty)* | PipeWire/PulseAudio playback device name; empty = system default |
| `RELAY_IDLE_TIMEOUT` | `240` | Drop a caller after this many seconds of total silence |
| `HEARTBEAT_INTERVAL` | `20` | Keepalive PING interval; keep well below `RELAY_IDLE_TIMEOUT` |
| `CLIENT_TIMEOUT` | `180` | No inbound traffic this long = dropped; tear down + reconnect |
| `RECONNECT_ATTEMPTS` | `3` | Silent re-dials after a drop; `0` disables auto-reconnect |
| `DIAL_ATTEMPTS` | `3` | Retry initial dial this many times before giving up (re-rolls the outbound tunnel on each retry) |
| `DIAL_TIMEOUT` | `40` | Per-attempt SOCKS connect timeout in seconds; I2P LeaseSet lookup + tunnel build typically lands in 15-30 s |
| `MAX_PTT_SECONDS` | `120` | Hard cap on one push-to-talk transmission; recorder self-stops at the limit |
| `MAX_AUDIO_B64` | `MAX_LINE_BYTES` | Sender skips an AUDIO blob over this (base64 bytes); inherits from `MAX_LINE_BYTES` if unset |
| `MAX_LINE_BYTES` | `524288` | Relay drops any inbound line larger than this before forwarding |
| `MAX_MSG_B64` | `65536` | Receiving client drops a text MSG whose base64 exceeds this |
| `RELAY_MAX_MSG_PER_SEC` | `15` | Relay drops a caller's messages beyond this rate (anti-flood; one caller can't mute the rest) |
| `RELAY_MAX_INFLIGHT` | `64` | Caps concurrent background forwards per caller (fork-bomb guard) |
| `RELAY_WRITE_TIMEOUT` | `30` | Seconds before the relay abandons a write to a stalled client |
| `DECRYPT_TIMEOUT` | `10` | Seconds before killing a stalled `openssl` decrypt process |
| `PTT_CHUNK_SECONDS` | `10` | Split PTT audio into chunks of this many seconds before encoding and sending |

`.env` is read **only by Docker Compose** (the script ignores it). Copy `.env.example` and edit. Every flag has a matching `.env` variable; booleans are `0`/`1`:

| CLI flag | `.env` var | Default |
|----------|-----------|---------|
| `-p, --port` | `LISTEN_PORT` | `7777` |
| `--socks-port` | `I2P_SOCKS_PORT` | `4457` |
| `-b, --bitrate` | `OPUS_BITRATE` | `16` |
| `-c, --cipher` | `CIPHER` | `aes-256-cbc` |
| `--hmac` | `HMAC_AUTH` | `1` |
| `--single-hop` | `SINGLE_HOP` | `0` |
| `--auto-listen` | `AUTO_LISTEN` | `0` |
| `--dial-attempts` | `DIAL_ATTEMPTS` | `3` |
| `--dial-timeout` | `DIAL_TIMEOUT` | `40` |
| `-s, --secret` | *(use Docker secret -- see below)* | -- |

Audio (`ALSA_DEVICE`, `ALSA_PLAY_DEVICE`, `PULSE_SOURCE`, `PULSE_SINK`, `XDG_RUNTIME_DIR`), keep-alive tuning (`RELAY_IDLE_TIMEOUT`, `HEARTBEAT_INTERVAL`, `CLIENT_TIMEOUT`, `RECONNECT_ATTEMPTS`), dial retry (`DIAL_ATTEMPTS`, `DIAL_TIMEOUT`), and the anti-flood limits (`MAX_PTT_SECONDS`, `MAX_AUDIO_B64`, `MAX_LINE_BYTES`, `MAX_MSG_B64`, `RELAY_MAX_MSG_PER_SEC`, `RELAY_MAX_INFLIGHT`, `RELAY_WRITE_TIMEOUT`) are also `.env`-settable — see `.env.example`.

</details>




<details id="shared-secret-docker">
<summary><strong>Shared secret (Docker)</strong></summary>

<br>

The shared secret is deliberately **not** an environment variable — env values leak via `docker inspect`, `/proc/<pid>/environ`, and logs. Instead the `secrets/` directory is **bind-mounted read-only** into the container and the app reads the secret from a file.

`secrets/shared_secret.txt` is **git-ignored**, so your real secret is never tracked or committed. An absent or empty file means "no secret set" — a relay needs none, and `--secret` always takes precedence.

```bash
# Per run (overrides the file):
docker compose run --rm partyline call <address> --secret 'your-secret'

# Or persist once (used by every run, including up -d):
echo -n 'your-secret' > secrets/shared_secret.txt   # -n strips the trailing newline
chmod 600 secrets/shared_secret.txt
```

`docker-compose.yml` already wires it up:

```yaml
services:
  partyline:
    volumes:
      - ./secrets:/run/secrets:ro                          # dir mounted read-only; the file is optional
    environment:
      - SHARED_SECRET_FILE=/run/secrets/shared_secret.txt  # app reads from here
```

> A directory bind mount is used on purpose: a Compose `secrets:` file source must exist or `docker compose up` fails, which would force the secret file to be committed. Mounting the directory works on a fresh clone even when the file doesn't exist yet.

**Precedence (highest first):** `--secret` flag → `SHARED_SECRET_FILE` (the bind-mounted file) → saved secret (`data/script/shared_secret`) → interactive prompt. The `secrets/` directory is git-ignored (only an empty `.gitkeep` is tracked), so your real secret is never committed.

**SELinux (Fedora/RHEL):** `docker-compose.yml` sets `security_opt: label:disable`, which runs the container as `spc_t` (unconfined) — that's what lets it read the secrets mount without a `:z` relabel. It also covers PulseAudio socket access. Without it you'd see an AVC denial on the secrets file.

Rebuild after a code change: `docker compose build`.

</details>








<details>
<summary><strong>Running Script (no Docker)</strong></summary>

<br>

```bash
chmod +x i2p-party-line.sh
./i2p-party-line.sh
```

Auto-detects your platform and offers to install dependencies via your package manager (you're asked before anything is installed). Undo everything with `./i2p-party-line.sh uninstall`.

| Platform | Package manager | Audio |
|----------|----------------|-------|
| Debian / Ubuntu | apt | PulseAudio/PipeWire (`parecord`/`paplay`), ALSA fallback |
| Fedora / CentOS | dnf | PulseAudio/PipeWire, ALSA fallback |
| Arch / Manjaro | pacman | PulseAudio/PipeWire, ALSA fallback |
| openSUSE | zypper | PulseAudio/PipeWire, ALSA fallback |
| Void Linux | xbps | PulseAudio/PipeWire, ALSA fallback |
| Alpine Linux | apk | PulseAudio/PipeWire, ALSA fallback |
| macOS | Homebrew (auto-installed) | ffmpeg |
| Android/Termux | `pkg` | termux-microphone-record |

</details>




<details>
<summary><strong>What gets installed (Script only)</strong></summary>

<br>

Docker bundles everything — skip this. Script/Termux: the script asks before installing. None of these phone home; all are standard open-source tools.

| Package | What it does |
|---------|-------------|
| [**i2pd**](https://i2pd.website/) | The I2P router. Creates your `.b32.i2p` destination and garlic-routes all traffic. Packaged on Debian 13+, Arch, Alpine, Void, Homebrew, and Termux natively. Fedora needs a [COPR](https://copr.fedorainfracloud.org/coprs/supervillain/i2pd/), Ubuntu needs a [PPA](https://launchpad.net/~purplei2p/+archive/ubuntu/i2pd); the installer enables these automatically |
| [**opus-tools**](https://opus-codec.org/) (`opusenc`/`opusdec`) | Compresses voice ~10× to suit I2P's bandwidth and latency |
| [**socat**](http://www.dest-unreach.org/socat/) | Moves audio through the i2pd SOCKS proxy — the wire between callers |
| [**openssl**](https://www.openssl.org/) | AES-256-CBC encryption + HMAC-SHA256 signing, and the SHA-256 used to derive your address offline |
| **pulseaudio-utils** (`parecord`/`paplay`) | Sound-server audio (PulseAudio + PipeWire) |
| **alsa-utils** (`arecord`/`aplay`) | ALSA direct fallback (headless/Docker) |
| [**ffmpeg**](https://ffmpeg.org/) / **ffplay** | Audio on macOS (AVFoundation) and Android/Termux |
| [**qrencode**](https://fukuchi.org/works/qrencode/) | `.b32.i2p` QR code in the terminal (optional, on first use) |
| **termux-api** *(Android only)* | Mic access + `termux-wake-lock`. Install from F-Droid |

</details>




<details>
<summary><strong>Party line capacity</strong></summary>

<br>

I2P bandwidth and latency are the bottleneck. A 10-second voice message is
~20 KB encrypted, fanned out to N-1 listeners. For reference, measured on the
live network between two firewalled routers: **512 KB transfers in ~9 s**, and
round-trip latency is a **~1.45 s median with a ~10.6 s worst case**. That tail
is why PTT (send a clip, then listen) works here and full-duplex would not.

| Callers | Outbound per message | Expected experience |
|---------|---------------------|---------------------|
| 2–3 | 20–40 KB | Reliable on most connections |
| 3–5 | 40–80 KB | Good; occasional delay on mobile data |
| 5–10 | 80–180 KB | Pushing limits; noticeable delays |
| 10+ | 180 KB+ | Unreliable; queuing and message loss |

Realistic ceiling: **3–5 callers** on a phone (Termux), **5–10** on a wired Linux machine. Lower the Opus bitrate (Settings → Opus encoding) to help at higher counts.

</details>




<details>
<summary><strong>Settings that require a restart</strong></summary>

<br>

These are written into the generated `i2pd.conf` / `tunnels.conf`, which are
re-created from your settings on every start:

- **Single-hop mode / tunnel length** — Settings → I2P settings → Single-hop mode
- **Ports** — Settings → I2P settings → Configure ports, or `LISTEN_PORT` in `.env` (one port per identity; i2pd silently routes any other inbound port to this one instead of erroring, so don't rely on a second port for a second service)

Press **r** in the main menu to restart i2pd and apply them. Your address is
**not** affected by a restart — it lives in `partyline-keys.dat`, which is the
only transport state that persists.

Everything else (cipher, bitrate, HMAC, PTT mode) takes effect immediately, even mid-call.

</details>




<details>
<summary><strong>Security model</strong></summary>

<br>

| Property | Notes |
|----------|-------|
| **Encryption** | AES-256-CBC + [PBKDF2](https://datatracker.ietf.org/doc/html/rfc8018) (10k iterations). 21 cipher options (AES/Camellia/ARIA in CBC/CTR + AES-256 in CFB/OFB + ChaCha20). No AEAD/GCM: [`openssl enc`](https://www.openssl.org/docs/man3.0/man1/openssl-enc.html) can't stream them. |
| **Secret storage** | Shared secret encrypted at rest; passphrase required to load. |
| **HMAC signing** | Optional. Cryptographically signs every protocol message; prevents replay attacks. |
| **Overwrite before delete** | Optional (Settings → Security). Random-overwrites every temp file (recordings, chunks, payloads, nonce logs) before deletion. **SSD caveat:** wear-leveling defeats this — full-disk encryption ([LUKS](https://gitlab.com/cryptsetup/cryptsetup)/[FileVault](https://support.apple.com/en-us/102650)) is the only reliable defense against physical recovery. |
| **Zero-knowledge relay** | Forwards encrypted blobs. Never receives the shared secret. Cannot decrypt audio. |
| **No forward secrecy** | Compromise of the shared secret exposes all calls made with it. Rotate secrets between sensitive conversations. |
| **Authentication** | Callers identified by `.b32.i2p` address + pre-shared secret. No certs, no key exchange, no accounts — anyone with the secret can call in. |
| **Flood / DoS protection** | The relay holds no secret, so it can't verify traffic — instead it **rate-limits each caller** (`RELAY_MAX_MSG_PER_SEC`, default 15/s) and **drops oversized or excess messages** before fan-out, so no one caller can flood, mute, or fork-bomb the group. The sender also **caps push-to-talk length** (`MAX_PTT_SECONDS`, default 120 s), **audio size** (`MAX_AUDIO_B64`), and **text length**; receivers drop messages over `MAX_MSG_B64`. All tunable via `.env` — see [Configuration](#-reference). These drops are **intentional**, not bugs. |

</details>




<details id="-architecture">
<summary><strong>Architecture & code map</strong></summary>

<br>

**Audio pipeline** — push-to-talk, half-duplex: one complete recording per PTT press, sent as a single packet. No live streaming.

```text
SENDER                                          RECEIVER
──────                                          ────────
Microphone                                      Speaker
    │                                               ▲
    ▼                                               │
Raw PCM (8 kHz, 16-bit, mono)                   Opus decode
    │                                               ▲
    ▼                                               │
Opus encode (16 kbps)                           AES-256-CBC decrypt
    │                                               ▲
    ▼                                               │
AES-256-CBC encrypt                             Base64 decode
    │                                               ▲
    ▼                                               │
Base64 ──▶ socat ──▶ I2P ──▶ socat ──▶ Receive
```

**Wire protocol** — line-based text over an I2P stream (the streaming library gives us a reliable, in-order, congestion-controlled byte stream, so this is unchanged from the Tor edition):

| Message | Meaning |
|---------|---------|
| `ID:<b32>` | Sender's `.b32.i2p` address |
| `CIPHER:<name>` | Sender's active cipher (on connect + on change) |
| `PTT_START` / `PTT_STOP` | Recording start/end boundaries |
| `AUDIO:<base64>` | Complete encrypted audio message |
| `MSG:<base64>` | Encrypted text message |
| `HANGUP` / `PING` | Disconnect / keepalive |
| `RELAY:1` | Relay greeting → triggers group mode on the receiver |
| `GROUP:<n>` | Group size update, broadcast when callers join or leave |

> **Cipher mismatch:** decryption fails silently when both sides differ. The call header shows a red ● when the exchanged `CIPHER:` values don't match. Fix via **S → Settings** mid-call.

**Container layout:**

```text
docker compose run --rm partyline
        │
        ▼
[i2p-party-line.sh]  (ONE script — no separate entrypoint)
  Dockerfile ENTRYPOINT drops to non-root partyline user (uid 1000)
  via setpriv, then launches i2p-party-line.sh directly.

  1. Generate run/i2pd/i2pd.conf + tunnels.conf from saved config
  2. Symlink partyline-keys.dat into the ephemeral i2pd datadir
  3. i2pd --datadir=... --conf=... --tunconf=... --certsdir=... &
  4. Derive the .b32.i2p address from the key file (no router needed)
  5. Wait until the destination is PUBLISHED, by dialing our own
     dead-end probe port through our own SOCKS proxy
  6. Run the menu / relay / call
        │
        ▼
  Codec:    opusenc / opusdec  (8 kHz, 16 kbps, speech)
  Encrypt:  openssl enc aes-256-cbc -pbkdf2 -iter 10000
  HMAC:     openssl dgst -sha256 -hmac  (optional)
  Transport: socat SOCKS4A:127.0.0.1:4457 (outbound via i2pd)
             socat TCP-LISTEN:7777        (inbound via i2pd server tunnel)
  QR code:  qrencode -t ANSIUTF8

[Volumes]  — one bind mount, not two
  ./data/docker/partyline (bind mount) → /data/.partyline
        partyline-keys.dat   your destination key — the ONLY persistent transport state
        address              cached .b32.i2p (re-derivable from the key at any time)
        config, secret       app settings
        run/i2pd/            EPHEMERAL: netDb, peer profiles, router identity, logs.
                             Discarded every restart on purpose — see below.

[Ports]  none published, none forwarded, none opened
```

**`docker/` folder:** Contains only CI hooks (`hooks/audit-pins.sh`,
`hooks/update-pins.sh`) for validating and updating Dockerfile pins. No
entrypoint script: i2p's setup is simple enough to inline in the
Dockerfile `ENTRYPOINT`.

**Code map** — all logic lives in `i2p-party-line.sh` (5 452 lines total). There is
no second script: unlike the Tor edition there is no `entrypoint.sh`, because
this file owns the i2pd lifecycle in Docker and script mode alike.

| Lines | Contents |
|-------|---------|
| 1–209 | Config globals, Docker/script detection, ephemeral-vs-persistent paths, colors, platform setup |
| 210–645 | Core helpers: logging, config load/save, dep check, package-manager wrappers |
| 646–796 | Audio backend detection (`detect_audio_backend`, `_server_available`, ALSA probes) |
| 797–1069 | Dependency install/uninstall (`install_deps`, `uninstall_all`) |
| 1070–1130 | I2P transport preamble: certs dir discovery, SOCKS port bump, tunnel-hop selection |
| 1131–1296 | `setup_i2pd` (generates `i2pd.conf` + `tunnels.conf`), `_i2pd_spawn`, `_i2p_selfdial_ok` |
| 1297–1409 | `_i2pd_wait_ready` (readiness gate + reseed watchdog), `start/stop_i2pd` |
| 1410–1478 | Address handling: `_derive_address` (offline b32 from the key file), `get_address`, `rotate_address` |
| 1479–1743 | Secrets, cipher helpers, encryption, HMAC protocol signing |
| 1744–2346 | Audio pipeline: record, play, PTT send/stop, cleanup, auto-listener, wakelock |
| 2347–2640 | `listen_for_call`, `_dial_remote`, `call_remote` |
| 2641–3004 | Relay mode and the generated `handler.sh` (`relay_mode`, `broadcast_count`) |
| 3005–3490 | `in_call_session` - handshake/dial gate, PTT event loop, receive handler |
| 3491–3833 | `test_audio`, `show_status` |
| 3834–4333 | Audio device menus: picker, Android flow, output tester, diagnostics |
| 4334–4870 | Settings menus: Opus, PTT, ports, `settings_i2p`, single-hop |
| 4871–4944 | Security settings and banner |
| 4945–5237 | `main_menu` |
| 5238–5452 | CLI parsing, entry point |

**The two transport seams.** Everything I2P-specific reduces to where `socat`
points:

- **inbound** — `relay_mode` runs `socat TCP-LISTEN:$LISTEN_PORT,fork` into the
  generated `handler.sh`, exactly as the Tor edition did. i2pd's `type = server`
  tunnel forwards inbound I2P streams there. `handler.sh` has no idea a
  transport exists.
- **outbound** — `_dial_remote` runs
  `socat SOCKS4A:127.0.0.1:<peer>.b32.i2p:$LISTEN_PORT,socksport=$I2P_SOCKS_PORT`.
  Same address form Tor used; only host, port and address syntax changed.

There is no bridge process and no Python. The Reticulum edition needed a
640-line transport shim for this; I2P needs none, because i2pd already provides
a real reliable byte stream under a SOCKS/tunnel abstraction.

</details>


---

## ❓ FAQ

**Can the relay or anyone in the middle hear me?**
No — audio is encrypted end-to-end before it hits the network, and the relay never receives the shared secret.

**Do I need port forwarding?**
No, and this is the single best reason to use this over the Tor edition's
equivalent claim: it is measured, not assumed. I2P destinations are reached
through inbound tunnels whose gateways are *other people's routers*, so your own
router never needs to be dialable. Both test instances reported
`Firewalled - Symmetric NAT` and published no reachable address at all, and calls
worked. NAT, CGNAT, and firewalls are all fine.

**Can someone find my IP?**
No — garlic routing hides both ends (3 hops each way, each direction). (Exception: single-hop mode, off by default, trades your own anonymity for speed. Callers keep their 3 hops regardless.)

**Why push-to-talk instead of a real phone call?**
I2P latency makes full-duplex unreliable: the median round trip is ~1.45 s and the worst case measured was ~10.6 s. PTT sends a complete clip per transmission, which survives that comfortably. Expect a few seconds of end-to-end latency — that's the network, not the app.

**Do I need an account or phone number?**
None. Your identity is your `.b32.i2p` address; authentication is the shared secret.

**How do I audit it?**
Read `i2p-party-line.sh` — one Bash file, [code map](#-architecture) above. No binaries, no telemetry, no network calls except via I2P (plus i2pd's own reseed on first run).

**Do I need to forward a port or have a public IP?**
No. Neither, ever. See [Overview](#-overview) — this is the whole point of the
I2P transport, and it is verified behind symmetric NAT with nothing published.

**What does I2P NOT protect against?**
No forward secrecy (rotate secrets regularly). It does not hide *that* you are
using I2P from someone watching your link — I2P has no pluggable-transport /
bridge layer the way Tor does, so if concealing I2P use itself matters to you,
this is the wrong tool. SSDs defeat overwrite-on-delete — use full-disk
encryption.

**Is it legal?**
I2P and end-to-end encryption are legal in most countries. Comply with your local law.


---

## 🔀 Alternatives

Here are some other related projects:

| Tool | Hides IP | No account | Voice | Group | Notes |
|------|:---:|:---:|:---:|:---:|------|
| **🧄 I2P Party Line** *(this)* | ✅ I2P | ✅ | ✅ PTT | ✅ | Terminal, single script; PTT default; full-duplex with --single-hop; no ports |
| [Tor Party Line](https://github.com/MarcusHoltz/tor-party-line) | ✅ Tor | ✅ | ✅ PTT | ✅ | Same app over Tor onion services |
| [Mumble](https://www.mumble.info/) | ❌ | ✅ | ✅ full-duplex | ✅ | Low-latency, required software |
| [Jami](https://jami.net/) | ⚠️ P2P | ✅ | ✅ full-duplex | ✅ | Serverless GUI; metadata via DHT |
| [Briar](https://briarproject.org/) | ✅ Tor | ✅ | ❌ | ✅ | Tor messaging, no voice |
| [Cwtch](https://cwtch.im/) | ✅ Tor | ✅ | ❌ | ✅ | Metadata-resistant text, no voice |
| [Signal](https://signal.org/) | ❌ | ❌ | ✅ full-duplex | ✅ | Great E2EE; needs a phone number |
| [OnionShare](https://onionshare.org/) | ✅ Tor | ✅ | ❌ | ⚠️ | Tor files + chat, not voice |


---

## 🔐 Security Audit Notes

Audited 2026-09-03. No critical issues found. The script uses
sound security practices throughout.

### Positive findings

- **No `eval` or `source`**: the script never executes
  dynamically constructed code or sources external files.
- **Secret handling via fd:3**: the room secret is passed to
  `openssl` through a here-string on file descriptor 3, never
  as a CLI argument (which would leak into `/proc/*/cmdline`).
- **Restrictive file permissions**: sensitive files (FIFO pipes,
  secret storage) are created with `chmod 600` or written inside
  `umask 077` blocks.
- **HMAC authentication**: every voice packet is signed with
  `openssl dgst -sha256 -hmac` using a nonce and replay
  detection via sequence numbers. Packets with invalid or
  replayed signatures are silently dropped.
- **Quoted heredocs**: all heredocs that embed secrets use the
  quoted form (`<<'EOF'`) to prevent variable expansion.
- **No credential leakage**: connection strings, secrets, and
  keys are never logged, echoed, or written to world-readable
  paths.
- **Untrusted relay**: the room secret is discarded after
  tunnel setup. The relay operator cannot decrypt traffic.

### Low-severity observations

- **HMAC timing**: `openssl dgst` comparison uses a string
  equality check, which is theoretically vulnerable to timing
  side-channels. Practically unexploitable over I2P (latency
  jitter dwarfs any timing signal), but noted for completeness.
- **FIFO permissions**: named pipes are created with default
  umask, then `chmod 600` is applied. A brief window exists
  between creation and chmod. Mitigated by the script running
  inside a container with no other users.

### Cross-repo relationship

Three sibling projects share approximately 80% of their code
(~4,600 lines, 109 of ~130 functions are identical):

| Project | Transport | Key difference |
|---------|-----------|----------------|
| [Tor Party Line](https://github.com/MarcusHoltz/tor-party-line) | Tor hidden services | Trusted relay (secret written to relay host) |
| **I2P Party Line** *(this)* | i2pd tunnels | Untrusted relay (secret discarded after setup) |
| [Reticulum Party Line](https://github.com/MarcusHoltz/reticulum-party-line) | RNS bridge | Untrusted relay, Python bridge for Reticulum mesh |

Shared code covers: room lifecycle, audio capture/playback,
HMAC signing, encryption, PTT handling, the TUI, configuration,
and all user-facing features. Transport-specific code (i2pd
tunnel management, `.b32.i2p` address handling) lives only in
this repo.

When a shared function changes in one script, the same change
is applied to the other two, adapted for transport-specific
naming where needed.


---

## 🙏 Credits

This project is built upon [TerminalPhone](https://gitlab.com/here_forawhile/terminalphone) by [here_forawhile](https://gitlab.com/here_forawhile).


---

## 📄 License

MIT — see [LICENSE](LICENSE).
