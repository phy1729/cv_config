#!/bin/sh
kdcAdmin_pass='{{ kdcAdmin_pass | replace("'", "'\"'\"'") }}'
printf "%s\n%s\n" "$kdcAdmin_pass" "$kdcAdmin_pass" | kadmin.local -q "addprinc {{ kdcAdmin_user }}/admin"
