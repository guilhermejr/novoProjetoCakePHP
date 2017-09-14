O objetivo deste Vagrantfile é instalar uma VM com a última versão do CakePHP
configurada e pronta para uso. Junto com o CakePHP são configurados o jQuery e o
Bootstrap.

É preciso editar as variáveis que estão no início dos arquivos Vagrantfile e
default.pp com os valores do seu projeto.

Serão instalados o Apache, PHP, MySQL, phpMyAdmin, OpenSSL e tudo será
configurado automaticamente, para isso basta instalar as dependêcias listadas
abaixo, clonar este repositório e rodar o comando:

    $ vagrant up

Dependência
-----------

    * VirtualBox - https://www.virtualbox.org
    * Vagrant - https://www.vagrantup.com

Distribuições suportadas
------------------------

    * Debian 8.9
    * Debian 9.1
    * Ubuntu 16.04

Versões
-------

    * jQuery 3.2.1
    * Bootstrap 3.3.7

Contato
-------

Dúvidas e Sugestões favor mandar um e-mail falecom@guilhermejr.net
