#!/bin/bash
docker run -d --name api -v "$PWD":/var/www/html/#appname.com --network=development_default -p 80:8080 -p 443:8443 -p 3000:3000 kadriansyah/#appname