#!/bin/sh

### BEGIN INIT INFO
# Provides:        oauth-proxy
# Required-Start:  $network $remote_fs $syslog
# Required-Stop:   $network $remote_fs $syslog
# Default-Start:   2 3 4 5
# Default-Stop:    1
# Short-Description: Start the oauth-proxy daemon
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin

. /lib/lsb/init-functions

set -x

PROG=/usr/local/bin/oauth-proxy
PROGARGS="-config=/etc/oauth.cfg"

PIDFILE=/var/run/oauth2.pid

test -x $PROG || exit 5
 

RUNASUSER=root
UGID=root

case $1 in
	start)
		log_daemon_msg "Starting oauth2"
		if [ -z "$UGID" ]; then
			log_failure_msg "user \"$RUNASUSER\" does not exist"
			exit 1
		fi
    start-stop-daemon --start --oknodo --verbose --chuid $RUNASUSER --background --make-pidfile --pidfile $PIDFILE  --startas /bin/bash -- -c "exec $PROG $PROGARGS >/var/log/oauth.log 2>&1"
		status=$?
		log_end_msg $status
  		;;
	stop)
		log_daemon_msg "Stopping oauth2"
    start-stop-daemon --stop --oknodo --pidfile $PIDFILE
		log_end_msg $?
		rm -f $PIDFILE
  		;;
	restart|force-reload)
		$0 stop && sleep 2 && $0 start
  		;;
	try-restart)
		if $0 status >/dev/null; then
			$0 restart
		else
			exit 0
		fi
		;;
	reload)
		exit 3
		;;
	status)
		status_of_proc $DAEMON "rtls server"
		;;
	*)
		echo "Usage: $0 {start|stop|restart|try-restart|force-reload|status}"
		exit 2
		;;
esac
