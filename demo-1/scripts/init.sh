#cloud-config

groups:
  - linuxusers: [root,centos,rvadisala]

users:
  - name: rvadisala
    gecos: Ravi Vadisala
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: wheel, centos
    ssh_import_id: None
    lock_passwd: false
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDxx0dVSig9LtiuoL0MP0nT9BK1FfK14NJlkFffOBb1DtrSSD3B6ogPUf38LvuTKOxbdQno1gR+XRGuZwRCkEcqKVjtztI2ByJCLSxmzaOMymB6jp+9WBgs2zQnTONmUF0pTC8qzSH4gAlg7AHK6wZQ8u25sOgY2R6MXlaLyXpo7xUZ0QJOcFnG+992x7L/XRrCxgPbynRGsJt/y2DM7KWlVhNpoDgJc/xkCqYWhAIxunZvUVOlBc8HgLy4eSBnk3K3tv0OGULZzzOnkM0OLQUA6YZWR5XUjINecPlG70mu0uSfj0TlPcVvcca+51IlKdgtIRvOeFncNGUuW7hmM8JARaW3PFzOy+dOhDY9XAu9CQn6sRY+V4VUbIiQzGTho1TCTMM2rUFomYYzxIJzkJYYL3B7bHxmjzd+l13t6uUJtlILOyR4klQGEQj2sQXSOaXrNaY6vnjwNqWEgtegGoxDy6APW+nfl8q/VqtHL3z193xN2m4gaBC78z4IF6qSUtk= rvadisala@HYDLPT968.local

yum_repos:
  epel-testing:
    baseurl: http://download.fedoraproject.org/pub/epel/testing/7/$basearch
    enabled: true
    gpgcheck: false
    name: Extra Packages for Enterprise Linux - Testing

package_upgrade: true

packages:
  - lvm2
  - httpd
  - mod_ssl

runcmd:
 - [ systemctl, start, httpd ]
 - [ systemctl, enable, httpd ]
 - [ yum, "-y", install, "https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm" ]
 - [ yum, "-y", install, puppet ]
 - [ setenforce, 0 ]

final_message: "The system is finally up, after $UPTIME seconds"

output:
  all: '| tee -a /var/log/cloud-init-output.log'
