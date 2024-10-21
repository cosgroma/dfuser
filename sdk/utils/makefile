
gofileserver:
	docker run -d --restart unless-stopped -p 8000:8000 -v /db:/app/public --name gohttpserver cosgroma/gohttpserver --auth-type http --auth-http sergeant:sergeant --xheaders
