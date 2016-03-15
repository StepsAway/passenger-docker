#!/bin/bash
set -o pipefail

function ok()
{
	echo "  OK"
}

function fail()
{
	echo "  FAIL"
	exit 1
}

echo "Checking whether all services are running..."
services=`sv status /etc/service/*`
status=$?
if [[ "$status" != 0 || "$services" = "" || "$services" =~ down ]]; then
	fail
else
	ok
fi

echo "Checking Ruby is installed and has the proper version..."
ruby=$(ruby -v | awk '{ print $2 }' | cut -d 'p' -f 1)

if [[ $ruby == $1 ]]; then
	ok
else
	echo "Wrong version of ruby installed!"
	fail
fi

echo "Validating passenger install..."
passenger-config validate-install --auto
status=$?
if [[ "$status" != 0 ]]; then
	"Passenger validation failed"
	fail
else
	ok
fi
