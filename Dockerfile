# Use RHEL as the base image
FROM registry.access.redhat.com/ubi8/ubi:latest

# Install required packages
RUN yum update -y && \
    yum install -y httpd sudo policycoreutils-python-utils && \
    yum clean all

# Add the virtual host setup script
COPY setup_vhost.sh /usr/local/bin/setup_vhost.sh

# Make the script executable
RUN chmod +x /usr/local/bin/setup_vhost.sh

# Create entrypoint script to execute the virtual host setup
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80 for HTTP traffic
EXPOSE 80

# Set the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Start the Apache server
CMD ["httpd", "-D", "FOREGROUND"]
