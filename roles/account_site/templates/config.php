<?php
$ldap_admin_username = '{{ account_admin_username | replace("\\", "\\\\") | replace("'", "\'") }}';
$ldap_admin_password = '{{ account_admin_password | replace("\\", "\\\\") | replace("'", "\'") }}';
$base_dn = 'OU=Lounge Users, DC=collegiumv, DC=org';
$config_salt = '{{ account_salt | replace("\\", "\\\\") | replace("'", "\'") }}';
?>
