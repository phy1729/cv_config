# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.synced_folder ".", "/vagrant", disabled: true

	config.vm.define "vm-h" do |hydrogen|
		hydrogen.vm.box = "openbsd_5.3"
		hydrogen.vm.box_url = "https://dl.dropboxusercontent.com/u/12089300/VirtualBox/openbsd53_amd64.box"
		# The below IPs for cv_int and cv_pf are wrong. Vagrant doesn't allow .1 IPs but ansible will configure over this.
		hydrogen.vm.network :private_network, ip: "192.168.42.100", virtualbox__intnet: "cv_int"
		hydrogen.vm.network :private_network, ip: "10.0.0.101"
		hydrogen.vm.network :private_network, ip: "172.16.0.100", virtualbox__intnet: "cv_pf"
	end

	config.vm.define "vm-he" do |helium|
		helium.vm.box = "openbsd_5.3"
		helium.vm.box_url = "https://dl.dropboxusercontent.com/u/12089300/VirtualBox/openbsd53_amd64.box"
		helium.vm.network :private_network, ip: "192.168.42.2", virtualbox__intnet: "cv_int"
		helium.vm.network :private_network, ip: "10.0.0.102"
		helium.vm.network :private_network, ip: "172.16.0.2", virtualbox__intnet: "cv_pf"
	end

	config.vm.provision "ansible" do |ansible|
		ansible.playbook = "site.yml"
		ansible.host_key_checking = false

		ansible.groups = { "vm:children" => ["gateway", "ssh", "utility", "audio"], "gateway" => ["vm-h", "vm-he"], "ssh" => ["vm-c"], "utility" => ["vm-n"], "audio" => ["vm-f"] }
	end
end
