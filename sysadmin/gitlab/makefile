# makefile for GitLab and NGINX

## macros
TIMESTAMP = $(shell date +%Y%m%d%H%M%S)
FILENAME_NO_EXT = $(basename $(notdir $(1)))
DIRECORY = $(dir $(1))

## GITLAB config variables
GITLAB_CONFIG_FILE := /etc/gitlab/gitlab.rb
LOCAL_GITLAB_CONFIG_FILE := gitlab-ce/gitlab.rb

GITLAB_HOSTNAME := gitlab.sergeant.work
USE_SSL ?= true

GITLAB_NGINX_CONFIG := ${GITLAB_HOSTNAME}.conf

GITLAB_NGINX_CONFIG_FILE := nginx/${GITLAB_NGINX_CONFIG}

ifeq (${USE_SSL}, true)
GITLAB_NGINX_BASE := gitlab-omnibus-ssl-nginx
GITLAB_URL := https://${GITLAB_HOSTNAME}
NGINX_SSL_CERT := /etc/letsencrypt/live/${GITLAB_HOSTNAME}/fullchain.pem
else	
GITLAB_NGINX_BASE := gitlab-omnibus-nginx
GITLAB_URL := http://${GITLAB_HOSTNAME}
endif

GITLAB_NGINX_BASE_CONFIG := nginx/${GITLAB_NGINX_BASE}.conf
GITLAB_NGINX_BASE_CONFIG_URL := https://gitlab.com/gitlab-org/gitlab-recipes/-/raw/master/web-server/nginx/${GITLAB_NGINX_BASE}.conf

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "install-gitlab"
	@echo "  Install GitLab"
	@echo "update-gitlab"
	@echo "  Update GitLab"
	@echo "save-gitlab-config"
	@echo "  Save GitLab configuration"
	@echo "diff-gitlab-config"
	@echo "  Diff GitLab configuration"
	@echo "init-gitlab-config"
	@echo "  Initialize GitLab configuration"
	@echo "commit-gitlab-config"
	@echo "  Commit GitLab configuration"
	@echo "update-gitlab-config"
	@echo "  Update GitLab configuration"
	@echo "download-gitlab-nginx-config"
	@echo "  Download GitLab Nginx config"
	@echo "install-nginx"
	@echo "  Install NGINX"
	@echo "update-nginx"
	@echo "  Update NGINX"
	@echo "save-nginx-config"
	@echo "  Save NGINX configuration"
	@echo "diff-nginx-config"
	@echo "  Difference NGINX configurations"
	@echo "init-nginx-config"
	@echo "  Initialize NGINX configuration"
	@echo "commit-nginx-config"
	@echo "  Commit NGINX configuration"
	@echo "update-nginx-config"
	@echo "  Update NGINX configuration"
	@echo "info"
	@echo "  Print configuration info"


info:
	@echo "GitLab config file: ${GITLAB_CONFIG_FILE}"
	@echo "Local GitLab config file: ${LOCAL_GITLAB_CONFIG_FILE}"
	@echo "GitLab hostname: ${GITLAB_HOSTNAME}"
	@echo "Use SSL: ${USE_SSL}"
	@echo "GitLab URL: ${GITLAB_URL}"
	@echo "GitLab Nginx config: ${GITLAB_NGINX_CONFIG_FILE}"
	@echo "GitLab Nginx base config: ${GITLAB_NGINX_BASE_CONFIG}"
	@echo "GitLab Nginx base config URL: ${GITLAB_NGINX_BASE_CONFIG_URL}"


#################################
# GitLab
#################################

# Install GitLab
install-gitlab:
	@echo "Installing GitLab..."
	@echo "Installing GitLab dependencies..."
	@sudo apt-get install -y curl openssh-server ca-certificates
	@echo "Adding GitLab repository..."
	@curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
	@echo "Installing GitLab..."
	@sudo apt-get install -y gitlab-ce
	@echo "Configuring GitLab..."
	@sudo gitlab-ctl reconfigure
	@echo "GitLab installed successfully!"

# Update GitLab
update-gitlab:
	@echo "Updating GitLab..."
	@sudo apt-get update
	@sudo apt-get install -y gitlab-ce
	@echo "GitLab updated successfully!"

