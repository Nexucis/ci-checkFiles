FROM ubuntu:17.10

MAINTAINER Augustin Husson <husson.augustin@gmail.com>

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
                git \
                tar \
                gzip \
                dos2unix \
                openssh-client \
                uchardet \
                libuchardet-dev \
                ca-certificates && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY eol/eol_if /bin/eol_if
COPY eol/checkEOL.sh /bin/checkEOL
COPY encoding/encoding_if /bin/encoding_if
COPY encoding/checkEncoding.sh /bin/checkEncoding
RUN chmod +x /bin/eol_if /bin/checkEOL /bin/encoding_if /bin/checkEncoding