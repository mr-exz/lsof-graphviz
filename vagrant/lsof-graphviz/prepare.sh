#!/usr/bin/env bash

hostname lsof-graphviz
echo "lsof-graphviz" > /etc/hostname

yum -y install lsof graphviz*

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm requirements run
rvm install 2.4.0
rvm use 2.4.0 --default
ruby -v

gem update --system
gem install json
gem install graphviz
gem install ruby-graphviz
gem install fosl
