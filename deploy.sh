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
echo "Membaca file konfigurasi : $ENV_FILE"
source $ENV_FILE

echo "Ghost-CMS akan di install dengan konfigurasi berikut:"
echo "POSTGRESQL superuser password: $POSTGRES_USER"
echo "POSTGRESQL superuser password: $POSTGRES_PASSWORD"
echo "POSTGRESQL host data folder: $POSTGRES_HOST_PATH"
echo "Ghost host data folder: $GHOST_HOST_PATH"
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
echo "memulai install..."
pushd webapps/ > /dev/null
docker-compose up -d
