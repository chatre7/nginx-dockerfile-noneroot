FROM nginx:stable-alpine

# Create a non-root user
RUN adduser -D -u 1000 nginxuser

# Create necessary directories and set permissions
RUN mkdir -p /var/cache/nginx /var/log/nginx /var/run \
    && chown -R nginxuser:nginxuser /var/cache/nginx /var/log/nginx /var/run

# Update the Nginx configuration to use the non-root user
RUN sed -i 's/user  nginx;/user  nginxuser;/' /etc/nginx/nginx.conf

# Switch to the non-root user
USER nginxuser

# Expose port 8080 instead of 80 (non-root users can't bind to ports below 1024)
EXPOSE 8080

# Update the default server configuration to listen on port 8080
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
