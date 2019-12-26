# image name: kadriansyah/nginx
FROM  kadriansyah/nginx
LABEL version="1.0"
LABEL maintainer="Kiagus Arief Adriansyah <kadriansyah@gmail.com>"

RUN set -ex \
    && buildDeps=' \
            gcc \
            make \
            libxml2 \
            libxml2-dev \
            libxslt1-dev \
            zlib1g-dev \
            build-essential \
    ' \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends $buildDeps;

COPY #appname.pem /etc/ssl/
COPY #appname.key /etc/ssl/
COPY #appname.com /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/#appname.com /etc/nginx/sites-enabled/#appname.com

RUN mkdir /var/www/html/#appname.com
RUN chown -R app:app /var/www/html/#appname.com
WORKDIR /var/www/html/#appname.com
COPY --chown=app:app . .
RUN chmod +x reload.sh
RUN chmod +x rails_s.sh

ENV RAILS_ENV='production'
RUN gem install bundler:2.1.2;
RUN set -ex \
    && bundle config build.nokogiri --use-system-libraries \
    && gem install pkg-config -v "~> 1.1" \
    && bundle install --jobs 20 --retry 5 \
    && chown -R app:app .bundle;

# make sure we make log and tmp owned by app
RUN set -ex \
    && rm -rf log \
    && mkdir log \
    && rm -rf tmp \
    && mkdir tmp \
    && chown -R app:app /var/www/html/#appname.com/public \
    && chown -R app:app tmp \
    && chown -R app:app log;

RUN set -ex \
    && apt-get purge -yqq $buildDeps --auto-remove;

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# You cannot open privileged ports (<=1024) as non-root
EXPOSE 8080 8443 3000
CMD ["nginx", "-g", "daemon off;"]