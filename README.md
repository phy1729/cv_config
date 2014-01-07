Collegium V Configuration
=========================

Installation
------------
1. Clone this repository. In your home directory `git clone https://github.com/phy1729/cv_config.git`
2. Install ansible
	1. In your home directory `git clone git://github.com/ansible/ansible.git`
	2. If you don't have pip, `sudo easy_install pip`
	3. Install ansible dependencies: `sudo pip install paramiko PyYAML jinja2 httplib2`
3. Install vagrant
	1. Download from http://www.vagrantup.com/downloads.html
	2. Install
4. In the cv_config directory run `make secrets`

Use
---
1. Add ansible to your PATH: `. ~/ansible/hacking/env-setup`
2. Spin up the virtual machines: `vagrant up`
	* Vagrant is setting up 2 virtual machines. This step may take some time.
3. SSH into any virtual machine with `vagrant ssh <machine>` where `<machine>` is any of
	* vm-h
	* vm-he
4. When done with the virtual network, run `vagrant halt`, `vagrant suspend`, or `vagrant destroy` to pause, shutdown, or delete the virtual machines.

Documentation
-------------
* Ansible: http://docs.ansible.com/
* Vagrant: http://docs.vagrantup.com/v2/
