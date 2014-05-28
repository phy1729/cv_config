.PHONY: sites site site-hydrogen clean mkdir_secrets secrets monit_passwd status_key

DESTDIR = ${CURDIR}/tmp
H_DESTDIR = ${CURDIR}/tmp-hydrogen
SUDO = sudo
INSTALL = install
OSrev=55

# OpenBSD UID and GID definitions
ROOT_U = 0
WHEEL_G = 0
NAMED_G = 70

# -rw-r--r--
BIN1=	templates/etc/dhcpd.conf \
	templates/etc/ntpd.conf \
	files/etc/pkg.conf \
	templates/etc/rc.conf.local \
	files/etc/rc.local \
	files/etc/rc.securelevel \
	files/etc/resolv.conf.boot \
	files/etc/resolv.conf.final \
	files/etc/sysctl.conf

# -rw-r-----
HOSTNAMES=	templates/etc/hostname.bge0 \
		templates/etc/hostname.bge1 \
		templates/etc/hostname.carp0 \
		templates/etc/hostname.carp1 \
		templates/etc/hostname.carp2 \
		templates/etc/hostname.em0 \
		templates/etc/hostname.pfsync0

# -r-xr-xr-x
RCDAEMONS=	files/etc/rc.d/dhcpd

sites: site site-hydrogen

site:
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}
	# In the OpenBSD Makefile this part is done by mtree but that doesn't exist on linux
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/etc
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/etc/rc.d
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/named
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${NAMED_G} -m 750 ${DESTDIR}/var/named/etc
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/named/master
	${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 550 site/install.site ${DESTDIR}
	cd roles/openbsd; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 ${BIN1} ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 640 ${HOSTNAMES} ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 640 templates/etc/mygate ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 600 templates/etc/pf.conf ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 600 files/etc/pf.games ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 555 ${RCDAEMONS} ${DESTDIR}/etc/rc.d; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${NAMED_G} -m 640 files/var/named/etc/UTDNS ${DESTDIR}/var/named/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${NAMED_G} -m 640 templates/var/named/etc/named.conf ${DESTDIR}/var/named/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/named/master/db.0 ${DESTDIR}/var/named/master; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/named/master/db.255 ${DESTDIR}/var/named/master
	${SUDO} tar czf site${OSrev}.tgz -C${DESTDIR} .

site-hydrogen:
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${H_DESTDIR}
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${H_DESTDIR}/etc/rc.d
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${H_DESTDIR}/var/named/master
	${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 550 site-hydrogen/install.site-hydrogen ${H_DESTDIR}
	cd roles/openbsd-hydrogen; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 templates/etc/pfstat.conf ${H_DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 555 files/etc/rc.d/update_pfstat ${H_DESTDIR}/etc/rc.d; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/etc/update_pfstat_batch ${H_DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/named/master/collegiumv.org ${H_DESTDIR}/var/named/master; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/named/master/db.192.168.42 ${H_DESTDIR}/var/named/master; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/named/master/sunray-servers ${H_DESTDIR}/var/named/master
	${SUDO} tar czf site${OSrev}-hydrogen.tgz -C${H_DESTDIR} .

clean:
	${SUDO} rm -rf ${DESTDIR} ${H_DESTDIR}
	${SUDO} rm -f site*.tgz

secrets: mkdir_secrets monit_passwd status_key

mkdir_secret:
	mkdir -m 0700 secret

monit_passwd:
	export LC_CTYPE=C; tr -dc '!-~' < /dev/urandom | fold -w 32 | head -n 1 > secret/monit_passwd

status_key:
	ssh-keygen -t rsa -b 4096 -f secret/status_id_rsa
