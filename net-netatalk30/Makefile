# $NetBSD$

DISTNAME=	netatalk-3.0.8
PKGNAME=	netatalk30-3.0.8
CATEGORIES=	net
MASTER_SITES=	http://downloads.sourceforge.net/project/netatalk/netatalk/3.0.8/

BDB_ACCEPTED=		db4 db5
GNU_CONFIGURE=		yes
USE_LANGUAGES=		c c++
USE_LIBTOOL=		yes
USE_OLD_DES_API=	yes
USE_PKGLOCALEDIR=	yes
USE_TOOLS+=		gmake perl:run
USE_TOOLS+=	pkg-config


MAINTAINER=	jens@neuhalfen.name
HOMEPAGE=	http://downloads.sourceforge.net/project/netatalk/netatalk/3.0.8/
COMMENT=	Netatalk is a freely-available Open Source AFP fileserver.
LICENSE=	gnu-gpl-v3

WRKSRC=		${WRKDIR}/netatalk-3.0.8

PKGCONFIG_OVERRIDE+=	libevent/libevent_pthreads.pc.in
PKGCONFIG_OVERRIDE+=	libevent/libevent.pc.in
PKGCONFIG_OVERRIDE+=	libevent/libevent_openssl.pc.in

PKG_CONFIG=		yes
PKG_SYSCONFSUBDIR=	netatalk
EGDIR=		${PREFIX}/share/examples/netatalk
#CONF_FILES=	${EGDIR}/afp.conf		${PKG_SYSCONFDIR}/afd.conf
CONF_FILES+=	${EGDIR}/afp.conf	${PKG_SYSCONFDIR}/afp.conf
CONF_FILES+=	${EGDIR}/extmap.conf		${PKG_SYSCONFDIR}/extmap.conf
#CONF_FILES+=	${EGDIR}/netatalk-dbus.conf	${PKG_SYSCONFDIR}/netatalk-dbus.conf

CONFLICTS=	netatalk-asun-[0-9]* netatalk-umich-[0-9]*

#BUILDLINK_TRANSFORM+=	l:db48:${BDB_TYPE}

.include "../../mk/bsd.prefs.mk"

BUILD_DEFS+=		VARBASE
# CONFIGURE_ARGS+=	--enable-netbsd
# CONFIGURE_ARGS+=	--enable-overwrite
CONFIGURE_ARGS+=	--disable-ddp
CONFIGURE_ARGS+=	--enable-quota
CONFIGURE_ARGS+=	--enable-timelord
CONFIGURE_ARGS+=	--libexecdir=${PREFIX}/libexec/netatalk
CONFIGURE_ARGS+=	--localstatedir=${VARBASE}/db
CONFIGURE_ARGS+=	--sbindir=${PREFIX}/libexec/netatalk
CONFIGURE_ARGS+=	--with-bdb=${BDBBASE}
CONFIGURE_ARGS+=	--with-init-dir=/var/svc/manifest/network
CONFIGURE_ARGS+=	--with-init-style=solaris
CONFIGURE_ARGS+=	--with-message-dir=${PKG_SYSCONFDIR}/msg
CONFIGURE_ARGS+=	--with-pkgconfdir=${PKG_SYSCONFDIR}
CONFIGURE_ARGS+=	--with-ssl-dir=${BUILDLINK_PREFIX.openssl}
#CONFIGURE_ARGS+=	--with-uams-path=${PREFIX}/libexec/netatalk/uams
CONFIGURE_ARGS+=        --prefix=${PREFIX}
CONFIGURE_ARGS+=        --with-libgcrypt
CONFIGURE_ENV+=		MACHINE_ARCH=${MACHINE_ARCH}

CFLAGS.SunOS+= -I/usr/include/kerberosv5/

MAKE_DIRS+=		${PKG_SYSCONFDIR}/msg

REPLACE_PYTHON+=	contrib/shell_utils/afpstats

SUBST_CLASSES+=		paths
SUBST_MESSAGE.paths=	Fixing hardcoded paths.
SUBST_STAGE.paths=	pre-configure
SUBST_FILES.paths=	distrib/initscripts/Makefile.in
SUBST_SED.paths=	-e "s,^\\(DVIPS=\\)\\(/usr/local/tex\\)\\(/bin\\),\\1${PREFIX}\\3,"

# PLIST_VARS+=		rcd
# .if ${OPSYS} == "NetBSD"
# RCD_SCRIPTS=		afpd atalkd papd timelord cnid_metad
# .  for f in ${RCD_SCRIPTS}
# RCD_SCRIPT_SRC.${f}=	${WRKSRC}/distrib/initscripts/${f}
# .  endfor
# PLIST.rcd=		yes
# .endif

PLIST_VARS+=		ea
.if (${OPSYS} == "SunOS" || ${OPSYS} == "DragonFly" || ${OPSYS} == "Linux" || (${OPSYS} == "NetBSD" && empty(OS_VERSION:M[0-6].[0-8]*)))
PLIST.ea=		yes
.endif

.include "options.mk"

INSTALLATION_DIRS=	libexec/psffilters etc/netatalk

OWN_DIRS_PERMS+=        ${VARBASE}/db/netatalk/CNID/Storage root root 0770

.if !empty(PKG_OPTIONS:Mpam)
post-install:
	${INSTALL_DATA} ${WRKSRC}/config/pam/netatalk.pam ${DESTDIR}${EGDIR}
.endif

.include "../../mk/bdb.buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"

.if ${OPSYS} == "SunOS" 
.include "../../joyent/percona56-client/buildlink3.mk"
.else
.include "../../databases/mysql55-client/buildlink3.mk"
.endif

.include "../../lang/python/application.mk"
.include "../../security/libgcrypt/buildlink3.mk"
.include "../../security/tcp_wrappers/buildlink3.mk"
.include "../../sysutils/dbus-glib/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
