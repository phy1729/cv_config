#!/bin/sh

result1=$(dig +short @192.168.42.1 _ldap._tcp.dc._msdcs.ad.collegiumv.org srv | sort)
result2=$(dig +short @192.168.42.2 _ldap._tcp.dc._msdcs.ad.collegiumv.org srv | sort)

correct='0 100 389 beryllium.ad.collegiumv.org.
0 100 389 boron.ad.collegiumv.org.'

if [ "$result1" = "$correct" ] && [ "$result2" = "$correct" ]; then
	exit 0
elif [ "$result1" = "$correct" ] || [ "$result2" = "$correct" ]; then 
	if [ "$result1" != "$correct" ]; then
		echo "Hydrogen is not returing the correct results.\n$result1" >&2
	elif [ "$result2" != "$correct" ]; then
		echo "Helium is not returing the correct results.\n$result2" >&2
	fi
	exit 1
else
	echo "Both servers are not returning the correct results.\n$result1\n$result2" >&2
	exit 2
fi
