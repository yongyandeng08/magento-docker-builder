#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting Magento setup process..."

# Verify PHP and sodium extension
echo "$(date '+%Y-%m-%d %H:%M:%S') - Checking PHP extensions..."
for i in {1..5}; do
    if php -m | grep -q sodium; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Sodium extension is loaded."
        break
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Waiting for Sodium extension to load... ($i/5)"
    sleep 5
    if [ "$i" -eq 5 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Sodium extension not loaded after 5 attempts."
        exit 1
    fi
done

# Clean up env.php to ensure a fresh installation
echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning up env.php..."
rm -f /app/app/etc/env.php

# Proceed with Magento installation
echo "$(date '+%Y-%m-%d %H:%M:%S') - Installing Magento..."
php bin/magento setup:install \
      --base-url="http://localhost" \
      --db-host="db" \
      --db-name="magento" \
      --db-user="magento" \
      --db-password="magento" \
      --admin-firstname="Admin" \
      --admin-lastname="User" \
      --admin-email="admin@example.com" \
      --admin-user="admin" \
      --admin-password="admin123" \
      --language="en_US" \
      --currency="USD" \
      --timezone="America/New_York" \
      --use-rewrites=1 \
      --search-engine="opensearch" \
      --opensearch-host="opensearch" \
      --opensearch-port="9200" \
      --backend-frontname="admin"

# Check for errors during installation
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Magento installation/setup failed."
    exit 1
fi

# Disable Two-Factor Authentication
echo "$(date '+%Y-%m-%d %H:%M:%S') - Disabling Two-Factor Authentication (2FA)..."
php bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth

# Finalize Magento setup
echo "$(date '+%Y-%m-%d %H:%M:%S') - Finalizing setup..."
php bin/magento cache:flush

# Log successful completion
echo "$(date '+%Y-%m-%d %H:%M:%S') - Magento installation and setup completed successfully."

# Start PHP-FPM to keep the container running
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting PHP-FPM..."
exec php-fpm -R
