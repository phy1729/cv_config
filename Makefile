.PHONY: site clean

site:
	cp -rf site tmp
	secret/inject_secrets.sh
	tar czf site54.tgz -Ctmp/ .

clean:
	rm -rf tmp
	rm -f site*.tgz
