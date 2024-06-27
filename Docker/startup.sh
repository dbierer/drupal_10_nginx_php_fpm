#!/bin/bash
. /tmp/secrets.sh

if [[ -d $DRUPAL_DIR ]]; then
    echo "Enabling nginx-Drupal configuration ..."
    ln -s -f /etc/nginx/sites-available/drupal.conf /etc/nginx/sites-enabled/drupal.conf
    ln -s -f $DRUPAL_DIR /var/www/$HOST_NAME
else
    echo "Disabling nginx-Drupal configuration ..."
    rm -f /etc/nginx/sites-enabled/drupal*
fi

echo "Assigning permissions ..."
chown -R www-data:zendphp /var/www
chmod -R 775 /var/www/*
chown -R www-data:zendphp $REPO_DIR
chmod -R 775 $REPO_DIR/*

echo "Updating /etc/hosts ..." && \
echo "$CONTAINER_IP   $HOST_NAME" >> /etc/hosts

# Start the first process
/etc/init.d/mysql start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start MySQL: $status"
  exit $status
fi
echo "Started MySQL succesfully"

# Start the second process
/etc/init.d/php$PHP_VER-zend-fpm start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start php-fpm: $status"
  exit $status
fi
echo "Started php-fpm succesfully"

# Start the third process
/etc/init.d/nginx start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi
echo "Started nginx succesfully"

while sleep 60; do
  ps -ax |grep php-fpm |grep -v grep
  PROCESS_1_STATUS=$?
  ps -ax |grep nginx |grep -v grep
  PROCESS_2_STATUS=$?
  ps -ax |grep mysql |grep -v grep
  PROCESS_3_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ -f $PROCESS_1_STATUS -o -f $PROCESS_2_STATUS -o -f $PROCESS_3_STATUS ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done


