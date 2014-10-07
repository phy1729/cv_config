#!/bin/bash

names=(h he li be b c n o f ne na mg al si p)
correct=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
nameservers='192.168.42.1 192.168.42.2'

error=0
failed=''

for (( i=0; i<${#names[@]}; i++ )); do 
	for ns in $nameservers; do
		result=$(dig +short @${ns} ${names[$i]}.collegiumv.org | tail -n 1)
		if [ "$result" != "192.168.42.${correct[$i]}" ]; then
			error=2;
			failed=$failed"${names[$i]} "
		fi
	done
done

echo $failed >&2
exit $error
