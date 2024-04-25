# OS=one of ubuntu, centos, or debian
ARG OS=ubuntu
# OS_VERSION=OS version to use; e.g., 20.04, 8, and 10
ARG OS_VERSION=22.04
# PHP version to use; can be 5.6, 7.1, 7.2, 7.3, 7.4, or 8.0.
# Ability to build a version is dependent on having ZendPHP credentials that
# authorize use of that version.
ARG ZENDPHP_VERSION=8.2
# BASE_IMAGE=cli or fpm
ARG BASE_IMAGE=fpm
# Append -arm after $BASE_IMAGE if you wish to use the ARM variant
FROM cr.zend.com/zendphp/${ZENDPHP_VERSION}:${OS}-${OS_VERSION}-${BASE_IMAGE}
MAINTAINER doug@unlikelysource.com
COPY index.php /tmp/index.php
COPY hosts /etc/hosts
COPY startup.sh /tmp/startup.sh
COPY secrets.sh /tmp/secrets.sh
COPY install_drupal.sh /tmp/install_drupal.sh
COPY backup.sh /tmp/backup.sh
COPY restore.sh /tmp/restore.sh
COPY drupal.conf /tmp/drupal.conf
COPY nginx.default.conf /tmp/default.conf
COPY update_conf.php /tmp/update_conf.php
RUN chmod +x /tmp/*.sh
RUN chmod +x /tmp/*.sh
RUN \
    echo "Installing misc tools ..." && \
    apt-get update && \
    apt-get install -y less vim net-tools wget unzip
RUN \
    echo "Installing Mariadb (MySQL open source equivalent) ..." && \
    apt-get install -y mysql-server && \
    /etc/init.d/mysql start && \
    sleep 3 && \
    . /tmp/secrets.sh && \
	mysql -uroot -ppassword -v -e "CREATE DATABASE IF NOT EXISTS $DB_NAM;" && \
	mysql -uroot -ppassword -v -e "CREATE USER IF NOT EXISTS '$DB_USR'@'$DB_HOST' IDENTIFIED BY '$DB_PWD';" && \
	mysql -uroot -ppassword -v -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USR'@'$DB_HOST';" && \
	mysql -uroot -ppassword -v -e "FLUSH PRIVILEGES;"
RUN \
    echo "Installing nginx ..." && \
    apt-get install -y nginx && \
    mv /tmp/index.php /var/www/html/index.php && \
    mv -v /etc/nginx/sites-available/default /etc/nginx/sites-available/default.old && \
    mv -v /tmp/default.conf /etc/nginx/sites-available/default && \
    ln -s -f /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
RUN \
    echo "Adding/enabling PHP extensions ..." && \
    # PHP reqs are listed here: https://github.com/drupal/core/blob/11.x/composer.json
    # (Substitute "11.x" for the version of Drupal you are using
    zendphpctl ext install simplexml && \
    zendphpctl ext install mysql && \
    zendphpctl ext install pdo_mysql && \
    zendphpctl ext install gd && \
    zendphpctl ext install mbstring && \
    zendphpctl ext install curl
RUN \
    echo "Installing Adminer (phpMyAdmin equivalent) ..." && \
    . /tmp/secrets.sh && \
    cd /tmp && \
    wget https://github.com/vrana/adminer/releases/download/v$ADMINER_VER/adminer-$ADMINER_VER-mysql.php && \
    cp adminer-$ADMINER_VER-mysql.php /var/www/html/adminer.php
RUN \
    echo "Set up nginx configuration for Drupal ... " && \
    php /tmp/update_conf.php && \
    cp /tmp/drupal.conf.new /etc/nginx/sites-available/drupal.conf && \
    ln -s -f /etc/nginx/sites-available/drupal.conf /etc/nginx/sites-enabled/drupal.conf
WORKDIR /home/training
ENTRYPOINT /tmp/startup.sh
