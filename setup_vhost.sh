#!/bin/bash

# Variables
DOCUMENT_ROOT="/var/www/html/dev-web-app"
VHOST_FILE="/etc/httpd/conf.d/dev-web-app.conf"
DOMAIN="dev-web-app.com"
ADMIN_EMAIL="admin@dev-web-app.com"

# Create the document root directory
echo "Creating document root directory at $DOCUMENT_ROOT..."
mkdir -p "$DOCUMENT_ROOT"

# Creating the index file
echo "This is the Customer Configuration Website...!" > "$DOCUMENT_ROOT"/index.html

# Set permissions for the document root
echo "Setting permissions for $DOCUMENT_ROOT..."
chown -R apache:apache "$DOCUMENT_ROOT"
chmod -R 755 "$DOCUMENT_ROOT"

# Create the virtual host configuration file
echo "Creating virtual host configuration file at $VHOST_FILE..."
touch "$VHOST_FILE"

# Populate the virtual host configuration file
echo "Configuring the virtual host..."
cat > "$VHOST_FILE" <<EOL
<VirtualHost *:80>
    ServerAdmin $ADMIN_EMAIL
    DocumentRoot $DOCUMENT_ROOT
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    ErrorLog logs/${DOMAIN}_error.log
    CustomLog logs/${DOMAIN}_access.log combined
</VirtualHost>
EOL

# Set SELinux permissions (if SELinux is enabled)
echo "Setting SELinux permissions..."
if getenforce | grep -q "Enforcing"; then
    semanage fcontext -a -t httpd_sys_content_t "${DOCUMENT_ROOT}(/.*)?"
    restorecon -Rv "${DOCUMENT_ROOT}"
fi

# Enable and restart Apache to apply changes
echo "Restarting Apache service..."
systemctl restart httpd

# Confirm success
echo "Virtual host for $DOMAIN has been successfully created and enabled."
