FROM debian:buster-slim

COPY entrypoint.sh /entrypoint.sh

RUN sudo apt-get update
RUN sudo apt-get install -y git grep curl

ENTRYPOINT ["/entrypoint.sh"]
