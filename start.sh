#!/bin/bash
set -e

echo "Starting Tor hidden service..."
service tor start

echo "Waiting for Tor to generate .onion address..."
while [ ! -f /var/lib/tor/hidden_service/hostname ]; do
    sleep 1
done

echo "==========================================="
echo "✓ Tor Hidden Service is ready!"
echo "==========================================="
echo "Your .onion address:"
cat /var/lib/tor/hidden_service/hostname
echo "==========================================="
echo ""
echo "Web service: http://$(cat /var/lib/tor/hidden_service/hostname)"
echo "SSH service: $(cat /var/lib/tor/hidden_service/hostname):4242"
echo "==========================================="

echo "Starting Nginx..."
service nginx start

echo "Starting SSH server on port 4242..."
service ssh start

echo ""
echo "All services are running!"
echo "Access your hidden service through Tor Browser"
echo ""

tail -f /var/log/nginx/access.log /var/log/nginx/error.log
