<p align="center">
 <img alt="docker-rpcn logo" src="https://raw.githubusercontent.com/K4rian/docker-rpcn/assets/icons/logo-docker-rpcn.svg" width="25%" align="center">
</p>

A Docker image for the [RPCN][1] P2P match-making server based on the official [Alpine Linux][2] [image][3].<br>
The server allows you to play [many PS3 games][4] with P2P match-making support via netplay using the [RPS3][5] emulator.

---
<div align="center">

Docker Tag  | Version | Description    | Release Date
---         | ---     | ---            | ---
[latest][6] | 1.0     | Latest release | 2023-10-17
</div>
<p align="center"><a href="#environment-variables">Environment variables</a> &bull; <a href="#usage">Usage</a> &bull; <a href="#using-compose">Using Compose</a> &bull; <a href="#manual-build">Manual build</a> <!-- &bull; <a href="#see-also">See also</a> --> &bull; <a href="#license">License</a></p>

---
## Environment variables
Some environment variables can be tweaked when creating a container to define the server configuration:

<details>
<summary>Click to expand</summary>

Variable                | Default value  | Description 
---                     | ---            | ---
RPCN_HOST               | 0.0.0.0        | Host to bind to.
RPCN_PORT               | 31313          | Port<sup>1</sup> to listen on (TCP).
RPCN_CREATEMISSING      | true           | Create missing PSN servers IDs internally.
RPCN_LOGVERBOSITY       | Info           | Determines the verbosity of the logging. Valid values are: Trace, Debug, Info, Warn, Error.
RPCN_EMAILVALIDATION    | false          | This determines if emails are validated (if an email is sent to verify it and if a token is required).
RPCN_EMAILHOST          |                | If empty, the server will bind on localhost:25 and credentials settings are ignored. Not started if email validation is set to false.
RPCN_EMAILLOGIN         |                | Email server login.
RPCN_EMAILPASSWORD      |                | Email server password.
RPCN_SIGNTICKETS        | false          | Determines if tickets are signed.
RPCN_SIGNTICKETSDIGEST  | SHA224         | OpenSSL message digest algorithm used to sign tickets.
RPCN_ENABLESTATSERVER   | false          | Enables a minimal web server to display stats.
RPCN_STATSERVERHOST     | 0.0.0.0        | Web stat server host.
RPCN_STATSERVERPORT     | 31314          | Web stat server port.

> <sup>1</sup> The server requires the following extra port to be opened: __3657__ (UDP).<br>

</details>

## Usage
Run a public server using default configuration: 
```bash
docker run -d \
  --name rpcn \
  -p 3657:3657 \
  -p 31313:31313 \
  -i k4rian/rpcn:latest
```

## Using Compose
See [compose/README.md][7]

## Manual build
__Requirements__:<br>
— Docker >= __18.09.0__<br>
— Git *(optional)*

Like any Docker image the building process is pretty straightforward: 

- Clone (or download) the GitHub repository to an empty folder on your local machine:
```bash
git clone https://github.com/K4rian/docker-rpcn.git .
```

- Then run the following command inside the newly created folder:
```bash
docker build --no-cache -t k4rian/rpcn .
```
> The building process can take up to 5 minutes depending on your hardware specs. <br>
> A quad-core CPU with at least 1 GB of RAM and 2 GB of disk space is recommended for the compilation.

<!---
## See also
* __[RPCN Egg](https://github.com/K4rian/)__ — A custom egg of RPCN for the Pterodactyl Panel.
* __[RPCN Template](https://github.com/K4rian/)__ — A custom template of RPCN ready to deploy from the Portainer Web UI.
--->

## License
[MIT][8]

[1]: https://github.com/RipleyTom/rpcn "RPCN Repository"
[2]: https://www.alpinelinux.org/ "Alpine Linux Official Website"
[3]: https://hub.docker.com/_/alpine "Alpine Linux Docker Image"
[4]: https://wiki.rpcs3.net/index.php?title=RPCN_Compatibility_List "RPCN Compatibility List"
[5]: https://rpcs3.net/ "RPCS3 Project Website"
[6]: https://github.com/K4rian/docker-rpcn/blob/master/Dockerfile "Latest Dockerfile"
[7]: https://github.com/K4rian/docker-rpcn/tree/master/compose "Compose Files"
[8]: https://github.com/K4rian/docker-rpcn/blob/master/LICENSE