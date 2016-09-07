#!/bin/bash
set -e
source /pd_build/buildconfig
set -x

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
if [[ "$final" = 1 ]]; then
	rm -rf /pd_build
else
	rm -f /pd_build/{install,enable_repos,prepare,pups,nginx-passenger,finalize}.sh
	rm -f /pd_build/{Dockerfile,insecure_key*}
fi

# Set ruby to the proper versions
rm /usr/bin/ruby
if [[ "$jruby" = 0 ]]; then
	ln -s /usr/local/bin/ruby /usr/bin/ruby
elif [[ "$jruby" = 1 ]]; then
	ln -s /usr/local/jruby/bin/jruby /usr/bin/ruby
fi
