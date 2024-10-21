import configparser
import os
import subprocess

CONFIG_FILE = 'postgres-config.ini'
# Ask for username, password, and API server port
username = input("Enter PostgreSQL username: ")
password = input("Enter PostgreSQL password: ")
api_port = input("Enter API server port: ")
domain_name = input("Enter your domain name: ")

# Write to INI file
config = configparser.ConfigParser()
config['PostgreSQL'] = {'username': username, 'password': password, 'api_port': api_port, 'domain_name': domain_name}

with open('config.ini', 'w') as configfile:
    config.write(configfile)

# Read from INI file
config.read('config.ini')
username = config.get('PostgreSQL', 'username')
password = config.get('PostgreSQL', 'password')
api_port = config.get('PostgreSQL', 'api_port')
domain_name = config.get('PostgreSQL', 'domain_name')

# Pull PostgreSQL Image
subprocess.run(['docker', 'pull', 'postgres'])

db_name = 'my_database'
container_name = 'my-postgres-db'
# Run PostgreSQL Container
subprocess.run(['docker', 'run', '--name', container_name, 
'-e', f'POSTGRES_USER={username}', 
'-e', f'POSTGRES_PASSWORD={password}', 
'-e', f'POSTGRES_DB={db_name}', 
'-p', '5432:5432', 
'-d', 'postgres'])

volume_path = os.path.abspath('postgres-data')

# Persist Data
subprocess.run(['docker', 'run', '--name', container_name, 
'-e', f'POSTGRES_USER={username}', 
'-e', f'POSTGRES_PASSWORD={password}', 
'-e', f'POSTGRES_DB={db_name}', 
'-p', '5432:5432', 
'-v', f'{volume_path}:/var/lib/postgresql/data', 
'-d', 'postgres'])

# Set up NGINX server block
nginx_config = f"""
server {{
    listen 80;
    server_name {domain_name};

    location / {{
        proxy_pass http://localhost:{api_port};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }}
}}
"""

with open(f'/etc/nginx/sites-available/{domain_name}', 'w') as file:
    file.write(nginx_config)

# Enable the server block
subprocess.run(['sudo', 'ln', '-s', f'/etc/nginx/sites-available/{domain_name}', '/etc/nginx/sites-enabled/'])

# Test NGINX configuration
subprocess.run(['sudo', 'nginx', '-t'])

# Reload NGINX
subprocess.run(['sudo', 'systemctl', 'reload', 'nginx'])