#!/bin/bash

# --- Baixa o jquey e o bootstrap ---
su vagrant -c "wget https://github.com/jquery/jquery/archive/3.3.1.zip -O /vagrant/jquery.zip"
su vagrant -c "wget https://github.com/twbs/bootstrap/releases/download/v3.3.7/bootstrap-3.3.7-dist.zip -O /vagrant/bootstrap.zip"

# --- Descompacta arquivos ---
su vagrant -c "unzip /vagrant/jquery.zip -d /vagrant"
su vagrant -c "unzip /vagrant/bootstrap.zip -d /vagrant"

# --- Copia para as pastas destino ---
cp -p /vagrant/jquery-3.3.1/dist/jquery.min.js /vagrant/app/webroot/js/
cp -p /vagrant/bootstrap-3.3.7-dist/js/bootstrap.min.js /vagrant/app/webroot/js/
cp -p /vagrant/bootstrap-3.3.7-dist/js/npm.js /vagrant/app/webroot/js/
cp -p /vagrant/bootstrap-3.3.7-dist/fonts/* /vagrant/app/webroot/font/
cp -p /vagrant/bootstrap-3.3.7-dist/css/bootstrap-theme.min.css /vagrant/app/webroot/css/
cp -p /vagrant/bootstrap-3.3.7-dist/css/bootstrap-theme.min.css.map /vagrant/app/webroot/css/
cp -p /vagrant/bootstrap-3.3.7-dist/css/bootstrap.min.css /vagrant/app/webroot/css/
cp -p /vagrant/bootstrap-3.3.7-dist/css/bootstrap.min.css.map /vagrant/app/webroot/css/

# --- Apaga os arquivos baixados e as pastas em que foram descompactados ---
rm -rf /vagrant/jquery.zip
rm -rf /vagrant/bootstrap.zip
rm -rf /vagrant/jquery-3.3.1
rm -rf /vagrant/bootstrap-3.3.7-dist

# --- Mensagem ---
echo "jquery e bootstrap instalados"
