.PHONY: sites site site-hydrogen site-helium clean secrets

sites: site site-hydrogen

site site-hydrogen site-helium:
	cp -Rf $@ tmp$(subst site,,$@)
	cp -Rf roles/openbsd$(subst site,,$@)/files/* tmp$(subst site,,$@)
	-[ "$@" = 'site' ] && cp -Rf roles/openbsd/templates/* tmp
	tar czf site54$(subst site,,$@).tgz -Ctmp$(subst site,,$@)/ .

clean:
	rm -rf tmp*
	rm -f site*.tgz

secrets:

status_key:
	ssh-keygen -t rsa -b 4096 -f secret/status_id_rsa
