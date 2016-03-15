#!/bin/bash
set -e

function abort()
{
	echo "$@"
	exit 1
}

function cleanup()
{
	echo " --> Stopping container"
	docker stop $ID >/dev/null
	docker rm $ID >/dev/null
}

PWD=`pwd`

echo " --> Starting test container"
ID=`docker run -d -v $PWD/test:/test $NAME-$VERSION /sbin/my_init`
sleep 1

echo " --> Obtaining IP"
IP=`docker inspect -f "{{ .NetworkSettings.IPAddress }}" "$ID"`
if [[ "$IP" = "" ]]; then
	abort "Unable to obtain container IP"
fi

echo " --> Logging into container and running tests"
sleep 1 # Give container some more time to start up.
docker exec -t $ID  /test/test.sh $RUBY

trap cleanup EXIT
