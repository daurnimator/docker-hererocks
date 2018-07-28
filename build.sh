#!/bin/sh

set -e

: ${REGISTRY_PREFIX:=daurnimator/}

docker build --target hererocks -t "$REGISTRY_PREFIX"hererocks .
docker build --target lua5.1 -t "$REGISTRY_PREFIX"lua5.1 .
docker build --target lua5.2 -t "$REGISTRY_PREFIX"lua5.2 .
docker build --target lua5.3 -t "$REGISTRY_PREFIX"lua5.3 .
docker build --target luajit2.0 -t "$REGISTRY_PREFIX"luajit2.0 .
docker build --target luajit2.1 -t "$REGISTRY_PREFIX"luajit2.1 .
docker build --target luacheck -t "$REGISTRY_PREFIX"luacheck .
docker push "$REGISTRY_PREFIX"hererocks
docker push "$REGISTRY_PREFIX"lua5.1
docker push "$REGISTRY_PREFIX"lua5.2
docker push "$REGISTRY_PREFIX"lua5.3
docker push "$REGISTRY_PREFIX"luajit2.1
docker push "$REGISTRY_PREFIX"luacheck
