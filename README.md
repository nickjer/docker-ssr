# Docker SimpleScreenRecorder

Docker image for [SimpleScreenRecorder](https://github.com/MaartenBaert/ssr).

## Build

```sh
git clone https://github.com/nickjer/docker-ssr.git
cd docker-ssr
docker build --force-rm -t nickjer/ssr .
```

## Install

```sh
docker pull nickjer/docker-ssr
```

## Usage

```sh
# First make the directory that will hold config files and videos
mkdir ${HOME}/ssr

# Run the docker image
docker run --rm -i -t \
  -v "/etc/localtime:/etc/localtime:ro" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:ro" \
  -v "/run/user/$(id -u)/pulse/native:/pulse/socket:ro" \
  -v "${HOME}/.config/pulse/cookie:/pulse/cookie:ro" \
  -v "${HOME}/ssr:/data" \
  --device="/dev/snd:/dev/snd" \
  -e "DISPLAY=${DISPLAY}" \
  -e "PULSE_SERVER=/pulse/socket" \
  -e "PULSE_COOKIE=/pulse/cookie" \
  -u "$(id -u):$(id -g)" \
  --pid="host" \
  --ipc="host" \
  nickjer/docker-ssr
```

### Docker Compose

It is recommended to use [Docker Compose](https://docs.docker.com/compose/). An
example `docker-compose.yml` is seen as:

```yaml
version: "2"
services:
  ssr:
    image: "nickjer/docker-ssr"
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
      - "/tmp/.X11-unix:/tmp/.X11-unix:ro"
      - "/run/user/1000/pulse/native:/pulse/socket:ro"
      - "${HOME}/.config/pulse/cookie:/pulse/cookie:ro"
      - "${HOME}/ssr:/data"
    devices:
      - "/dev/snd:/dev/snd"
    environment:
      DISPLAY: "${DISPLAY}"
      PULSE_SERVER: "/pulse/socket"
      PULSE_COOKIE: "/pulse/cookie"
    user: "1000:1000"
    pid: "host"
    ipc: "host"
```

Then run:

```sh
docker-compose run --rm ssr
```

## How it Works?

### GUI Display

The options:

```sh
...
  -v "/tmp/.X11-unix:/tmp/.X11-unix:ro" \
  -e "DISPLAY=${DISPLAY}" \
  --ipc="host"
```

are necessary to get the GUI running in your display. In particular the
`--ipc="host"` is needed for the QT shared memory.

### ALSA Sound

The option:

```sh
...
  --device="/dev/snd:/dev/snd"
```

is necessary to add ALSA for sound recording.

### Pulse Sound

The options:

```sh
...
  -v "/run/user/$(id -u)/pulse/native:/pulse/socket:ro" \
  -v "${HOME}/.config/pulse/cookie:/pulse/cookie:ro" \
  -e "PULSE_SERVER=/pulse/socket" \
  -e "PULSE_COOKIE=/pulse/cookie" \
  --pid="host"
```

are necessary to connect to the PulseAudio socket with your cookie for
authorization. The `--pid="host"` is needed so it can find the host machine's
PulseAudio server PID. This may be overkill, but it works.

### Save Configuration & Videos

I create a directory:

```sh
mkdir ${HOME}/ssr
```

and mount this to the `/data` directory in the container for all the output:

```sh
...
  -v "${HOME}/ssr:/data"
```
