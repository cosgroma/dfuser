# How to Set Up a PostgreSQL Database on a Linux Server

## Introduction

Setting up a PostgreSQL database on your own server, accessible via a URL like mydb.sergeant.work, and syncing it with your local SQLAlchemy ORM, involves several steps. Here’s a high-level overview of how you can achieve this, especially with Docker and NGINX in your environment:

1. Set Up PostgreSQL Database Server

Since you're considering Docker, you can run PostgreSQL in a Docker container. This approach simplifies installation, configuration, and ensures portability.

Dockerizing PostgreSQL
Pull PostgreSQL Image:

```bash
docker pull postgres
```

Run PostgreSQL Container:
Create and start a PostgreSQL container. You can specify the database name, user, and password.

```bash
docker run --name my-postgres -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydb -p 5432:5432 -d postgres
```

Persist Data:
Use Docker volumes to persist your database data. Without a volume, the data will be lost when the container is removed.

```bash
docker run --name my-postgres -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydb -p 5432:5432 -v /my/local/path:/var/lib/postgresql/data -d postgres
```

2. Configure Domain and NGINX

To access your database via mydb.sergeant.work, you'll need to configure DNS and NGINX.

DNS Configuration
Point mydb.sergeant.work to your server’s IP address. This is usually done through your domain registrar's control panel or DNS management tool.
NGINX Configuration
NGINX will be used to proxy HTTP requests but not database connections. PostgreSQL uses its own protocol, not HTTP, so NGINX doesn’t directly interact with PostgreSQL in a typical setup.

However, if you plan to expose an API that interacts with your database, you can set up a virtual host in NGINX for that API.
Example NGINX Config for an API Server:

```nginx
server {
    listen 80;
    server_name api.sergeant.work;

    location / {
        proxy_pass http://localhost:API_PORT; # Replace with your API server port
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

3. Sync with SQLAlchemy ORM

To sync your local SQLAlchemy ORM with the PostgreSQL database:

Configure SQLAlchemy to use the PostgreSQL database by setting the database URI in your SQLAlchemy configuration to point to your PostgreSQL instance. Example:

```python
SQLALCHEMY_DATABASE_URI = 'postgresql://myuser:mypassword@mydb.sergeant.work:5432/mydb'
```

Ensure your local network allows outbound connections to your server's PostgreSQL port (5432 by default).

4. Security Considerations

Firewall: Only allow connections to the PostgreSQL port from known IP addresses.
SSL/TLS: Consider setting up SSL/TLS for your PostgreSQL instance to encrypt data in transit.
Regular Backups: Implement a backup strategy for your PostgreSQL database.

5. Maintenance and Monitoring

Regularly update your PostgreSQL Docker container to get security and feature updates.
Monitor your PostgreSQL logs for any unusual activity or performance issues.

6. Additional Tools

If you need a web-based interface to manage your PostgreSQL database, you can use tools like pgAdmin or Adminer in Docker containers, ensuring they are secured and only accessible over HTTPS.

By following these steps, you should be able to set up and sync your database with your local SQLAlchemy ORM, using PostgreSQL, Docker, and NGINX on your Linux server. Remember, database and server management can be complex and it's important to consider security at every step.

