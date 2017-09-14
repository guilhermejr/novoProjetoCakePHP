#!/bin/sh

# --- Baixa o composer ---
export COMPOSER_HOME="/vagrant"
cd $COMPOSER_HOME
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

# --- Verifica se o download está correto ---
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

# --- Instala o composer ---
php composer-setup.php --quiet
RESULT=$?

# --- Apaga os arquivos ---
rm -rf composer-setup.php
rm -rf keys.dev.pub
rm -rf keys.tags.pub

# --- Retorna ---
exit $RESULT
