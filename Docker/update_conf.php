<?php
// change these as needed
define('SECRETS_FN', '/tmp/secrets.sh');
define('SRC_CONF_FN', '/tmp/drupal.conf');
define('DEST_CONF_FN', '/tmp/drupal.conf.new');
echo "Usage: update_conf.php [SECRETS_FN] [SRC_CONF_FN] [DEST_CONF_FN]\n";
echo "\tSECRETS_FN default: " . SECRETS_FN . "\n";
echo "\SRC_CONF_FN default: " . SRC_CONF_FN . "\n";
echo "\DEST_CONF_FN default: " . DEST_CONF_FN . "\n";
// read secrets
$secrets_fn = $argv[1] ?? SECRETS_FN;
$src_fn     = $argv[2] ?? SRC_CONF_FN;
$dest_fn    = $argv[3] ?? DEST_CONF_FN;
$tmp        = file($secrets_fn);
$secrets    = [];
foreach ($tmp as $line) {
	if (strpos($line, 'export') === 0) {
		[$key, $val] = explode('=', substr($line, strpos($line, ' ') + 1));
		$secrets['%' . trim($key) . '%'] = trim($val);
	}
}
$conf = file_get_contents($src_fn);
$conf = str_replace(
	array_keys($secrets),
	array_values($secrets),
	$conf
);
echo $conf . PHP_EOL;
file_put_contents($dest_fn, $conf);
