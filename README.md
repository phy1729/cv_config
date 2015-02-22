Collegium V Configuration
=========================

Installation
------------
1. Clone this repository. In your home directory `git clone https://github.com/phy1729/cv_config.git`
2. Install ansible
	1. If you don't have pip, `sudo easy_install pip`
	2. Install ansible: `sudo pip install ansible`
3. Install vagrant from http://www.vagrantup.com/downloads.html
4. In the cv_config directory run `make secrets`

Use
---
1. Spin up the virtual machines: `vagrant up`
	* Vagrant is setting up 6 virtual machines. This step may take some time.
2. SSH into any virtual machine with `vagrant ssh <machine>` where `<machine>` is any of
	* vm-h
	* vm-he
	* vm-c
	* vm-n
	* vm-o
	* vm-f
3. When done with the virtual network, run `vagrant halt`, `vagrant suspend`, or `vagrant destroy` to pause, shutdown, or delete the virtual machines.

Documentation
-------------
* Ansible: http://docs.ansible.com/
* Vagrant: http://docs.vagrantup.com/v2/
