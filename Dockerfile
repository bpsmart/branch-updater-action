FROM debian:buster-slim

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update
RUN apt-get install -y git grep curl

ENTRYPOINT ["/entrypoint.sh"]
