# $NetBSD$

DISTNAME=	zabbix-2.2.1
PKGNAME=	zabbix-server-2.2.1
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

# ZABBIX user account
ZBXUSER?=		zabbixs
ZBXGROUP?=		zabbix

EGDIR=			${PREFIX}/share/examples/${PKGBASE}

CONF_FILES_PERMS=		${EGDIR}/zabbix_server.conf ${PKG_SYSCONFDIR}/zabbix_server.conf ${ZBXUSER} ${ZBXGROUP} 0600
INSTALLATION_DIRS+=	${EGDIR}

# Startup
RCD_SCRIPTS=		zabbix-server
SMF_NAME=		zabbix-server
SMF_METHODS=		${RCD_SCRIPTS}

ZBXWORKINGDIRECTORY?=	/tmp

FILES_SUBST+=		ZBXUSER=${ZBXUSER}
FILES_SUBST+=		ZBXGROUP=${ZBXGROUP}
FILES_SUBST+=		ZBXWORKINGDIRECTORY=${ZBXWORKINGDIRECTORY}
BUILD_DEFS+=		ZBXWORKINGDIRECTORY

PKG_GROUPS_VARS+=	ZBXGROUP
PKG_USERS_VARS+=	ZBXUSER

PKG_GROUPS=		${ZBXGROUP}
PKG_USERS=		${ZBXUSER}:${ZBXGROUP}
PKG_GECOS.${PGUSER}=	ZABBIX monitoring server user
PKG_SHELL.${PGUSER}=	${SH}


# Patches
BUILD_DEFS+=		VARBASE
SUBST_CLASSES+=			fix-paths
SUBST_STAGE.fix-paths=		post-patch
SUBST_MESSAGE.fix-paths=	Fixing absolute pathes.
SUBST_FILES.fix-paths=		src/zabbix_server/server.c src/zabbix_agent/zabbix_agentd.c conf/zabbix_server.conf conf/zabbix_agentd.conf
SUBST_SED.fix-paths=		-e 's,"@PREFIX@,"${PREFIX},g'
SUBST_SED.fix-paths+=		-e 's,"@HOMEDIR@,"${ZBXHOME},g'
SUBST_SED.fix-paths+=		-e 's,"@CONFDIR@,"${PKG_SYSCONFDIR},g'
SUBST_SED.fix-paths+=		-e 's,"@SCRIPTDIR@,"${PREFIX}/libexec/${PKGNAME_NOREV},g'
SUBST_SED.fix-paths+=		-e 's,"@PIDDIR@,"${ZBXWORKINGDIRECTORY},g'
SUBST_SED.fix-paths+=		-e 's,^LogFile=.*/\([^/]*\)$$,LogFile=${VARBASE}/log/${PKGBASE}/\1,g'

OWN_DIRS+=	share/zabbix-server share/zabbix-server/database/mysql share/zabbix-server/database/sqlite3 share/zabbix-server/schema share/examples/zabbix-server share/doc/zabbix-server
OWN_DIRS_PERMS+=	${VARBASE}/log/zabbix-server ${ZBXUSER} ${ZBXGROUP} 0770

RCD_SCRIPTS=	zabbix_server
#RCD_SCRIPTS+=	zabbix_agentd
.for script in ${RCD_SCRIPTS}
RCD_SCRIPT_SRC.${script}=	${WRKSRC}/misc/init.d/freebsd/${script}
.endfor

PRINT_PLIST_AWK+=       /^etc/ { next; }

# necessary SQL scripts

SQL_SCRIPTS=	mysql/images.sql mysql/schema.sql mysql/data.sql
SQL_SCRIPTS+=	sqlite3/images.sql sqlite3/schema.sql sqlite3/data.sql

SQL_SCRIPTS_DIR=	${WRKSRC}/database

post-install:
.for d in ${OWN_DIRS}
	mkdir -p ${DESTDIR}${PREFIX}/${d}
.endfor
# documentation
	${INSTALL_DATA} ${WRKSRC}/README ${DESTDIR}${PREFIX}/share/doc/${PKGBASE}/
.for f in ${CONFIGURATION_FILES}
	${INSTALL_DATA} ${WRKSRC}/conf/${f} ${DESTDIR}${EGDIR}/${f}
.endfor
.for f in ${SQL_SCRIPTS}
	${INSTALL_DATA} ${SQL_SCRIPTS_DIR}/${f} ${DESTDIR}${PREFIX}/share/${PKGBASE}/database/${f}
.endfor
.for f in AUTHORS COPYING INSTALL NEWS README
	${INSTALL_DATA} ${WRKSRC}/${f} ${DESTDIR}${PREFIX}/share/doc/${PKGBASE}/${f}
.endfor
	cd ${WRKSRC}; pax -rw frontends upgrades ${DESTDIR}${PREFIX}/share/${PKGBASE}/

.include "../../joyent/percona56-client/buildlink3.mk"
#.include "../../databases/mysql56-client/buildlink3.mk"
.include "../../databases/openldap-client/buildlink3.mk"
.include "../../net/net-snmp/buildlink3.mk"
.include "../../security/libssh2/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
