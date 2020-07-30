FROM debian:buster-slim

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN apt-get update
RUN apt-get install -y git grep curl jq

ENTRYPOINT ["/entrypoint.sh"]
