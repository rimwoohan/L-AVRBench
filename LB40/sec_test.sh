#!/bin/bash
set -e

PORT=4433

pkill -9 -f "openssl s_server" 2>/dev/null || true
# Function to wait until the port is free
wait_for_port_free() {
    local port=$1
    local retries=10

    for ((i=1; i<=retries; i++)); do
        if ! lsof -i :$port >/dev/null; then
            return 0
        fi
        echo "Waiting for port $port to become free... (attempt $i)"
        sleep 1
    done

    echo "Timeout waiting for port $port"
    return 1
}

# Make sure the port is free before starting
wait_for_port_free $PORT || exit 1

# Start the vulnerable OpenSSL server in the background
openssl/apps/openssl s_server \
  -cipher 'DHE-RSA-CHACHA20-POLY1305' \
  -key cert.key \
  -cert cert.crt \
  -accept $PORT \
  -www \
  -tls1_2 \
  -msg > server.log 2>&1 &

# Save server PID so we can kill it later
SERVER_PID=$!

# Wait for server to initialize
sleep 2

# Run the exploit test
echo "[*] Running CVE-2016-7054 test..."
cd tlsfuzzer
python3 scripts/test-cve-2016-7054.py 127.0.0.1 $PORT
STATUS=$?

# Kill the server and wait for it
kill $SERVER_PID || true
wait $SERVER_PID 2>/dev/null || true
cd -

# Small delay to ensure port is released
sleep 1

# Report result
if [ $STATUS -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi

exit $STATUS
