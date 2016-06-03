#!/bin/sh
bindPW='{{ slapd_krbAdmService_password | replace("'", "'\"'\"'") }}'

printf "%s\n%s\n%s\n" "$bindPW" "$bindPW" "$bindPW" | kdb5_ldap_util -D "{{ krbAdmin_bindDN }}" stashsrvpw -f /var/krb5kdc/ldap.keyfile "{{ krbAdmin_bindDN }}"
