FROM debian:bookworm-slim

ARG VELOCIRAPTOR_URL
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL "$VELOCIRAPTOR_URL" | gunzip > /usr/local/bin/velociraptor \
 && chmod +x /usr/local/bin/velociraptor

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data
VOLUME /data
EXPOSE 8000 8889
ENTRYPOINT ["/entrypoint.sh"]
