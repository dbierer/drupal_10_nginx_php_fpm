#!/bin/bash
# NOTE: this is for demo only!
export PHP_VER="8.2"
export HOST_NAME=drupal.local
export HOST_URL=http://drupal.local/
export DB_USR=someuser
export DB_PWD=somepassword
export DB_NAM=somedatabase
export DB_HOST="127.0.0.1"
export DB_PORT=3306
export REPO_DIR=/home/repo
export REPO_BACKUP_DIR=$REPO_DIR/backup
export ADMINER_VER="4.8.1"
export DRUPAL_ADM=admin
export DRUPAL_PWD=password
export DRUPAL_EML="admin@drupal.local"
export DRUPAL_ENV=development
export DRUPAL_DIR=$REPO_DIR/Labs
export DRUPAL_CORE_DIR=/var/www/drupal/web
export CONTAINER=drupal_demo
export CONTAINER_IP="10.10.60.10"
export CONTAINER_SUBNET="10.10.60.0\/24"
export CONTAINER_GATEWAY="10.10.60.1"
