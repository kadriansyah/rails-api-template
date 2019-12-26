#!/bin/bash
#docker run -d --rm --name api "$PWD":/var/www/html/#appname.com -p 80:80 -p 3000:3000 kadriansyah/#appname

# link to other container
docker run -d --name api -v "$PWD":/var/www/html/#appname.com --link mongoapi -p 80:80 -p 3000:3000 kadriansyah/#appname