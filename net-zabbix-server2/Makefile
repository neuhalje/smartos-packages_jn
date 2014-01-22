# $NetBSD$

DISTNAME=	zabbix-2.2.1
CATEGORIES=	net
MASTER_SITES=	http://netcologne.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.1/

MAINTAINER=	jens@neuhalfen.name
HOMEPAGE=	http://netcologne.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.1/
COMMENT=	Enterprise monitoring
LICENSE=	gnu-gpl-v2

GNU_CONFIGURE=		yes
USE_PKGLOCALEDIR=	yes
USE_LANGUAGES=		c c++

CONFIGURE_ARGS=		--enable-server --disable-agent --with-mysql --disable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 --with-ssh2=${PREFIX} --with-ldap
CONFIGURE_ARGS+= --sysconfdir=${PKG_SYSCONFDIR}

.include "../../databases/mysql56-client/buildlink3.mk"
.include "../../databases/openldap-client/buildlink3.mk"
.include "../../net/net-snmp/buildlink3.mk"
.include "../../security/libssh2/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"

