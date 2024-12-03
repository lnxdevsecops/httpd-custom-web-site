#!/bin/bash

# Run the virtual host setup script
echo "Running the virtual host setup script..."
/usr/local/bin/setup_vhost.sh

# Start Apache in the foreground
echo "Starting Apache server..."
exec httpd -D FOREGROUND
