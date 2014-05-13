# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "debian_7.2"
	config.vm.box_url = "https://dl.dropboxusercontent.com/u/197673519/debian-7.2.0.box"
	config.vm.synced_folder ".", "/vagrant", disabled: true

	config.vm.define "vm-h" do |hydrogen|
		hydrogen.vm.box = "openbsd_5.3"
		hydrogen.vm.box_url = "https://dl.dropboxusercontent.com/u/12089300/VirtualBox/openbsd53_amd64.box"
		# The below IPs for cv_int and cv_pf are wrong. Vagrant doesn't allow .1 IPs but ansible will configure over this.
		hydrogen.vm.network :private_network, ip: "192.168.42.100", virtualbox__intnet: "cv_int"
		hydrogen.vm.network :private_network, ip: "10.0.0.101"
		hydrogen.vm.network :private_network, ip: "172.16.0.100", virtualbox__intnet: "cv_pf"

		hydrogen.vm.provider "virtualbox" do |v|
			v.customize ["natnetwork", "add", "--netname", "cv_ext", "--network", "10.0.0.0/24"]
			v.customize ["modifyvm", :id, "--nic3", "natnetwork"]
			v.customize ["modifyvm", :id, "--nat-network3", "cv_ext"]
			v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
			v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
		end
	end

	config.vm.define "vm-he" do |helium|
		helium.vm.box = "openbsd_5.3"
		helium.vm.box_url = "https://dl.dropboxusercontent.com/u/12089300/VirtualBox/openbsd53_amd64.box"
		helium.vm.network :private_network, ip: "192.168.42.2", virtualbox__intnet: "cv_int"
		helium.vm.network :private_network, ip: "10.0.0.102"
		helium.vm.network :private_network, ip: "172.16.0.2", virtualbox__intnet: "cv_pf"

		helium.vm.provider "virtualbox" do |v|
			v.customize ["modifyvm", :id, "--nic3", "natnetwork"]
			v.customize ["modifyvm", :id, "--nat-network3", "cv_ext"]
			v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
			v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
		end
	end

	config.vm.define "vm-c" do |carbon|
		carbon.vm.network :private_network, ip: "192.168.42.6", virtualbox__intnet: "cv_int"
	end

	config.vm.define "vm-n" do |nitrogen|
		nitrogen.vm.network :private_network, ip: "192.168.42.7", virtualbox__intnet: "cv_int"
	end

	config.vm.define "vm-o" do |oxygen|
		oxygen.vm.network :private_network, ip: "192.168.42.8", virtualbox__intnet: "cv_int"
	end

	config.vm.define "vm-f" do |fluorine|
		fluorine.vm.network :private_network, ip: "192.168.42.9", virtualbox__intnet: "cv_int"
	end

	config.vm.define "vm-ne" do |neon|
		neon.vm.network :private_network, ip: "192.168.42.10", virtualbox__intnet: "cv_int"
	end

	config.vm.provision "ansible" do |ansible|
		ansible.playbook = "site.yml"
		ansible.host_key_checking = false

		ansible.groups = { "vm:children" => ["gateway", "ssh", "utility", "minecraft", "audio", "tv"], "gateway" => ["vm-h", "vm-he"], "ssh" => ["vm-c"], "utility" => ["vm-n"], "minecraft" => ["vm-o"], "audio" => ["vm-f"], "tv" => ["vm-ne"] }
	end
end
