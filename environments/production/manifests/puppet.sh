#!/bin/sh
set -e -x

# --- Verifica se o puppet já está instalado ---
if which puppet > /dev/null ; then
	echo "Puppet já instalado."
	exit 0
fi

# --- Baixa o arquivo de instalação do repositório ---
export DEBIAN_FRONTEND=noninteractive
case $1 in
	ubuntu16.04) wget -qO /tmp/puppetlabs-release.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb ;;
	debian9.1) wget -qO /tmp/puppetlabs-release.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-stretch.deb ;;
	debian9.2) wget -qO /tmp/puppetlabs-release.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-stretch.deb ;;
	debian8.9) wget -qO /tmp/puppetlabs-release.deb https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb ;;
	*) echo "Identificação de distribuição inválida: $1"; exit 1;;
esac

# --- Instala o repositório do puppet ---
dpkg -i /tmp/puppetlabs-release.deb

# --- Apaga o arquivo de instalação do repositório ---
rm -rf /tmp/puppetlabs-release.deb

# --- Atualiza o apt-get ---
apt-get update --quiet

# --- Instala o puppet ---
apt-get install -qy puppet
echo "Puppet instalado!"
