# ── Stage 1: compile pcm_rms ─────────────────────────────────────────────────
# Pre-compiled so gcc is not needed at runtime. Source matches ensure_pcm_rms()
# in i2p-party-line.sh; the script checks `command -v pcm_rms` first.
FROM debian:trixie-slim AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*
RUN printf '%s\n' \
    '#include <stdio.h>' \
    '#include <math.h>' \
    '#include <stdint.h>' \
    'int main(void) {' \
    '    int16_t buf[4096];' \
    '    double sum = 0.0;' \
    '    long count = 0;' \
    '    size_t n;' \
    '    while ((n = fread(buf, sizeof(int16_t), 4096, stdin)) > 0) {' \
    '        for (size_t i = 0; i < n; i++) {' \
    '            double s = (double)buf[i];' \
    '            sum += s * s;' \
    '        }' \
    '        count += n;' \
    '    }' \
    '    if (count == 0) { printf("-91.0\n"); return 0; }' \
    '    double rms = sqrt(sum / count);' \
    '    double dbfs = 20.0 * log10(rms / 32768.0);' \
    '    printf("%.1f\n", dbfs);' \
    '    return 0;' \
    '}' > /tmp/pcm_rms.c \
    && gcc -O2 -o /tmp/pcm_rms /tmp/pcm_rms.c -lm

# ── Stage 2: runtime image ──────────────────────────────────────────────────
#
# Unlike the Tor edition there is no mkp224o builder (vanity .onion generation
# has no I2P equivalent) and no entrypoint script. This image runs i2p-party-line.sh
# directly, which owns the i2pd lifecycle itself.
#
FROM debian:trixie-slim

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    i2pd \
    opus-tools \
    socat \
    openssl \
    alsa-utils \
    pulseaudio-utils \
    qrencode \
    ncurses-bin \
    iproute2 \
    ca-certificates \
    python3 \
    libopus0 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 -G audio partyline

COPY --from=builder /tmp/pcm_rms /usr/local/bin/pcm_rms

# i2pd's reseed/family certificates ship with the package. They default to
# <datadir>/certificates (libi2pd/FS.cpp:214), and i2p-party-line.sh runs i2pd with
# an ephemeral datadir of its own, so the script passes --certsdir explicitly.
# Recorded here so a rebuild on a different base can be checked against it.
ENV I2PD_CERTSDIR=/usr/share/i2pd/certificates

# i2p-party-line.sh creates these itself, but pre-creating them keeps a fresh bind
# mount from starting out root-owned in odd ways.
RUN mkdir -p /data/.partyline \
    && chown partyline:partyline /data/.partyline

COPY --chown=partyline:partyline i2p-party-line.sh /
RUN chmod +x /i2p-party-line.sh

ENV LANG=C.UTF-8
ENV DOCKER_MODE=1

ENTRYPOINT ["sh", "-c", "chown partyline:partyline /data /data/.partyline 2>/dev/null || true; exec setpriv --reuid=partyline --regid=partyline --init-groups /i2p-party-line.sh \"$@\"", "--"]
