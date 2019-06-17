#!/bin/sh
set -e

cd /go/src/github.com/lifei6671/go-git-webhook/

goFile="go-git-webhook"


chmod +x $goFile

if [ ! -f "conf/app.conf" ] ; then
    cp conf/app.conf.example conf/app.conf
fi

if [ ! -z $db_host ] ; then
    sed -i 's/^db_host.*/db_host='$db_host'/g' conf/app.conf
fi

if [ ! -z $db_port ] ; then
    sed -i 's/^db_port.*/db_port='$db_port'/g' conf/app.conf
fi

if [ ! -z $db_database ] ; then
    sed -i 's/^db_database.*/db_database='$db_database'/g' conf/app.conf
fi

if [ ! -z $db_username ] ; then
    sed -i 's/^db_username.*/db_username='$db_username'/g' conf/app.conf
fi

if [ ! -z $db_password ] ; then
    sed -i 's/^db_password.*/db_password='$db_password'/g' conf/app.conf
fi

if [ ! -z $httpport ] ; then
    sed -i 's/^httpport.*/httpport='$httpport'/g' conf/app.conf
fi

#初始化数据
if [ ! -f "install.lock" ] ; then
    if [ -z $account ]; then
        echo "Then parameter $account is required"
        exit 1
    fi
    ./$goFile orm syncdb
     echo "Initialized successfully."

    ./$goFile install -account=$account -password=$password -email=$email

    touch install.lock
fi

./$goFile