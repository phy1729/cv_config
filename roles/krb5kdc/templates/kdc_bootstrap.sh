#!/bin/sh
bindPW='{{ slapd_krbAdmService_password | replace("'", "'\"'\"'") }}'
krb_db_enc_pass='{{ krb_db_enc_pass | replace("'", "'\"'\"'") }}'

printf "%s\n%s\n%s\n" "$bindPW" "$bindPW" "$bindPW" | kdb5_ldap_util -D "{{ krbAdmin_bindDN }}" stashsrvpw -f /etc/krb5kdc/ldap.keyfile "{{ krbAdmin_bindDN }}"
printf "%s\n%s\n%s\n" "$bindPW" "$krb_db_enc_pass" "$krb_db_enc_pass" | kdb5_ldap_util -D "{{ krbAdmin_bindDN }}" create -subtrees 'ou=people,dc=collegiumv,dc=org' -s
