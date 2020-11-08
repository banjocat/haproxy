from haproxy:lts

COPY ./redis.lua /usr/local/etc/haproxy/redis.lua
COPY ./haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg


