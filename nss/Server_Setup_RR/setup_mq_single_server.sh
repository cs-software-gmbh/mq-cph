#!/bin/sh
###########################################################################
### Sample MQ Queue Manager Setup for MQ-CPH Test (Paul Harris: March 2017)
###########################################################################
. ./config.sh

#WIP


if crtmqm -u SYSTEM.DEAD.LETTER.QUEUE -h 50000 $QM_NAME 
   then
      echo "Modifying $DATA_DIRECTORY/$QM_NAME/qm.ini"
      perl ./modifyQmIni.pl $DATA_DIRECTORY/qmgrs/$QM_NAME/qm.ini ./qm_update.ini
      strmqm $QM_NAME
      echo "define listener(L1) trptype(tcp) port($LISTENER_PORT) control(qmgr)" | runmqsc $QM_NAME
      runmqsc $QM_NAME < "./mqsc/base.mqsc"
      runmqsc $QM_NAME < "./mqsc/rr.mqsc"
   else
      echo "Cannot create queue manager $QM_NAME"
fi

endmqm $QM_NAME
sleep 5
strmqm $QM_NAME
