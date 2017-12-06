# --- Distribuição escolhida: debian8.9; debian9.1; debian9.2 ou ubuntu16.04 ---
DIST = "debian9.2"

# --- IP da VM ---
IP = "192.168.33.10"

Vagrant.configure(2) do |config|

    # --- Identificação da box a ser utilizada ---
    if DIST == "debian9.1"
        config.vm.box = "42tec/debian9.1"
        config.vm.box_url = "http://vagrant.42tec.com.br/debian9.1.box"
    elsif DIST == "debian9.2"
        config.vm.box = "42tec/debian9.2"
        config.vm.box_url = "http://vagrant.42tec.com.br/debian9.2.box"
    elsif DIST == "debian8.9"
        config.vm.box = "42tec/debian8.9"
        config.vm.box_url = "http://vagrant.42tec.com.br/debian8.9.box"
    elsif DIST == "ubuntu16.04"
        config.vm.box = "42tec/ubuntu16.04"
        config.vm.box_url = "http://vagrant.42tec.com.br/ubuntu16.04.box"
    else
        puts "Identificação de distribuição inválida: " + DIST
        exit
    end

    # --- IP que será usado pela máquina Guest ---
    config.vm.network "private_network", ip: IP

    # --- Redirecionamento das portas entre a máquina Guest e Host ---
    config.vm.network "forwarded_port", guest: 80, host: 9980
    config.vm.network "forwarded_port", guest: 443, host: 9443

    # --- Pasta compartilhada entre a máquina Guest e Host ---
    config.vm.synced_folder "app", "/var/www/html", type: "nfs", id: "www"
    config.vm.synced_folder ".", "/vagrant", type: "nfs", id: "manifesto"

    # --- Mensagem a ser mostrada quando a máquina Guest termina de iniciar ---
    config.vm.post_up_message = "Sistema UP. IP: " + IP

    # --- Configuração para instalar o puppet ---
    config.vm.provision "shell" do |s|

        # --- Script a ser executado ---
        s.path = "environments/production/manifests/puppet.sh"

        # --- Parâmetro do script ---
        s.args = DIST

    end

    # --- Configuração do Puppet ---
    config.vm.provision "puppet" do |puppet|

        puppet.environment = "production"
        puppet.environment_path  = "environments"

        # --- Passa para o arquivo de manifesto a distribuição a ser usada ---
        puppet.facter = {
            "dist" => DIST
        }

    end

end