# Backup GitLab
save-gitlab-config:
	@echo "Saving GitLab configuration..."
	@sudo cp ${GITLAB_CONFIG_FILE} ${LOCAL_GITLAB_CONFIG_FILE}
	@git add ${LOCAL_GITLAB_CONFIG_FILE}
	@git commit -m "Update GitLab configuration from installation."
	@echo "GitLab configuration saved successfully!"

# Diff GitLab configuration
diff-gitlab-config:
	@echo "Diffing GitLab configuration..."
	@sudo diff ${GITLAB_CONFIG_FILE} ${LOCAL_GITLAB_CONFIG_FILE}
	@if [ $$? -eq 0 ]; then \
		echo "GitLab configuration is up to date!"; \
	else \
		echo "GitLab configuration is not up to date!"; \
	fi

# Initialize GitLab configuration
init-gitlab-config:
	@echo "Initializing GitLab configuration..."
	@sudo sed -i 's/example.com/sergeant.work/g' /etc/gitlab/gitlab.rb
	@sudo sed -i 's/external_url "http:\/\/gitlab.example.com"/external_url "https:\/\/gitlab.sergeant.work"/g' /etc/gitlab/gitlab.rb

# Commit GitLab configuration
commit-gitlab-config: ${LOCAL_GITLAB_CONFIG_FILE}
	@git diff ${LOCAL_GITLAB_CONFIG_FILE}
	@if [ $$? -eq 0 ]; then \
		echo "GitLab configuration is up to date!"; \
	else \
		echo "GitLab configuration is not up to date!"; \
		echo "Committing GitLab configuration..."; \
		@git add ${LOCAL_GITLAB_CONFIG_FILE}; \
		@git commit -m "Update GitLab configuration file"; \
		echo "GitLab configuration committed successfully!"; \
	fi

# Restore GitLab
update-gitlab-config: ${GITLAB_CONFIG_FILE} commit-gitlab-config 
	@echo "Updating GitLab configuration..."
	@sudo gitlab-ctl stop
	@sudo cp ${LOCAL_GITLAB_CONFIG_FILE} ${GITLAB_CONFIG_FILE}	
	@sudo gitlab-ctl reconfigure
	@echo "GitLab configuration updated successfully!"

#################################
# NGINX
#################################

# Download GitLab Nginx config
download-gitlab-nginx-config:
	@echo "Downloading GitLab Nginx config..."
	@wget -O ${GITLAB_NGINX_BASE_CONFIG} ${GITLAB_NGINX_BASE_CONFIG_URL}
	@echo "GitLab Nginx config downloaded successfully!"


# GITLAB_NGINX_CONFIG_FILE

# Initialize GitLab configuration
init-gitlab-nginx-config:
	@echo "Initializing GitLab Nginx configuration..."
	@cp ${GITLAB_NGINX_BASE_CONFIG} ${GITLAB_NGINX_CONFIG_FILE}
	@sudo sed -i 's/YOUR_SERVER_FQDN/${GITLAB_HOSTNAME}/g' ${GITLAB_NGINX_CONFIG_FILE}	
	@echo "GitLab Nginx configuration initialized successfully!"

update-nginx-config: ${GITLAB_NGINX_CONFIG_FILE}
	@echo "Updating Nginx configuration..."
	@sudo cp ${GITLAB_NGINX_CONFIG_FILE} /etc/nginx/sites-available/${GITLAB_NGINX_CONFIG_FILE}

enable-gitlab-nginx: update-nginx-config
	@echo "Enabling GitLab Nginx on ${GITLAB_HOSTNAME} using ${GITLAB_NGINX_CONFIG_FILE}"
	@sudo ln -s /etc/nginx/sites-available/${GITLAB_NGINX_CONFIG_FILE} /etc/nginx/sites-enabled/${GITLAB_NGINX_CONFIG_FILE}
	@sudo service nginx restart

disable-gitlab-nginx:
	@echo "Disabling GitLab Nginx on ${GITLAB_HOSTNAME} using ${GITLAB_NGINX_CONFIG_FILE}"
	@sudo rm /etc/nginx/sites-enabled/gitlab
	@sudo service nginx restart




