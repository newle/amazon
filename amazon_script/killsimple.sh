ps aux | grep simple_get.sh | grep -v grep | awk '{print $2}' | xargs kill -9
