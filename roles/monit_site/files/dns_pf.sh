#!/bin/bash

names=(ftp.us.debian.org ftp.utexas.edu madhax.net mirror.esc7.net navobs1.wustl.edu ntp.okstate.edu omgpwned.net security.debian.org smtp.utdallas.edu tick.uh.edu timelord.utdallas.edu)
correct=(
'64.50.233.100
64.50.236.52
128.61.240.89'
'marmot.tn.utexas.edu.
146.6.54.21'
'209.236.123.144'
'72.53.191.10'
'128.252.19.1'
'139.78.135.14'
'76.185.189.253'
'128.101.240.212
128.31.0.36
128.61.240.73
149.20.20.6'
'10.180.15.187
10.180.15.188
10.182.70.205
10.182.70.208'
'129.7.1.66'
'10.110.10.11'
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

echo $failed
exit $error
