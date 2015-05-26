#!/bin/bash

names=(extras.ubuntu.com madhax.net mirror.esc7.net navobs1.wustl.edu ntp.okstate.edu omgpwned.net security.ubuntu.com smtp.utdallas.edu tick.uh.edu us.archive.ubuntu.com)
correct=(
# extras.ubuntu.com
'91.189.92.152'
# madhax.net
'209.236.123.144'
# mirror.esc7.net
'72.53.191.10'
# navobs1.wustl.edu
'128.252.19.1'
# ntp.okstate.edu
'139.78.135.14'
# omgpwned.net
'76.185.189.253'
# security.ubuntu.com
'91.189.88.149
91.189.91.13
91.189.91.14
91.189.91.15
91.189.91.23
91.189.91.24
91.189.92.200
91.189.92.201'
# smtp.utdallas.edu
'10.180.15.187
10.180.15.188
10.182.70.205
10.182.70.208'
# tick.uh.edu
'129.7.1.66'
# us.archive.ubuntu.com
'91.189.91.13
91.189.91.14
91.189.91.15
91.189.91.23
91.189.91.24'
)
error=0
failed=''

for (( i=0; i<${#names[@]}; i++ )); do
	result="$(dig +short ${names[$i]} | sort -n)"
	if [ "$result" != "${correct[$i]}" ]; then
		error=1;
		failed=$failed" ${names[$i]} "
	fi
done

echo $failed >&2
exit $error
