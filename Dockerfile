FROM python:slim AS hererocks
# Install common lua package build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    m4 \
    libreadline-dev \
	libssl-dev \
    curl \
	unzip \
    git \
  && rm -rf /var/lib/apt/lists/*
ADD https://raw.githubusercontent.com/mpeterv/hererocks/latest/hererocks.py /usr/bin/hererocks
RUN chmod +x /usr/bin/hererocks
CMD ["hererocks --help"]

# Preload cache (in /root/.cache/hererocks)
RUN hererocks -r^ --lua=5.1 --no-readline /tmp/lua5.1 \
 && hererocks --lua=5.2 /tmp/lua5.2 \
 && hererocks --lua=5.3 /tmp/lua5.3 \
 && hererocks --luajit=2.0 /tmp/luajit2.0 \
 && hererocks --luajit=2.1 /tmp/luajit2.1 \
 && hererocks --luajit=@ /tmp/luajit-HEAD \
 && rm -rf /tmp/lua*

# Create images for lua versions
FROM hererocks AS lua5.1
RUN hererocks -r^ --lua=5.1 --no-readline /lua5.1
ENV PATH="${PATH}:/lua5.1/bin" \
    LUA_PATH="/lua5.1/share/lua/5.1/?.lua;/lua5.1/share/lua/5.1/?/init.lua;./?.lua;./?/init.lua" \
	LUA_CPATH="/lua5.1/lib/lua/5.1/?.so;/lua5.1/lib/lua/5.1/loadall.so;./?.so"
CMD ["lua", "--help"]

FROM hererocks AS lua5.2
RUN hererocks -r^ --lua=5.2 /lua5.2
ENV PATH="${PATH}:/lua5.2/bin" \
    LUA_PATH="/lua5.2/share/lua/5.2/?.lua;/lua5.2/share/lua/5.2/?/init.lua;./?.lua;./?/init.lua" \
	LUA_CPATH="/lua5.2/lib/lua/5.2/?.so;/lua5.2/lib/lua/5.2/loadall.so;./?.so"
CMD ["lua", "--help"]

FROM hererocks AS lua5.3
RUN hererocks -r^ --lua=5.3 /lua5.3
ENV PATH="${PATH}:/lua5.3/bin" \
    LUA_PATH="/lua5.3/share/lua/5.3/?.lua;/lua5.3/share/lua/5.3/?/init.lua;./?.lua;./?/init.lua" \
	LUA_CPATH="/lua5.3/lib/lua/5.3/?.so;/lua5.3/lib/lua/5.3/loadall.so;./?.so"
CMD ["lua", "--help"]

FROM hererocks AS luajit2.0
RUN hererocks -r^ --luajit=2.0 /luajit2.0
ENV PATH="${PATH}:/luajit2.0/bin" \
    LUA_PATH="/luajit2.0/share/lua/5.1/?.lua;/luajit2.0/share/lua/5.1/?/init.lua;./?.lua;./?/init.lua" \
	LUA_CPATH="/luajit2.0/lib/lua/5.1/?.so;/luajit2.0/lib/lua/5.1/loadall.so;./?.so"
CMD ["lua", "--help"]

FROM hererocks AS luajit2.1
RUN hererocks -r^ --luajit=2.1 /luajit2.1
ENV PATH="${PATH}:/luajit2.1/bin" \
    LUA_PATH="/luajit2.1/share/lua/5.1/?.lua;/luajit2.1/share/lua/5.1/?/init.lua;./?.lua;./?/init.lua" \
	LUA_CPATH="/luajit2.1/lib/lua/5.1/?.so;/luajit2.1/lib/lua/5.1/loadall.so;./?.so"
CMD ["lua", "--help"]

# Create linting image
FROM lua5.3 AS luacheck
## Prevent warnings due to permissions
RUN USER=root luarocks install luacheck
CMD ["luacheck", "--help"]
