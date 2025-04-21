#!/bin/bash

set +e  # Done Exit on error
set -x  # Print commands being executed


LOG_FILE="/var/log/script.log"
exec > >(tee -a "$LOG_FILE") 2>&1  # Log output to file

echo "Starting setup..."  

# Ensure necessary dependencies are installed
sudo apt update
sudo apt install -y software-properties-common

# Add the PHP repository
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update  # Update again after adding the PPA

# Install PHP and required extensions
sudo apt install -y \
    nginx \
    git \
    redis-server \
    certbot python3-certbot-nginx \
    composer \
    php8.2 php8.2-cli php8.2-fpm php8.2-mbstring php8.2-xml php8.2-curl php8.2-mysql php8.2-zip php8.2-bcmath php8.2-intl php8.2-gd php8.2-pgsql php8.2-sqlite3 php8.2-redis
    # openjdk-17-jre-headless


# Enable and start services
sudo systemctl enable nginx redis-server
sudo systemctl start nginx redis-server

# Install Jenkins
# sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
#   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
#   sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# sudo apt update
# sudo apt install -y jenkins
# sudo systemctl enable jenkins
# sudo systemctl start jenkins


TARGET_DIR="/var/www/html/${DOMAIN_NAME}" 

# Clone Git Repository
GIT_REPO="https://codehub.exalogic.co/exalogic-web-app/realcube-sales-and-leasing-crm.git"
git_username="${git_username}"
git_password="${git_password}"

# Securely handle credentials with GIT_ASKPASS
echo "echo ${git_password}" > /tmp/git-askpass.sh
chmod +x /tmp/git-askpass.sh

echo "Cloning repository..."
sudo rm -rf "$TARGET_DIR"
GIT_ASKPASS=/tmp/git-askpass.sh sudo -E git clone https://${git_username}@codehub.exalogic.co/exalogic-web-app/realcube-sales-and-leasing-crm.git "$TARGET_DIR" || { echo "Failed to clone repository"; exit 1; }
# Navigate to the cloned directory before checking out the branch
cd "$TARGET_DIR" || { echo "Failed to navigate to target directory"; exit 1; }

sudo -E git checkout rc_ict_qat || { echo "Failed to checkout branch"; exit 1; }
rm -f /tmp/git-askpass.sh  # Remove credentials after cloning
echo "Repository cloned successfully!"

# Set permissions
sudo chown -R ubuntu:www-data "$TARGET_DIR"
#sudo chmod -R 755 "$TARGET_DIR"
#sudo chmod 777 "$TARGET_DIR"/composer.lock
sudo chmod -R 777 "$TARGET_DIR"/writable
sudo chmod -R 775 "$TARGET_DIR"/vendor

echo "Permissions set for $TARGET_DIR!"

# Add JWT configurations to the .env file
ENV_FILE="/var/www/html/${DOMAIN_NAME}/.env"

# # Add JWT configurations to the existing .env file
# ENV_FILE="/var/www/html/${DOMAIN_NAME}/.env"

# # Check if the lines already exist and update them, otherwise append them
# if grep -q "^JWT_SECRET=" "$ENV_FILE"; then
#     sudo sed -i "s/^JWT_SECRET=.*/JWT_SECRET=p0CnOSQRF4k2SFSnoTgloNCceWbm8Rxqj3kTV4hqIHalIjCSM8rCLhDEEIJeW/" "$ENV_FILE"
# else
#     echo "JWT_SECRET=p0CnOSQRF4k2SFSnoTgloNCceWbm8Rxqj3kTV4hqIHalIjCSM8rCLhDEEIJeW" | sudo tee -a "$ENV_FILE"
# fi

# if grep -q "^JWT_TTL=" "$ENV_FILE"; then
#     sudo sed -i "s/^JWT_TTL=.*/JWT_TTL=1400/" "$ENV_FILE"
# else
#     echo "JWT_TTL=1400" | sudo tee -a "$ENV_FILE"
# fi

# echo "JWT configuration added or updated in .env file!"



# Set up Nginx configuration
# domain_name="${domain_name}.realcube.estate"
NGINX_CONFIG="/etc/nginx/sites-available/${DOMAIN_NAME}.conf"

cat <<EOF | sudo tee $NGINX_CONFIG
server {
    server_name ${DOMAIN_NAME};
    root /var/www/html/${DOMAIN_NAME}/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.php;
    charset utf-8;
    client_max_body_size 100M;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location /adminer/ {
        try_files \$uri \$uri/ /index.php;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    access_log /var/log/nginx/${DOMAIN_NAME}.log;
    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;

    location ~ \.php$ {
        fastcgi_read_timeout 3000;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+css text/javascript;
    gzip_min_length 10240;
    gzip_comp_level 6;

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|otf|eot|ttf)$ {
        access_log off;
    }
}
EOF

# Enable the site
sudo ln -s $NGINX_CONFIG /etc/nginx/sites-enabled/


# sudo certbot --nginx -d ${DOMAIN_NAME}

# Reload Nginx
sudo nginx -t && sudo systemctl reload nginx

echo "Nginx configuration for ${domain_name}.realcube.estate set up successfully!"

####################################################################################################################

set -x  # Enable debugging

#!/bin/bash
set -x  # Enable debugging

export EDITOR=/bin/nano


CRON_FILE="/tmp/www-data-cron"

# Generate cron jobs dynamically using ${DOMAIN_NAME}
cat <<EOF > $CRON_FILE
############################################################################################## 
###UAT CRONS########################### 
##############################################################################################
# Offer expiry daily notification
0 0 * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php Leasenew/offerExpireNoticeLists
# Create email or SMS notifications
* * * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/createEmailSmsQueue
# Send emails from email queue
* * * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/sendEmailQueue >> /var/www/html/${DOMAIN_NAME}/writable/logs/cronjob.log
# Pending leads weekly report to send PE,PM
0 0 * * 0 /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/pendingLeads
# Call center weekly activity log to PM
0 0 * * 0 /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/callCenterReport
# Send birthday reminder
0 0 * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/usersBirthday
# Send call history report to PM
0 0 * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/callHistoryReport
# Payment reminders
0 0 * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/getPaymentRemainderData
# Call center daily report notification to FM
0 0 * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/callCenterReportCron
# Recurring call notification to PE daily 
0 0 * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/recurringCallNotificationCron
# Send daily visitor report notification to PE,PM,PD
0 0 * * * /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/visitorReportCron
# Weekly upcoming unit non-renewal and legal notices 
0 0 * * 0 /usr/bin/php8.2 -f /var/www/html/${DOMAIN_NAME}/public/index.php CronjobController/upcomingUnitReportCron
EOF

# Apply crontab to www-data user
crontab -u www-data $CRON_FILE
# Verify crontab installation
echo "Verifying crontab installation..."
crontab -u www-data -l


echo "Cron jobs have been set up successfully!"

# Restart cron service to ensure jobs run
sudo systemctl restart cron


####################################################################################################################

echo "Setup complete!" | tee -a "$LOG_FILE"