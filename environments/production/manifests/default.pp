# --- Variáveis para a criação do banco de dados ---
$host = "localhost"
$user = "usuario"
$pass = "senha"
$db = "bancodedados"
$dbTest = "bancodedadostest"

# --- Mapeia o path dos programas ---
Exec { path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"] }

# Atualiza a lista do apt
exec { "apt-get update":
	command	=> "apt-get update",
}

# --- Instala os serviços e pacotes comum a todos as distribuições ---
package { ["mysql-server", "phpmyadmin", "apache2", "openssl", "vim"]:
	ensure	=> installed,
	require	=> Exec["apt-get update"],
}

# --- Instala os pacotes específicos por distribuição ---
if $dist == "debian8.9" {
	package { ["php5-intl", "php5-sqlite", "unzip"]:
		ensure	=> installed,
		require	=> Package["phpmyadmin"],
	}
} else {
	package { ["php-intl", "php-sqlite3"]:
		ensure	=> installed,
		require	=> Package["phpmyadmin"],
	}
}

# --- Certifica que o mysql está rodando ---
service { "mysql":
	ensure		=> running,
	enable		=> true,
	hasstatus	=> true,
	hasrestart	=> true,
	require		=> Package["mysql-server"],
}

# --- Certifica que o apache2 está rodando ---
service { "apache2":
	ensure		=> running,
	enable		=> true,
	hasstatus	=> true,
	hasrestart	=> true,
	require		=> Package["apache2"],
}

# --- Apaga o arquivo de lock do apache para que seja possível trocar o usuário do apache ---
exec { "apagarLockApache":
	onlyif	=> "grep -c 'www-data' /etc/apache2/envvars",
	command	=> "rm -rf /var/lock/apache2",
	require	=> Package["apache2"],
}

# --- Troca o usuário do apache para evitar erro de permissão ---
exec { "usuarioApache":
	onlyif	=> "grep -c 'www-data' /etc/apache2/envvars",
	command	=> "sed -i 's/www-data/vagrant/' /etc/apache2/envvars",
	require	=> Exec["apagarLockApache"],
	notify	=> Service["apache2"],
}

# --- Apaga os arquivos dentro de /var/www/html ---
exec { "apagarIndex":
	onlyif	=> "cat /var/www/html/empty",
	command	=> "rm -f /var/www/html/*",
	require	=> Package["apache2"],
	notify	=> Service["apache2"],
}

# --- Habilita o mod_rewrite no apache ---
exec { "habilitaModRewrite":
	command	=> "a2enmod rewrite",
	require	=> Package["apache2"],
	notify	=> Service["apache2"],
}

# --- Habilita o ssl no apache ---
exec { "habilitaSSL":
	command	=> "a2enmod ssl",
	require	=> Package["apache2"],
	notify	=> Service["apache2"],
}

# --- Cria a pasta para colocar o certificado ---
exec { "criarPastaCertificado":
	unless	=> "ls /etc/apache2/ssl",
	command	=> "mkdir -p /etc/apache2/ssl",
	require	=> Package["apache2"],
}

# --- Cria o certificado SSL ---
exec { "criarCertificadoSSL":
	unless	=> "cat /etc/apache2/ssl/apache.key",
	command => "openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -subj \"/C=BR/ST=Bahia/L=Salvador/O=GuilhermeJr/CN=guilhermejr\" -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt",
	require => Exec["criarPastaCertificado"],
	notify	=> Service["apache2"],
}

# --- Novas configurações para o apache ---
file { "/etc/apache2/sites-enabled/000-default.conf":
	owner	=> 'root',
	group	=> 'root',
	mode 	=> '0644',
	content	=> template("/vagrant/environments/production/manifests/000-default.conf"),
	require	=> Package["apache2"],
	notify	=> Service["apache2"],
}

# --- Instala o composer ---
if $dist == "debian8.9" {
	exec { "composer":
		creates	=> "/vagrant/composer.phar",
		command => "sh /vagrant/environments/production/manifests/composer.sh",
		require => Package["php5-intl"],
	}
} else {
	exec { "composer":
		creates	=> "/vagrant/composer.phar",
		command => "sh /vagrant/environments/production/manifests/composer.sh",
		require => Package["php-intl"],
	}
}

# --- Instala o cakePHP ---
exec { "cakePHP":
	creates => "/vagrant/app/index.php",
	command => "su vagrant -c \"php /vagrant/composer.phar -n create-project --prefer-dist cakephp/app /vagrant/app\"",
	require => Exec["composer"],
}

# --- Configura acesso a banco de dados no cakePHP ---
exec { "cakePHPDB":
	unless	=> "grep -c '$user' /vagrant/app/config/app.php",
	command => "php /vagrant/environments/production/manifests/configCakePHP.php $host $user $pass $db $dbTest",
	require => Exec["cakePHP"],
	notify	=> Service["apache2"],
}

# --- Instala o jquery e bootstrap ---
exec { "jqueryBootstrap":
	creates	=> "/vagrant/app/webroot/js/jquery.min.js",
	command => "sh /vagrant/environments/production/manifests/complemento.sh",
	require => Exec["cakePHP"],
	notify	=> Service["apache2"],
}

# --- Configura o phpmyadmin ---
exec { "confPhpmyadmin":
	unless	=> "grep -c 'phpmyadmin' /etc/apache2/apache2.conf",
	command	=> "echo \"Include /etc/phpmyadmin/apache.conf\" >> /etc/apache2/apache2.conf",
	require	=> Package["apache2"],
	notify	=> Service["apache2"],
}

# --- Cria o banco de dados ---
exec { "bancodedados":
	unless	=> "mysql -uroot $db",
	command	=> "mysqladmin -uroot create $db",
	require	=> Package["mysql-server"],
}

# --- Cria o usuário para o banco de dados criado no comando anterior ---
exec { "criarUsuarioBancodedados":
	unless	=> "mysql -u$user -p$pass $db",
	command	=> "mysql -uroot -e \"GRANT ALL PRIVILEGES ON $db.* TO '$user'@'%' IDENTIFIED BY '$pass';\"",
	require	=> Exec["bancodedados"],
}

# --- Cria o banco de dados para teste ---
exec { "bancodedadosTeste":
	unless	=> "mysql -uroot $dbTest",
	command	=> "mysqladmin -uroot create $dbTest",
	require	=> Package["mysql-server"],
}

# --- Cria o usuário para o banco de dados criado no comando anterior ---
exec { "criarUsuarioBancodedadosTeste":
	unless	=> "mysql -u$user -p$pass $dbTest",
	command	=> "mysql -uroot -e \"GRANT ALL PRIVILEGES ON $dbTest.* TO '$user'@'%' IDENTIFIED BY '$pass';\"",
	require	=> Exec["bancodedadosTeste"],
}
