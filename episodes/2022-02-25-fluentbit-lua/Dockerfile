FROM fluent/fluent-bit:1.8-debug

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      lua5.1 \
      luarocks && \
    luarocks install lpeg && \
    luarocks install inspect

RUN mkdir -pv /source

WORKDIR /source
