#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install https://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm
sleep 15
sudo yum -y install puppet-agent
sleep 10
sudo /opt/puppetlabs/bin/puppet module install puppet-nginx
sudo mkdir -p /var/www/html
cat >/tmp/nginx.pp << "EOF"
class{'nginx': }
EOF
sudo /opt/puppetlabs/bin/puppet apply /tmp/nginx.pp