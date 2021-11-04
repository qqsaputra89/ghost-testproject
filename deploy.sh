#!/bin/bash

if [[ $# != 1 ]]
then
  echo 'his script takes exactly 1 argument'
  echo 'Usage: ./deploy $ENV_FILE_PATH'
  exit 1
fi

ENV_FILE=$1

if [[ ! -f $ENV_FILE ]]
then
	echo "EXITING: $ENV_FILE not found!"
  exit 1
fi

# Loading environment variables
echo "Sourcing $ENV_FILE"
source $ENV_FILE

echo "Ghost-CMS akan di install dengan konfigurasi berikut:"
echo "MySQL user password: $MYSQL_PASSWORD"
echo "MySQL root password: $MYSQL_ROOT_PASSWORD"
echo "Ghost host data folder: $GHOST_HOST_PATH"
echo "MySQL host data folder: $MYSQL_HOST_PATH"
echo "Nginx host config folder: $NGINX_HOST_PATH"
echo "HTTP port: $NGINX_HTTP_PORT"
echo "HTTPS port: $NGINX_HTTPS_PORT"

read -p "Apakah anda yakin untuk menginstall Ghost-CMS dengan konfigurasi di atas? (Y : installasi dilanjutkan / N : installasi dibatalkan): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "installasi dibatalkan, periksa kembali file *.env anda, dan mulai kembali dengan perintah : ./deploy $ENV_FILE_PATH"
  exit 1
fi

echo "Creating host folders..."
mkdir -p $GHOST_HOST_PATH
mkdir -p $MYSQL_HOST_PATH
if [[ ! -d $NGINX_HOST_PATH ]]
then
  # Copy default nginx configuration
  cp -r nginx/ $NGINX_HOST_PATH
fi    
echo "Deploying..."
pushd blog/ > /dev/null
docker-compose up -d
