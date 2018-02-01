#!/bin/bash
echo 'update service config'

NUGET_API=${NUGET_API:-test}
NUGET_HOST=${NUGET_HOST:-localhost}
MYSQL_HOST=${MYSQL_HOST:-mysql}
MYSQL_PORT=${MYSQL_PORT:-3306}
MYSQL_DB_NAME=${MYSQL_DB_NAME:-nugetdb}
MYSQL_USER=${MYSQL_USER:-nugetuser}
MYSQL_PW=${MYSQL_PW:-mysql_pw}

sed -i -- 's/dbName.*/dbName = "'"mysql:host=$MYSQL_HOST:$MYSQL_PORT;dbname=$MYSQL_DB_NAME"'";/g' $NUGET_PATH/inc/config.php
echo "Config::\$dbUsername = '$MYSQL_USER';" >> $NUGET_PATH/inc/config.php
echo "Config::\$dbPassword = '$MYSQL_PW';" >> $NUGET_PATH/inc/config.php
sed -i -- 's/apiKey.*/apiKey = "'"$NUGET_API_KEY"'";/g' $NUGET_PATH/inc/config.php 
sed -i -- 's/example.com/'"$NUGET_HOST"'/g' /etc/nginx/conf.d/default.conf 
sed -i -- 's/return.*http:.*;/return "'"$NUGET_DEFAULT_HTTP"':\/\/";/g' $NUGET_PATH/inc/core.php 

chown www-data /app/db
chown www-data /app/packagefiles

echo 'Starting services'
/etc/init.d/php7.0-fpm start
/etc/init.d/php7.0-fpm restart
/etc/init.d/nginx restart

tail -f /dev/null