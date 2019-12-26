#!/bin/bash
docker run -d --rm --name app "$PWD":/var/www/html/#appname.com -p 80:80 -p 3000:3000 kadriansyah/#appname

# # link to other container
# docker run -d --name app -v "$PWD":/var/www/html/#appname.com --link mongo -p 80:80 -p 3000:3000 kadriansyah/#appname