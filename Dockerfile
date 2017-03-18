FROM ubuntu:xenial
MAINTAINER Jeremy Nicklas <jeremywnicklas@gmail.com>

# Add ppa:maarten-baert/simplescreenrecorder
RUN printf "deb http://ppa.launchpad.net/maarten-baert/simplescreenrecorder/ubuntu xenial main\ndeb-src http://ppa.launchpad.net/maarten-baert/simplescreenrecorder/ubuntu xenial main" > /etc/apt/sources.list.d/simplescreenrecorder.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 4DEDB3E05F043CA185176AC0409C8B51283EC8CD

# Install SimpleScreenRecorder
RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    simplescreenrecorder \
  && apt-get autoremove -y \
  && rm -fr /var/cache/* \
  && rm -fr /var/lib/apt/lists/*

ENV HOME /data

WORKDIR ${HOME}

ENTRYPOINT [ "simplescreenrecorder" ]
