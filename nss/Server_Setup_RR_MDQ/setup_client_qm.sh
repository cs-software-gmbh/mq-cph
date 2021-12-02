#!/bin/sh
##############################################################################
### Sample MQ Queue Manager Setup for MQ-CPH DQ Test (Paul Harris: March 2017)
##############################################################################
. ./config.sh

echo "The value of DQ_CLIENTQM_HOST ($DQ_CLIENTQM_HOST) must be this machine ($HOSTNAME), or its IP address. "
read -r -p "Is the value of DQ_CLIENTQM_HOST correct? [y/N] " response
if [[ $response == "y" || $response == "Y" || $response == "yes" || $response == "Yes" ]]
then
  echo Continuing
else
  echo "Exiting. Correct the config and try again"
  exit
fi

sed 's/<buff>/'$DQ_QUEUE_BUFF_SIZE'/;s/<pbuff>/'$DQ_QUEUE_PBUFF_SIZE'/' qm_update.template > qm_update.ini

if crtmqm -u SYSTEM.DEAD.LETTER.QUEUE -h 50000 -lc -ld $DQ_CLIENTQM_LOG_DIR -md $DQ_CLIENTQM_DATA_DIRECTORY -lf 16384 -lp $DQ_LOG_PRIMARY_FILES $DQ_CLIENTQM_NAME
   then
      echo "Modifying $DATA_DIRECTORY/$DQ_CLIENTQM_NAME/qm.ini"
      perl ./modifyQmIni.pl $DATA_DIRECTORY/$DQ_CLIENTQM_NAME/qm.ini ./qm_update.ini
      perl ./defDQ.pl CLIENT $DQ_CHANNELS $DQ_REMOTE_QUEUE_PAIRS $DQ_CLIENTQM_NAME $DQ_SERVERQM_NAME $DQ_CLIENTQM_HOST $DQ_SERVERQM_HOST $DQ_CLIENTQM_PORT $DQ_SERVERQM_PORT $DQ_BATCH_SIZE > mqsc/$DQ_CLIENTQM_NAME.mqsc

      strmqm $DQ_CLIENTQM_NAME
	  echo "define listener(L1) trptype(tcp) port($DQ_CLIENTQM_PORT) control(qmgr)" | runmqsc $DQ_CLIENTQM_NAME
      runmqsc $DQ_CLIENTQM_NAME < "./mqsc/base.mqsc"
	  runmqsc $DQ_CLIENTQM_NAME < "./mqsc/$DQ_CLIENTQM_NAME.mqsc"
   else
      echo "Cannot create queue manager $DQ_CLIENTQM_NAME"
fi
