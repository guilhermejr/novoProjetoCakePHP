<?php

// --- REGEX para alteração do arquivo ---
const DATASOURCE_REGEX = "/(\'Datasources'\s\=\>\s\[\n\s*\'default\'\s\=\>\s\[\n\X*\'__FIELD__\'\s\=\>\s\').*(\'\,)(?=\X*\'test\'\s\=\>\s)/";
const DATASOURCE_REGEX_TEST = "/(\'Datasources'\s\=\>\s\[\n\s*\'default\'\s\=\>\s\[\n\X*\'__FIELD__\'\s\=\>\s\').*(\'\,)(?=\X*\'url\'\s\=\>\s)/";

// --- Arquivo de configuração do cakePHP ---
$arquivo = '/var/www/html/config/app.php';

// --- Abre o arquivo para edição ---
$config = file_get_contents($arquivo);

// --- Faz as alterações no arquivo ---
$config = preg_replace(str_replace('__FIELD__', 'host', DATASOURCE_REGEX), '${1}' . $_SERVER['argv'][1] . '${2}', $config);
$config = preg_replace(str_replace('__FIELD__', 'username', DATASOURCE_REGEX), '${1}' . $_SERVER['argv'][2] . '${2}', $config);
$config = preg_replace(str_replace('__FIELD__', 'password', DATASOURCE_REGEX), '${1}' . $_SERVER['argv'][3] . '${2}', $config);
$config = preg_replace(str_replace('__FIELD__', 'database', DATASOURCE_REGEX), '${1}' . $_SERVER['argv'][4] . '${2}', $config);
$config = preg_replace(str_replace('__FIELD__', 'host', DATASOURCE_REGEX_TEST), '${1}' . $_SERVER['argv'][1] . '${2}', $config);
$config = preg_replace(str_replace('__FIELD__', 'username', DATASOURCE_REGEX_TEST), '${1}' . $_SERVER['argv'][2] . '${2}', $config);
$config = preg_replace(str_replace('__FIELD__', 'password', DATASOURCE_REGEX_TEST), '${1}' . $_SERVER['argv'][3] . '${2}', $config);
$config = preg_replace(str_replace('__FIELD__', 'database', DATASOURCE_REGEX_TEST), '${1}' . $_SERVER['argv'][5] . '${2}', $config);

// --- Salva as alterações no arquivo ---
file_put_contents($arquivo, $config);

?>
