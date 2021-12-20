#!/bin/sh
##############################################################################
### Sample MQ Queue Manager Setup for MQ-CPH DQ Test (Paul Harris: March 2019)
##############################################################################
. ./config.sh

echo "The value of DQ_SERVERQM_HOST ($DQ_SERVERQM_HOST) must be this machine ($HOSTNAME), or its IP address. "
read -r -p "Is the value of DQ_SERVERQM_HOST correct? [y/N] " response
if [[ $response == "y" || $response == "Y" || $response == "yes" || $response == "Yes" ]]
then
  echo Continuing
else
  echo "Exiting. Correct the config and try again"
  exit
fi

sed 's/<buff>/'$DQ_QUEUE_BUFF_SIZE'/;s/<pbuff>/'$DQ_QUEUE_PBUFF_SIZE'/' qm_update.template > qm_update.ini

if crtmqm -u SYSTEM.DEAD.LETTER.QUEUE -h 50000 -lc -ld $DQ_SERVERQM_LOG_DIR -md $DQ_SERVERQM_DATA_DIRECTORY -lf 16384 -lp $DQ_LOG_PRIMARY_FILES $DQ_SERVERQM_NAME
   then
      echo "Modifying $DATA_DIRECTORY/$DQ_SERVERQM_NAME/qm.ini"
      perl ./modifyQmIni.pl $DATA_DIRECTORY/$DQ_SERVERQM_NAME/qm.ini ./qm_update.ini
      perl ./defDQ.pl SERVER $DQ_CHANNELS $DQ_REMOTE_QUEUE_PAIRS $DQ_CLIENTQM_NAME $DQ_SERVERQM_NAME $DQ_CLIENTQM_HOST $DQ_SERVERQM_HOST $DQ_CLIENTQM_PORT $DQ_SERVERQM_PORT $DQ_BATCH_SIZE > mqsc/$DQ_SERVERQM_NAME.mqsc

      strmqm $DQ_SERVERQM_NAME
	   echo "define listener(L1) trptype(tcp) port($DQ_SERVERQM_PORT) control(qmgr)" | runmqsc $DQ_SERVERQM_NAME
      runmqsc $DQ_SERVERQM_NAME < "./mqsc/base.mqsc"
	  runmqsc $DQ_SERVERQM_NAME < "./mqsc/$DQ_SERVERQM_NAME.mqsc"
   else
      echo "Cannot create queue manager $DQ_SERVERQM_NAME"
fi
