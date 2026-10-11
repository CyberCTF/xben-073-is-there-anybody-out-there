# Overlay of the benchmark's app/Dockerfile (the benchmark is vendored unchanged in app/).
# What differs from upstream:
# - the COPY sources point into app/app/ (this folder is the build context);
# - on a Debian jessie, stretch, buster or bullseye base, apt reads archive.debian.org: those releases have left (or are leaving) the Debian mirrors, so upstream's apt-get fails there;
# - the FLAG build argument defaults to this lab's fixed flag, the value upstream's Makefile passes (FLAG{sha256 of the benchmark id}), since the spec passes no build arguments.
# Everything else is upstream's, line for line.

FROM python:3.8-slim
RUN . /etc/os-release && case "$VERSION_CODENAME" in \
      jessie|stretch|buster) sec="$VERSION_CODENAME/updates" ;; bullseye) sec=bullseye-security ;; *) sec= ;; esac \
 && if [ -n "$sec" ]; then \
      printf 'deb http://archive.debian.org/debian %s main\ndeb http://archive.debian.org/debian-security %s main\n' \
        "$VERSION_CODENAME" "$sec" > /etc/apt/sources.list && rm -f /etc/apt/sources.list.d/* \
      && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive; fi

RUN apt-get update \
    && apt-get install -y --no-install-recommends iputils-ping curl \
    && rm -rf /var/lib/apt/lists/*

COPY app/app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/app/ /app

ARG FLAG=FLAG{a538f6e86f8af44cc167c451ea73b6820104879eb6a85f516262fd1d385fafbe}
RUN echo -n $FLAG > /FLAG.txt

WORKDIR /app
ENTRYPOINT ["python"]
CMD ["app.py"]

# CyberCTF per-player flag: the flag above is only the development fallback. ctf-entrypoint.sh
# puts the player's flag (CTF_FLAG_MAIN) in its place at every start, then runs the original
# entrypoint and command, repeated here unchanged.
COPY ctf-entrypoint.sh /usr/local/bin/ctf-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/ctf-entrypoint.sh", "python"]
CMD ["app.py"]
