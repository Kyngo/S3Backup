#!/bin/bash

source ./credentials

DATEAPP="date"
UNAME=`uname`
if [ $UNAME == "Darwin" ]; then
    DATEAPP="gdate"
fi

TODAY=`${DATEAPP} +%F`
DIRS=`cat ./directories`
DIRS=$DIRS" exit"

function _Restore() {
    if [ -f /tmp/backup.tar.gz ]; then
        echo "Removing previous backup file..."
        rm -rf /tmp/backup.tar.gz
    fi
    i=`echo $1 | rev | cut -f 1 -d"/" | rev`
    FILENAME=${i##*/}
    if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then 
        echo "Bucket found, looking for latest backup..."
        LATEST=`aws s3 ls s3://$BUCKET/$FILENAME/ | tr "\n" " " | tr -s " " | rev | cut -f 2 -d " " | rev | cut -f1 -d "/"`
        echo "Latest backup found is $LATEST. Downloading..."
        aws s3 cp s3://$BUCKET/$FILENAME/$LATEST/backup.tar.gz /tmp/backup.tar.gz
        echo "Proceeding to restore the backup..."
        mkdir -p $1
        tar zxvf /tmp/backup.tar.gz --directory /
    else
        >&2 echo "Bucket does not exist!"
        exit 1
    fi
}

PS3='Choose what project to restore: '
select opt in ${DIRS[@]}
do
    case $opt in
        "exit") 
            echo "Bye!"
            break
            ;;
        *)
            _Restore $opt
            ;;
    esac
done