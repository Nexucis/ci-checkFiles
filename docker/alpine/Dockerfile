FROM alpine:3.7

MAINTAINER Augustin Husson <husson.augustin@gmail.com>

ARG UCHARDET_RELEASE=v0.0.6

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        bash \
        git \
        openssh-client \
        ca-certificates \
        dos2unix \
        # install all we need to build uchardet
        g++ \
        cmake \
        make && \
    # get uchardet and build it
    cd /tmp && \
    git clone git://anongit.freedesktop.org/uchardet/uchardet && \
    cd uchardet && \
    git checkout ${UCHARDET_RELEASE} && \
    cmake . && \
    make && \
    make install && \
    ln -s /usr/local/lib64/libuchardet.so.0 /lib/libuchardet.so.0 && \
    cd / && \
    # clean the image
    rm -rf /tmp/* && \
    apk del \
      g++ \
      cmake \
      make && \
    # reinstall only the lib needed by uchardet
    apk add --no-cache \
      libgcc \
      libstdc++ && \
    rm -rf /var/cache/apk/*

COPY eol/eol_if.sh /bin/eol_if
COPY eol/checkEOL.sh /bin/checkEOL
COPY encoding/encoding_if.sh /bin/encoding_if
COPY encoding/checkEncoding.sh /bin/checkEncoding
RUN chmod +x /bin/eol_if /bin/checkEOL /bin/encoding_if /bin/checkEncoding