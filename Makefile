.PHONY: sites site site-hydrogen site-helium clean

sites: site site-hydrogen

site site-hydrogen site-helium:
	cp -Rf $@ tmp$(subst site,,$@)
	cp -Rf roles/openbsd$(subst site,,$@)/files/* tmp$(subst site,,$@)
	-[ "$@" = 'site' ] && cp -Rf roles/openbsd/templates/* tmp
	secret/inject_secrets$(subst site,,$@).sh
	tar czf site54$(subst site,,$@).tgz -Ctmp$(subst site,,$@)/ .

clean:
	rm -rf tmp*
	rm -f site*.tgz
