#!/bin/sh
docker build --target hererocks -t daurnimator/hererocks .
docker build --target lua5.1 -t daurnimator/lua5.1 .
docker build --target lua5.2 -t daurnimator/lua5.2 .
docker build --target lua5.3 -t daurnimator/lua5.3 .
docker build --target luajit2.0 -t daurnimator/luajit2.0 .
docker build --target luajit2.1 -t daurnimator/luajit2.1 .
docker build --target luacheck -t daurnimator/luacheck .
docker push daurnimator/hererocks
docker push daurnimator/lua5.1
docker push daurnimator/lua5.2
docker push daurnimator/lua5.3
docker push daurnimator/luajit2.1
docker push daurnimator/luacheck
