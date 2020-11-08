# Purpose
Learning haproxy with lua.

A very limited redis implementation

supports get, set and del

# to test
```
# requires docker-compose and redis-cli and redis-benchmark

# This starts the haproxy redis and a normal redis
docker-compose up -d

# very limited testing of get, set, del.. with some error checks
./run_tests.sh


# benchmarks
```
redis-benchmark -t set,get


