#!/bin/sh
krb_db_enc_pass='{{ krb_db_enc_pass | replace("'", "'\"'\"'") }}'

printf "%s\n" "$krb_db_enc_pass" | kdb5_util stash
