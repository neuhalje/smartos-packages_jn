# $NetBSD$

DISTNAME=	zabbix-2.2.1
CATEGORIES=	net
MASTER_SITES=	http://netcologne.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.1/

MAINTAINER=	jens@neuhalfen.name
HOMEPAGE=	http://www.zabbix.com/
COMMENT=	Enterprise monitoring
LICENSE=	gnu-gpl-v2

GNU_CONFIGURE=		yes
USE_PKGLOCALEDIR=	yes
USE_LANGUAGES=		c c++
USE_TOOLS+=		makeinfo
USE_TOOLS+=		pax

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

# Startup
RCD_SCRIPTS=		zabbix
SMF_NAME=		zabbix-server
SMF_METHODS=		${RCD_SCRIPTS}

# ZABBIX user account
ZBXUSER?=		zabbix
ZBXGROUP?=		zabbix
ZBXWORKINGDIRECTORY?=	/tmp

FILES_SUBST+=		ZBXUSER=${ZBXUSER}
FILES_SUBST+=		ZBXGROUP=${ZBXGROUP}
FILES_SUBST+=		ZBXWORKINGDIRECTORY=${ZBXWORKINGDIRECTORY}
BUILD_DEFS+=		ZBXWORKINGDIRECTORY

PKG_GROUPS_VARS+=	ZBXGROUP
PKG_USERS_VARS+=	ZBXUSER

PKG_GROUPS=		${ZBXGROUP}
PKG_USERS=		${ZBXUSER}:${ZBXGROUP}
PKG_GECOS.${PGUSER}=	ZABBIX monitoring server pseudo-user
PKG_SHELL.${PGUSER}=	${SH}


# Patches
BUILD_DEFS+=		VARBASE
SUBST_CLASSES+=			fix-paths
SUBST_STAGE.fix-paths=		post-patch
SUBST_MESSAGE.fix-paths=	Fixing absolute pathes.
SUBST_FILES.fix-paths=		src/zabbix_server/server.c src/zabbix_agent/zabbix_agent.c
SUBST_SED.fix-paths=		-e 's,"@PREFIX@,"${PREFIX},g'
SUBST_SED.fix-paths+=		-e 's,"@HOMEDIR@,"${ZBXHOME},g'
SUBST_SED.fix-paths+=		-e 's,"@CONFDIR@,"${PKG_SYSCONFDIR},g'
SUBST_SED.fix-paths+=		-e 's,"@SCRIPTDIR@,"${PREFIX}/libexec/${PKGNAME_NOREV},g'
SUBST_SED.fix-paths+=		-e 's,"@PIDDIR@,"${VARBASE}/run,g'

OWN_DIRS+=	share/zabbix share/zabbix/database/mysql share/zabbix/database/sqlite3 share/zabbix/schema share/examples/zabbix share/doc/zabbix

RCD_SCRIPTS=	zabbix_server
#RCD_SCRIPTS+=	zabbix_agentd
.for script in ${RCD_SCRIPTS}
RCD_SCRIPT_SRC.${script}=	${WRKSRC}/misc/init.d/freebsd/${script}
.endfor

# necessary SQL scripts

SQL_SCRIPTS=	mysql/images.sql mysql/schema.sql mysql/data.sql
SQL_SCRIPTS+=	sqlite3/images.sql sqlite3/schema.sql sqlite3/data.sql

SQL_SCRIPTS_DIR=	${WRKSRC}/database

#CHECK_INTERPRETER_SKIP=	share/zabbix/upgrades/dbpatches/1.8/mysql/upgrade
#CHECK_WRKREF_SKIP=	share/zabbix/upgrades/Makefile

post-install:
.for d in ${OWN_DIRS}
	mkdir -p ${DESTDIR}${PREFIX}/${d}
.endfor
# documentation
	${INSTALL_DATA} ${WRKSRC}/README ${DESTDIR}${PREFIX}/share/doc/zabbix/
.for f in ${CONFIGURATION_FILES}
	${INSTALL_DATA} ${WRKSRC}/conf/${f} ${DESTDIR}${EGDIR}/${f}
.endfor
.for f in ${SQL_SCRIPTS}
	${INSTALL_DATA} ${SQL_SCRIPTS_DIR}/${f} ${DESTDIR}${PREFIX}/share/zabbix/database/${f}
.endfor
.for f in AUTHORS COPYING INSTALL NEWS README
	${INSTALL_DATA} ${WRKSRC}/${f} ${DESTDIR}${PREFIX}/share/doc/zabbix/${f}
.endfor
# FIXME: later	cd ${WRKSRC}; pax -rw frontends upgrades ${DESTDIR}${PREFIX}/share/zabbix/
	cd ${WRKSRC}; pax -rw frontends upgrades ${DESTDIR}${PREFIX}/share/zabbix/

.include "../../joyent/percona56-client/buildlink3.mk"
#.include "../../databases/mysql56-client/buildlink3.mk"
.include "../../databases/openldap-client/buildlink3.mk"
.include "../../net/net-snmp/buildlink3.mk"
.include "../../security/libssh2/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
