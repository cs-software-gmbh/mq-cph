#!/bin/bash
###########################################################################
### Sample MQ Queue Manager Setup for MQ-CPH Test (Paul Harris: March 2017)
### Usage:
### setup_mq_server2.sh <number of qms to be created> <qm start index> <port start index>
###########################################################################

###########################################################################
# Validate that correct parms have been passed
###########################################################################
usage () {
	echo >&2 "Invalid argument(s): $@"
    echo >&2 "Usage: $0 <number of qms to be created> <qm start index> <port start index>"
    exit 1
}

if (($#!=3));
then
  usage $*
fi
echo $1 | grep -E -q '^[0-9]+$' || usage $*
if (($1 < 1));
then
   usage $*
fi

###########################################################################
NO_OF_QMS=$1
QM_INDEX=$2
LISTENER_PORT=$3
###########################################################################
shift 3
. ./config.sh

echo "#Do not edit this generated file. Edit qm_update.template instead" > qm_update.ini
sed 's/<buff>/'$QUEUE_BUFF_SIZE'/g' qm_update.template >> qm_update.ini

for ((i=$QM_INDEX;i<$((NO_OF_QMS+QM_INDEX));i++));
do
   printf -v QM_SUFFIX '%02d' $i
   QM_NAME=$QM_NAME_PREFIX$QM_SUFFIX
   if crtmqm -u SYSTEM.DEAD.LETTER.QUEUE -h 50000 $QM_NAME
   then
      echo "Modifying $DATA_DIRECTORY/$QM_NAME/qm.ini"
      perl ./modifyQmIni.pl $DATA_DIRECTORY/$QM_NAME/qm.ini ./qm_update.ini

      #strmqm -c $QM_NAME
      strmqm $QM_NAME
	  echo "define listener(L1) trptype(tcp) port($LISTENER_PORT) control(qmgr)" | runmqsc $QM_NAME
      runmqsc $QM_NAME < "./mqsc/base.mqsc"
      runmqsc $QM_NAME < "./mqsc/rr.mqsc"
	  LISTENER_PORT=$((LISTENER_PORT+=1))
   else
      echo "Cannot create queue manager $QM_NAME"
   fi
done
