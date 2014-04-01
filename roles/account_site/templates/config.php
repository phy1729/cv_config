<?php

$ldap_config = Array(
	'account_suffix' => '@collegiumv.org',
	'base_dn' => 'DC=collegiumv,DC=org',
	'domain_controllers' => array('boron.collegiumv.org'),
	'admin_username' => '{{ account_admin_username | replace("\\", "\\\\") | replace("'", "\'") }}',
	'admin_password' => '{{ account_admin_password | replace("\\", "\\\\") | replace("'", "\'") }}',
	'use_tls' => true
);

$config_salt='{{ account_salt | replace("\\", "\\\\") | replace("'", "\'") }}';

?>
