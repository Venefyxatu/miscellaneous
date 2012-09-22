#!/bin/bash

apt-get install git
apt-get install puppet-common

git clone https://github.com/puppetlabs/puppetlabs-vcsrepo.git /etc/puppet/modules
git clone https://github.com/rcrowley/puppet-pip.git /etc/puppet/modules

puppet module install puppetlabs-stdlib
puppet module install akumria-postgresql
