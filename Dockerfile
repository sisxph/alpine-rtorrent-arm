FROM alpine:edge

ARG VERSION="0.16.5-r0"
ARG UGID=1000

LABEL maintainer="Gianluca Gabrielli" mail="tuxmealux+dockerhub@protonmail.com"
LABEL description="rTorrent on Alpine Linux, with a better Docker integration."
LABEL website="https://github.com/TuxMeaLux/alpine-rtorrent"
LABEL version="$VERSION"

VOLUME /home/rtorrent/rtorrent/.session

EXPOSE 16891
EXPOSE 6881
EXPOSE 6881/udp
EXPOSE 50000
EXPOSE 3000


RUN addgroup --gid $UGID rtorrent && \
    adduser -S -u $UGID -G rtorrent rtorrent
    
RUN apk add --no-cache rtorrent="$VERSION"



USER rtorrent

RUN mkdir -p /home/rtorrent/rtorrent/config.d/ && \
    mkdir -p /home/rtorrent/rtorrent/.session/ && \
    mkdir -p /home/rtorrent/rtorrent/download/ && \
    mkdir -p /home/rtorrent/rtorrent/watch/
    
COPY --chown=rtorrent:rtorrent config.d/ /home/rtorrent/rtorrent/config.d/
COPY --chown=rtorrent:rtorrent .rtorrent.rc /home/rtorrent/

WORKDIR /home/rtorrent/

CMD ["rtorrent"]
