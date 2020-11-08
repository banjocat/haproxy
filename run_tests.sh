#!/bin/bash -e

echo "make sure to docker-compose up -d first"

echo "testing key missing"
diff <(redis-cli get pizza) <(redis-cli -p 6380 get pizza)
echo "testing deleting key that doesn't exist"
diff <(redis-cli del pizza) <(redis-cli -p 6380 del pizza)
echo "testing setting key"
diff <(redis-cli set pizza good) <(redis-cli -p 6380 set pizza good)
echo "testing getting previous set key"
diff <(redis-cli get pizza) <(redis-cli -p 6380 get pizza)
echo "testing deleting key"
diff <(redis-cli del pizza) <(redis-cli -p 6380 del pizza)
echo "testing get to confirm deleted"
diff <(redis-cli get pizza) <(redis-cli -p 6380 get pizza)

echo "testing wrong number of args"
diff <(redis-cli get) <(redis-cli -p 6380 get)
diff <(redis-cli del) <(redis-cli -p 6380 del)
diff <(redis-cli set) <(redis-cli -p 6380 set)

echo "all passed."
