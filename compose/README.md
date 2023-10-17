RPCN P2P Match-making Server using Docker Compose
=====
This example defines a basic set up for a RPCN P2P Match-making Server using Docker Compose. 

Project structure:
```
.
├── docker-compose.yml
├── rpcn.env
└── README.md
```

[_docker-compose.yml_](docker-compose.yml)
```
services:
  rpcn:
    image: k4rian/rpcn:latest
    container_name: rpcn
    volumes:
      - data:/home/rpcn
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - rpcn.env
    ports:
      - 33131 # TCP
      - 3657  # UDP
    restart: unless-stopped

volumes:
  data:
```

* When deploying, Compose maps the server ports to the same ports of the host as specified in the compose file.

* The environment file *[rpcn.env](rpcn.env)* holds the server configuration.

## Deployment
```bash
docker compose -p rpcn up -d
```
*__Note__*: the project is using a volume in order to store the server data that can be recovered if the container is removed and restarted.

## Expected result
Check that the container is running properly:
```bash
docker ps | grep "rpcn"
```

To see the server log output:
```bash
docker compose -p rpcn logs
```

## Stop the container
Stop and remove the container:
```bash
docker compose -p rpcn down
```

Both the container and its volume can be removed by providing the `-v` argument:
```bash
docker compose -p rpcn down -v
```