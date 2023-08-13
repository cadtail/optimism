#builder
FROM golang:1.19 as op

WORKDIR /app
ENV USER=cadtail
ENV REPO=op-geth
ENV BRANCH=optimism
LABEL org.opencontainers.image.source=https://github.com/$USER/optimism
ADD https://api.github.com/repos/$USER/$REPO/git/ref/heads/$BRANCH version.json
RUN git clone --depth=1 -b $BRANCH https://github.com/$USER/$REPO.git ./repo && cd repo && make geth

#exec
FROM golang:1.19
RUN apt-get update && \
    apt-get install -y jq curl && \
    rm -rf /var/lib/apt/lists

WORKDIR /app
COPY --from=op /app/repo/build/bin/geth ./
COPY build/tools/op-geth-entrypoint op-geth-entrypoint
RUN chmod +x op-geth-entrypoint
COPY build/goerli ./goerli
COPY build/mainnet ./mainnet
