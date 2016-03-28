#!/bin/bash
# chkconfig: 2345 10 90 
# description: hazelcast ....

if [ "${HAZELCAST_HOME}" == "" ] ; then
    export HAZELCAST_HOME=/var/lib/hazelcast/hazelcast-3.6.1
fi 
#validate
if [ ! -f "${HAZELCAST_HOME}/bin/server.sh" ] ; then
	echo "HAZELCAST_HOME not found or incorrect path "
	echo "please set HAZELCAST_HOME in environment variable or start script "
	exit
fi

HAZELCAST_LOG=${HAZELCAST_HOME}/hazelcast.log 
HAZELCAST_PID=${HAZELCAST_HOME}/bin/hazelcast_instance.pid 

echo "# HAZELCAST_HOME=$HAZELCAST_HOME" >> ${HAZELCAST_LOG}
echo "# HAZELCAST_LOG=$HAZELCAST_LOG" >> ${HAZELCAST_LOG}
echo "# HAZELCAST_PID=$HAZELCAST_PID" >> ${HAZELCAST_LOG}

function init {

chmod +x ${HAZELCAST_HOME}/bin/*.sh
touch ${HAZELCAST_PID}
}

function start {
  echo "starting now ...."
  PID=$(cat "${HAZELCAST_PID}");
  if [ -z "${PID}" ]; then
   cd "${HAZELCAST_HOME}/bin"
   rm -f ${HAZELCAST_PID}
   nohup ${HAZELCAST_HOME}/bin/server.sh >> ${HAZELCAST_LOG} 2>&1 &
   echo "started"
   exit 0
  else
    echo "error , hazelcast instance is running , will exit "
    exit 0
  fi
  
}


function stop {
  echo "stoping now...."
  PID=$(cat "${HAZELCAST_PID}");
  if [ -z "${PID}" ]; then
    echo "no hazelcast instance is running."
  else
   ${HAZELCAST_HOME}/bin/stop.sh >> ${HAZELCAST_LOG} 2>&1
   rm -rf "${HAZELCAST_PID}"
   echo "Hazelcast Instance with PID ${PID} shutdown."
   exit 0
  fi
}

function status {
  PID=$(cat "${HAZELCAST_PID}");
  if [ -z "${PID}" ]; then
    echo "hazelcast stoped"
    exit 0
  else
    echo "hazelcast is running (pid:${PID})"
    exit 0
  fi
}


function main {
   RETVAL=0
   case "$1" in
      start)                                               
         start
         ;;
       stop)                                                
         stop
         ;;
	 restart)                                                
         stop
		 sleep 2
		 start
		 ;;
      status)                                                
        status
         ;;
      *)
         echo "Usage: $0 {start|stop|restart|status}"
         exit 1
         ;;
      esac
   exit $RETVAL
}

init
main $1

