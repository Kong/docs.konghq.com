rm -rf pdk-reference
mkdir pdk-reference
LUA_PATH="$LUA_PATH;./?.lua" ldoc -q -i --filter ldoc/filters.yml kong/pdk/ 2>error.log
LUA_PATH="$LUA_PATH;./?.lua" ldoc -q -i --filter ldoc/filters.markdown kong/pdk 2>error.log
