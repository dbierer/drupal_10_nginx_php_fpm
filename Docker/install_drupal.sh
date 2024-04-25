#!/bin/bash
# usage: install_drupal_using_cli.sh [USER]
. /tmp/secrets.sh

# bail out if already installed
if [[ -d "$DRUPAL_CORE_DIR" ]]; then
    echo "Drupal already installed ..."
    exit 0
fi

cd $DRUPAL_DIR
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

echo "Downloading/updating Composer ..."
php composer.phar self-update

# Make sure you have the right PHP extensions installed
# PHP reqs are listed here: https://github.com/drupal/core/blob/11.x/composer.json
# (Substitute "11.x" for the version of Drupal you are using
echo "Installing Drupal core ..."

# Install Drupal recommended project
php composer.phar create-project --ignore-platform-reqs drupal/recommended-project ./$HOST_NAME
cp ./$HOST_NAME/web/sites/default/default.settings.php ./$HOST_NAME/web/sites/default/settings.php

# Setup Drupal using Drush
cp ./composer.phar ./$HOST_NAME/composer.phar
cd $HOST_NAME
php composer.phar require --ignore-platform-reqs drush/drush
vendor/bin/drush si -y --db-url=mysql://$DB_USR:$DB_PWD@$DB_HOST:$DB_PORT/$DB_NAM --account-name=$DRUPAL_ADM --account-pass=$DRUPAL_PWD

# Install theme
php composer.phar require drupal/adminimal_theme:">=1.7"
