#!/bin/bash

names=(h he li be b c n o f ne na mg al si p)
correct=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
nameservers='192.168.42.1 192.168.42.2'

error=0
failed=''

for ns in $nameservers; do
	for (( i=0; i<${#names[@]}; i++ )); do
		result=$(dig +short @${ns} ${names[$i]}.collegiumv.org | tail -n 1)
		if [ "$result" != "192.168.42.${correct[$i]}" ]; then
			error=1;
			failed=$failed"${names[$i]} "
		fi
	done
	if [ "$(dig +short @${ns} SOA collegiumv.org)" != "hydrogen.collegiumv.org. cvadmins.utdallas.edu. 2015013101 3600 180 1209600 3600" ]; then
		((error = error+2))
		failed=$failed" SOA"
	fi
	if [ "$(dig +short @${ns} NS collegiumv.org)" != $'hydrogen.collegiumv.org.\nhelium.collegiumv.org.' ]; then
		((error = error+4))
		failed=$failed" NS"
	fi
done

echo $failed >&2
exit $error
