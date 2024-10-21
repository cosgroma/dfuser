SITE_DOMAIN_NAME=sergeant.work


# Install NGINX
install-nginx:
	@echo "Setting up Nginx..."
	@sudo apt-get install -y nginx
	@echo "Nginx installed successfully!"

check-for-certbot:
	@echo "Checking for Certbot..."
	@sudo apt-get install -y software-properties-common
	@sudo add-apt-repository -y ppa:certbot/certbot
	@sudo apt-get update
	@sudo apt-get install -y python-certbot-nginx
	@echo "Certbot installed successfully!"

nginx-ssl:
	@echo "Setting up Nginx SSL..."
	@sudo apt-get install -y software-properties-common
	@sudo add-apt-repository -y ppa:certbot/certbot
	@sudo apt-get update
	@sudo apt-get install -y python-certbot-nginx
	@sudo certbot --nginx -d ${GITLAB_HOSTNAME}
	@echo "Nginx SSL installed successfully!"

nginx-ssl-renew:
	@echo "Renewing Nginx SSL..."
	@sudo certbot renew
	@echo "Nginx SSL renewed successfully!"

nginx-ssl-remove:
	@echo "Removing Nginx SSL..."
	@sudo certbot delete
	@echo "Nginx SSL removed successfully!"

nginx-ssl-renew-cron:
	@echo "Setting up Nginx SSL renewal cron job..."
	@sudo crontab -l > mycron
	@echo "0 0 * * * sudo certbot renew --quiet" >> mycron
	@sudo crontab mycron
	@rm mycron
	@echo "Nginx SSL renewal cron job set up successfully!"

nginx-status:
	@echo "Checking Nginx status..."
	@sudo service nginx status
	@echo "Nginx status checked successfully!"

nginx-restart:
	@echo "Restarting Nginx..."
	@sudo service nginx restart
	@echo "Nginx restarted successfully!"

setup-nginx: nginx-ssl nginx-ssl-renew nginx-ssl-renew-cron enable-gitlab-nginx

deploy:
	@sudo cp sites-available/*.work.conf /etc/nginx/sites-available/

# for f in sites-available/*.conf; do nn=$(echo $f | sed 's/ngc/work/g'); mv $f $nn; done;
