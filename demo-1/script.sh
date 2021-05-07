#!/bin/bash
#yum install epel-release -y
#yum install httpd -y

#systemctl enable --now httpd
#systemctl start httpd

mkdir -p /var/www/html/
echo "This is a Sample Web Page to Test the Apache Web Server" >> /var/www/html/index.html


# Creating user account
useradd -c "DevOps users" -G wheel aashritha
echo redhat | passwd --stdin aashritha

mkdir /home/aashritha/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDxx0dVSig9LtiuoL0MP0nT9BK1FfK14NJlkFffOBb1DtrSSD3B6ogPUf38LvuTKOxbdQno1gR+XRGuZwRCkEcqKVjtztI2ByJCLSxmzaOMymB6jp+9WBgs2zQnTONmUF0pTC8qzSH4gAlg7AHK6wZQ8u25sOgY2R6MXlaLyXpo7xUZ0QJOcFnG+992x7L/XRrCxgPbynRGsJt/y2DM7KWlVhNpoDgJc/xkCqYWhAIxunZvUVOlBc8HgLy4eSBnk3K3tv0OGULZzzOnkM0OLQUA6YZWR5XUjINecPlG70mu0uSfj0TlPcVvcca+51IlKdgtIRvOeFncNGUuW7hmM8JARaW3PFzOy+dOhDY9XAu9CQn6sRY+V4VUbIiQzGTho1TCTMM2rUFomYYzxIJzkJYYL3B7bHxmjzd+l13t6uUJtlILOyR4klQGEQj2sQXSOaXrNaY6vnjwNqWEgtegGoxDy6APW+nfl8q/VqtHL3z193xN2m4gaBC78z4IF6qSUtk= rvadisala@HYDLPT968.local" > /home/aashritha/.ssh/authorized_keys
chown -R aashritha:aashritha /home/aashritha/.ssh

echo "aashritha ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/aashritha
