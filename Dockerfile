FROM debian:buster-slim

COPY --from=changelog-tool /usr/local/bin/changelog-tool /usr/local/bin/changelog-tool

COPY entrypoint.sh /entrypoint.sh

RUN sudo apt-get update
RUN sudo apt-get install -y git grep curl

ENTRYPOINT ["/entrypoint.sh"]
