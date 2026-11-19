
#!/bin/bash
set -e

echo "Starting deployment..."

# Copy website to Nginx web directory
sudo cp index.html /usr/share/nginx/html/index.html

# Restart Nginx service
sudo systemctl restart nginx

echo "Deployment completed successfully!"
