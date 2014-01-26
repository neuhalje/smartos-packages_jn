#!/bin/ksh
#
#	Jens Neuhalfen
#	SMF Method file for zabbix agentd
#	E-mail: 
#
#

. /lib/svc/share/smf_include.sh


case "$1" in
	start)
                @LOCALBASE@/sbin/zabbix_agentd &
		;;
	*)
		echo ""
		echo "Usage: `basename $0` { start }"
		echo ""
		exit 64
		;;
esac

#---EOF
