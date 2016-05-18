#!/bin/bash
set -e
source /pd_build/buildconfig
set -x

/pd_build/enable_repos.sh
/pd_build/prepare.sh
/pd_build/nginx-passenger.sh
/pd_build/finalize.sh
