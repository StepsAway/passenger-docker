#!/bin/bash
if [[ "$PASSENGER_APP_ENV" != "" ]]; then
        echo "passenger_app_env '$PASSENGER_APP_ENV';" > /etc/nginx/conf.d/00_app_env.conf
fi

if [ -z $WORKER_PROCESSES ]; then
  printf "WORKER_PROCESSES NOT SET.\nUsing default value of 1"
else
  sed -e "s/worker_processes 1;/worker_processes \${WORKER_PROCESSES};/" /etc/nginx/nginx.conf > /tmp/nginx.tmpl
  envsubst '${WORKER_PROCESSES}' < /tmp/nginx.tmpl > /etc/nginx/nginx.conf
  rm /tmp/nginx.tmpl
fi


# Set Passenger Pool Size
if [ -z $PASSENGER_POOL_SIZE ]; then
  printf "PASSENGER_POOL_SIZE NOT SET.\nConsider setting for improved performance."
else
  re='^[0-9]+$'
  if ! [[ $PASSENGER_POOL_SIZE =~ $re ]] ; then
     echo "error: PASSENGER_POOL_SIZE is not a number" >&2; exit 1
  fi

  if grep -rq "passenger_max_pool_size" /etc/nginx/conf.d/extend-http-nginx.conf; then
    printf "Passenger pool size already found, not making any changes\n"
  else
    echo "passenger_max_pool_size ${PASSENGER_POOL_SIZE};" >> /etc/nginx/conf.d/extend-http-nginx.conf
    echo "passenger_min_instances ${PASSENGER_POOL_SIZE};" >> /etc/nginx/conf.d/extend-http-nginx.conf
  fi
fi