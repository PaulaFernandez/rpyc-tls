1. Create a network first:

`docker network create company-network`

2. Edit your hosts file to add a DNS record pointing to localhost or your local IP:

`127.0.0.1 gecco.company.com`

3. Start a Traefik service and attach it to the company-network. An example of working docker-compose file is in the folder called traefik.

4. Build and deploy the image (note that this setup relies on the correct certificates being there, I created mine using openSSL):

`HOME='/path_to_certs' docker-compose up --build -d`

5. Run the file client.py on local, changing the certs path first:

```
poetry update
poetry install
poetry run python rpyc_tls/client.py
```

It will connect to the server through Traefik, using TLS.

6. Comment/uncomment the following lines in docker-compose.yml to make sure we use HostSNI:

```
# - "traefik.tcp.routers.gecko.rule=HostSNI(`*`)"
- "traefik.tcp.routers.gecko.rule=HostSNI(`gecko.company.com`)"
```

7. Redeploy:

`HOME='/path_to_certs' docker-compose up --force-recreate`

8. Repeat step 5 and noticed the connection is refused.