#!/bin/ksh
#
#	Jens Neuhalfen
#	SMF Method file for zabbix server
#	E-mail: 
#
#

. /lib/svc/share/smf_include.sh


case "$1" in
	start)
                @LOCALBASE@/zabbix_server &
		;;
	*)
		echo ""
		echo "Usage: `basename $0` { start }"
		echo ""
		exit 64
		;;
esac

#---EOF
