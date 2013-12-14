.PHONY: site clean

site: clean
	cp -Rf site tmp
	cp -Rf roles/openbsd/files/* tmp
	cp -Rf roles/openbsd/templates/* tmp
	secret/inject_secrets.sh
	tar czf site54.tgz -Ctmp/ .

clean:
	rm -rf tmp
	rm -f site*.tgz
