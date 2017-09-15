#!/usr/bin/env bash
################################
#
# precompile.sh compiles rails assets
#
# Property of StepsAway
#
# Version 0.3
#
################################

# get options
while getopts "gr" OPTION; do
  case $OPTION in
    g) GEMSET=1 ;;
    r) RUN=1 ;;
    \?) printf "\nOption -$OPTARG not allowed.\n";;
  esac
done

install_gemset(){
  # ensure proper working directory
  cd /home/app

  # create a temporary gemfile with a nulldb adapter
  cat Gemfile > Gemfile.precompile
  echo "gem 'activerecord-nulldb-adapter', require: false" >> Gemfile.precompile

  # ensure the gem is installed, need to use vendor'ed gems
  BUNDLE_GEMFILE=Gemfile.precompile bundle install --path vendor/bundle --no-deployment --without development test
}

run(){
  # create fake database.yml & secrets.yml file for rake task
  cat > config/database.yml << EOF
production:
  adapter: nulldb
EOF

  cat > config/secrets.yml << EOF
production:
EOF

  # compile and clean
  RAILS_ENV=production BUNDLE_GEMFILE=Gemfile.precompile bundle exec rake assets:precompile
  rm -r Gemfile.precompile* config/database.yml config/secrets.yml

  # redo the bundle install for production
  bundle install --deployment
  bundle clean --force
}

# execute script
if [[ $GEMSET == 1 ]]; then
  install_gemset
fi

if [[ $RUN == 1 ]]; then
  run
fi
