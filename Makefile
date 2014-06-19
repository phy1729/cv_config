.PHONY: site clean mkdir_secrets secrets account_admin_password account_salt monit_passwd

DESTDIR = ${CURDIR}/tmp
SUDO = sudo
INSTALL = install
OSrev=55

# OpenBSD UID and GID definitions
ROOT_U = 0
WHEEL_G = 0
NSD_G = 97

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

site:
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}
	# In the OpenBSD Makefile this part is done by mtree but that doesn't exist on linux
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/etc
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/etc/rc.d
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/nsd
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${NSD_G} -m 750 ${DESTDIR}/var/nsd/etc
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/nsd/zones
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/unbound
	${SUDO} ${INSTALL} -d -o ${ROOT_U} -g ${WHEEL_G} -m 755 ${DESTDIR}/var/unbound/etc
	${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 550 site/install.site ${DESTDIR}
	cd roles/openbsd; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 ${BIN1} ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 640 ${HOSTNAMES} ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 640 templates/etc/mygate ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 600 templates/etc/pf.conf ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 600 files/etc/pf.games ${DESTDIR}/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 555 ${RCDAEMONS} ${DESTDIR}/etc/rc.d; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${NSD_G} -m 640 templates/var/nsd/etc/nsd.conf ${DESTDIR}/var/nsd/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/nsd/zones/collegiumv.org ${DESTDIR}/var/nsd/zones; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/nsd/zones/42.168.192.in-addr.arpa ${DESTDIR}/var/nsd/zones; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/nsd/zones/sunray-servers ${DESTDIR}/var/nsd/zones; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 templates/var/unbound/etc/unbound.conf ${DESTDIR}/var/unbound/etc; \
		${SUDO} ${INSTALL} -c -o ${ROOT_U} -g ${WHEEL_G} -m 644 files/var/unbound/etc/root.hint ${DESTDIR}/var/unbound/etc;
	${SUDO} tar czf site${OSrev}.tgz -C${DESTDIR} .

clean:
	${SUDO} rm -rf ${DESTDIR}
	${SUDO} rm -f site*.tgz

secrets: mkdir_secrets account_admin_password account_salt monit_passwd

mkdir_secret:
	mkdir -m 0700 secret

account_admin_password account_salt monit_passwd:
	export LC_CTYPE=C; tr -dc '!-~' < /dev/urandom | fold -w 32 | head -n 1 > secret/$@
