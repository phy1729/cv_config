#!/bin/sh
bindPW='{{ slapd_krbAdmService_password | replace("'", "'\"'\"'") }}'
krb_db_enc_pass='{{ krb_db_enc_pass | replace("'", "'\"'\"'") }}'

printf "%s\n%s\n%s\n" "$bindPW" "$krb_db_enc_pass" "$krb_db_enc_pass" | kdb5_ldap_util -D "{{ krbAdmin_bindDN }}" -H ldap://localhost/ create -subtrees 'ou=people,dc=collegiumv,dc=org' -s -containerref 'cn=krbContainer,dc=collegiumv,dc=org'
