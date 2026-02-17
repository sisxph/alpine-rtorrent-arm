FROM alpine:edge

ARG VERSION="0.16.5-r0"
ARG UGID=1000

LABEL maintainer="Gianluca Gabrielli" mail="tuxmealux+dockerhub@protonmail.com"
LABEL description="rTorrent on Alpine Linux, with a better Docker integration."
LABEL website="https://github.com/TuxMeaLux/alpine-rtorrent"
LABEL version="$VERSION"

RUN addgroup --gid $UGID rtorrent && \
    adduser -S -u $UGID -G rtorrent rtorrent && \
    apk add --no-cache rtorrent="$VERSION" && \
    mkdir -p /home/rtorrent/rtorrent/config.d/ && \
    mkdir -p /home/rtorrent/rtorrent/.session/ && \
    mkdir -p /home/rtorrent/rtorrent/download/ && \
    mkdir -p /home/rtorrent/rtorrent/watch/
    
COPY --chown=rtorrent:rtorrent config.d/ /home/rtorrent/rtorrent/config.d/
COPY --chown=rtorrent:rtorrent .rtorrent.rc /home/rtorrent/
COPY --chown=rtorrent:rtorrent entrypoint.sh /home/rtorrent/entrypoint.sh

RUN chown -R rtorrent:rtorrent /home/rtorrent/rtorrent/

VOLUME /home/rtorrent/rtorrent/.session

RUN chmod +x /home/rtorrent/entrypoint.sh

EXPOSE 16891
EXPOSE 6881
EXPOSE 6881/udp
EXPOSE 50000
EXPOSE 3000

USER rtorrent

WORKDIR /home/rtorrent/

CMD ["rtorrent"]
