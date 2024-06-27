#!/bin/bash
# You need to run this as root
. /tmp/secrets.sh

# bail out if already installed
echo "Checking to see if Drupal is installed ..."
if [[ -d "$DRUPAL_CORE_DIR" ]]; then
    echo "Drupal already installed ..."
    exit 0
fi

cd $REPO_DIR
export USR=$USER
if [[ ! -z "$1" ]]; then
    export USR=$1
fi

echo "Checking that MySQL is running ..."
MYSQL_STATUS=`ps -ax |grep mysql |grep -v grep`
if [[ -f $MYSQL_STATUS ]]; then
    echo "Starting MySQL ..."
    /etc/init.d/mysql start
    sleep 3
fi

echo "Updating Composer ..."
/usr/bin/composer self-update

# Make sure you have the right PHP extensions installed
# PHP reqs are listed here: https://github.com/drupal/core/blob/11.x/composer.json
# (Substitute "11.x" for the version of Drupal you are using)

# Install Drupal recommended project
echo "Installing Drupal core ..."
/usr/bin/composer create-project --ignore-platform-reqs drupal/recommended-project ./$HOST_NAME
cd $HOST_NAME
cp ./web/sites/default/default.settings.php ./web/sites/default/settings.php

# Setup Drupal using Drush
echo "Installing Drupal database ..."
/usr/bin/composer require --ignore-platform-reqs drush/drush
vendor/bin/drush si -y --db-url=mysql://$DB_USR:$DB_PWD@$DB_HOST:$DB_PORT/$DB_NAM --account-name=$DRUPAL_ADM --account-pass=$DRUPAL_PWD

# Install and enable theme
echo "Installing Adminimal theme ..."
/usr/bin/composer require drupal/adminimal_theme:">=1.7"
vendor/bin/drush theme:enable -y adminimal_theme

echo "Set up nginx configuration for Drupal ... "
php /tmp/update_conf.php
cp /tmp/drupal.conf.new /etc/nginx/sites-available/drupal.conf
ln -s -f /etc/nginx/sites-available/drupal.conf /etc/nginx/sites-enabled/drupal.conf

# Creating symlink for nginx
ln -s -f $DRUPAL_DIR /var/www/$HOST_NAME
/etc/init.d/nginx restart
