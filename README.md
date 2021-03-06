# Markdown-to-HTML Conversion Web Site in Docker Container

This Docker image runs Apache web server and dynamically converts a Markdown file to HTML using Pandoc converter and a simple apache filter.

> Use this version if you can freely manage your Docker host and plan to serve local files in the Docker host. See 'docker-pandoc-remote' if you want to place source files in some remote location or put the image in a public container service.

## Components

The container image includes:

- base image: `httpd` from Docker Hub,
- `Pandoc` installed during Docker build,
- Apache mod_ext_filter-compliant filter written in Bash shell (pandoc-filter), and
- Apache configuration file to enable the filter (local.conf).

## Build

To build a docker image, install Docker and Git and execute the following on a machine where you host the container:

```
$ git clone https://github.com/kobucom/docker-pandoc
$ cd docker-pandoc
$ docker build --tag pandoc:test .
```

> Prebuilt images (amd64 and arm) are available at the Docker Hub: [kobucom/pandoc](https://hub.docker.com/r/kobucom/pandoc).
Choose images tagged as 'local'. 

## Prerequisites

You need to place Markdown source files and other web contents in the host file system outside the container.
You also need a place to collect Apache log files.

Prepare two host-side directories for web contents and log files.
They are mapped to the following directories in the container:

| Directory | Container side | Host side (in my case) |
|--|--|--|
| htdocs | /usr/local/apache2/htdocs | /var/docker/pandoc/htdocs |
| logs | /usr/local/apache2/logs | /var/docker/pandoc/logs |

The 'htdocs' directory in the github project contains sample files.
As a start, place these files in the host-side `htdocs` directory.
You can check access and error logs by checking the host-side `logs` directory.

## Run

Execute the following command to run the web site.

```
$ docker run --publish 8080:80 --detach \
	--mount type=bind,src=/var/docker/pandoc/htdocs,dst=/usr/local/apache2/htdocs,ro \
	--mount type=bind,src=/var/docker/pandoc/logs,dst=/usr/local/apache2/logs \
    pandoc:test
$ curl localhost:8080/test.md
```

You can access the container from outside the host as 'http://*yourhost*:8080/test.md'.

>Note that the container uses port 80 for receiving web requests.
The `-p` option maps a host-side port to the container-side port.

## Cleanup

Here is a command to stop the web site.

```
$ docker ps
CONTAINER ID  IMAGE        COMMAND             CREATED            STATUS            PORTS ... 
4a1d178dc122  pandoc:test  "httpd-foreground"  About an hour ago  Up About an hour  0.0.0.0:8080->80/tcp ... 
$
$ docker kill 4a1d178dc122
4a1d178dc122
```

## License

The included filter (pandoc-filter), apache configuration (local.conf) and Dockerfile are created by a Kobu.Com engineer and these are public domain.

See licenses for products used to build this docker image: Apache2, Pandoc and Docker.

---

2020-09-13 created and tested under raspberry pi with raspbian (armhf)  
2020-09-14 published to github as 'kobucom/docker-pandoc'  
2020-09-20 tested under debian10 (buster) on cloud (amd64)  
2020-09-21 published to docker hub as 'kobucom/pandoc:local'

Visit [Kobu.Com](https://kobu.com/docker/index-en.html).
