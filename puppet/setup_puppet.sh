#!/bin/bash

cat << _EOF_ > /etc/apt/sources.list.d/puppetlabs.list 
deb http://apt.puppetlabs.com precise main 
deb-src http://apt.puppetlabs.com precise main
_EOF_

apt-get update

#@TODO why is the force-yes necessary and how to get rid of it?
apt-get install --force-yes -y puppet-common

git clone https://github.com/puppetlabs/puppetlabs-vcsrepo.git /etc/puppet/modules/puppetlabs-vcsrepo
git clone https://github.com/rcrowley/puppet-pip.git /etc/puppet/modules/puppet-pip.git

puppet module install puppetlabs-stdlib
puppet module install akumria-postgresql

cp -r manifests/openerp /etc/puppet/manifests/
cp manifests/site.pp /etc/puppet/manifests

cd /etc/puppet/modules/puppetlabs-vcsrepo/
patch -p1 < /home/ubuntu/miscellaneous/vcsrepo/git.patch
