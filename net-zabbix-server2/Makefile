# $NetBSD$

DISTNAME=	zabbix-server-2.2.1
CATEGORIES=	net
MASTER_SITES=	http://netcologne.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.1/

MAINTAINER=	jens@neuhalfen.name
HOMEPAGE=	http://netcologne.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.1/
COMMENT=	Enterprise monitoring
LICENSE=	gnu-gpl-v2

GNU_CONFIGURE=		yes
USE_PKGLOCALEDIR=	yes
USE_LANGUAGES=		c c++
USE_TOOLS+=		makeinfo
# TODO see below USE_TOOLS+=		pax

CONFIGURATION_FILES=	zabbix_server.conf
#CONFIGURATION_FILES+=	zabbix_proxy.conf
#CONFIGURATION_FILES+=	zabbix_agent.conf 
#CONFIGURATION_FILES+=	zabbix_agentd.conf

CONFIGURE_ARGS=		--enable-server --disable-agent --with-mysql --disable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 --with-ssh2=${PREFIX} --with-ldap
CONFIGURE_ARGS+= --sysconfdir=${PKG_SYSCONFDIR}

PKG_SYSCONFSUBDIR=	zabbix
EGDIR=			${PREFIX}/share/examples/${PKGBASE}

CONF_FILES=		${EGDIR}/zabbix_server.conf ${PKG_SYSCONFDIR}/zabbix_server.conf
#CONF_FILES+=		${EGDIR}/zabbix_proxy.conf ${PKG_SYSCONFDIR}/zabbix_trapper.conf
#CONF_FILES+=		${EGDIR}/zabbix_agent.conf ${PKG_SYSCONFDIR}/zabbix_agent.conf
#CONF_FILES+=		${EGDIR}/zabbix_agentd.conf ${PKG_SYSCONFDIR}/zabbix_agentd.conf
INSTALLATION_DIRS+=	${EGDIR}

# ZABBIX user account
ZBXUSER?=		zabbix
ZBXGROUP?=		zabbix
ZBXHOME?=		/home/${ZBXUSER}	# ${PREFIX}/${USER}
FILES_SUBST+=		ZBXUSER=${ZBXUSER}
FILES_SUBST+=		ZBXGROUP=${ZBXGROUP}
FILES_SUBST+=		ZBXHOME=${ZBXHOME}
BUILD_DEFS+=		ZBXHOME

PKG_GROUPS_VARS+=	ZBXGROUP
PKG_USERS_VARS+=	ZBXUSER

PKG_GROUPS=		${ZBXGROUP}
PKG_USERS=		${ZBXUSER}:${ZBXGROUP}
PKG_GECOS.${PGUSER}=	ZABBIX monitoring pseudo-user
PKG_HOME.${PGUSER}=	${ZBXHOME}
PKG_SHELL.${PGUSER}=	${SH}


# Patches
# TODO: Check if the 1.8.5 patches still are the right ones
SUBST_CLASSES+=			fix-paths
SUBST_STAGE.fix-paths=		post-patch
SUBST_MESSAGE.fix-paths=	Fixing absolute pathes.
SUBST_FILES.fix-paths=		src/zabbix_server/server.c src/zabbix_agent/zabbix_agent.c
SUBST_SED.fix-paths=		-e 's,"@PREFIX@,"${PREFIX},g'
SUBST_SED.fix-paths+=		-e 's,"@HOMEDIR@,"${ZBXHOME},g'
SUBST_SED.fix-paths+=		-e 's,"@CONFDIR@,"${PKG_SYSCONFDIR},g'
SUBST_SED.fix-paths+=		-e 's,"@SCRIPTDIR@,"${PREFIX}/libexec/${PKGNAME_NOREV},g'
SUBST_SED.fix-paths+=		-e 's,"@PIDDIR@,"${VARBASE}/run,g'

OWN_DIRS+=	share/zabbix share/zabbix/data share/zabbix/schema share/examples/zabbix share/doc/zabbix

RCD_SCRIPTS=	zabbix_agentd zabbix_server
.for script in ${RCD_SCRIPTS}
RCD_SCRIPT_SRC.${script}=	${WRKSRC}/misc/init.d/freebsd/${script}
.endfor

# necessary SQL scripts
SQL_SCRIPTS_DIR=	${WRKSRC}/create
SQL_SCRIPTS+=	data/data.sql
SQL_SCRIPTS+=	data/images_oracle.sql data/images_pgsql.sql
SQL_SCRIPTS+=	data/images_mysql.sql data/images_sqlite3.sql
SQL_SCRIPTS+=	schema/oracle.sql schema/postgresql.sql
SQL_SCRIPTS+=	schema/mysql.sql schema/sqlite.sql

CHECK_INTERPRETER_SKIP=	share/zabbix/upgrades/dbpatches/1.8/mysql/upgrade
CHECK_WRKREF_SKIP=	share/zabbix/upgrades/Makefile

post-install:
.for d in ${OWN_DIRS}
	mkdir ${DESTDIR}${PREFIX}/$d
.endfor
# documentation
	${INSTALL_DATA} ${WRKSRC}/README ${DESTDIR}${PREFIX}/share/doc/zabbix/
.for f in ${CONFIGURATION_FILES}
	${INSTALL_DATA} ${WRKSRC}/misc/conf/$f ${DESTDIR}${EGDIR}/$f
.endfor
.for f in ${SQL_SCRIPTS}
	${INSTALL_DATA} ${SQL_SCRIPTS_DIR}/$f ${DESTDIR}${PREFIX}/share/zabbix/$f
.endfor
.for f in AUTHORS COPYING INSTALL NEWS README
	${INSTALL_DATA} ${WRKSRC}/$f ${DESTDIR}${PREFIX}/share/doc/zabbix/$f
.endfor
# FIXME: later	cd ${WRKSRC}; pax -rw frontends upgrades ${DESTDIR}${PREFIX}/share/zabbix/

.include "../../databases/mysql56-client/buildlink3.mk"
.include "../../databases/openldap-client/buildlink3.mk"
.include "../../net/net-snmp/buildlink3.mk"
.include "../../security/libssh2/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"

