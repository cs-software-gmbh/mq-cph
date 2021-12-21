#!/bin/sh
###########################################################################
### Sample MQ Queue Manager Setup for MQ-CPH Test (Paul Harris: March 2017)
###########################################################################
QM_NAME=PERF0

MQ_DEFAULT_INSTALLATION_PATH=${MQINST}/opt/mqm
MQ_INSTALLATION_PATH=${MQ_INSTALLATION_PATH:=$MQ_DEFAULT_INSTALLATION_PATH}
. $MQ_INSTALLATION_PATH/../../var/mqm/mqprofile

#Override the following two variables for non-default file locations
MQ_DATA_PATH=${MQINST}/var/mqm
LOG_DIR=$MQ_DATA_PATH/log
DATA_DIRECTORY=$MQ_DATA_PATH/qmgrs

if crtmqm -u SYSTEM.DEAD.LETTER.QUEUE -h 50000 $QM_NAME
then
    echo "Modifying $DATA_DIRECTORY/$QM_NAME/qm.ini"
    perl ./modifyQmIni.pl $DATA_DIRECTORY/$QM_NAME/qm.ini ./qm_update.ini

    #strmqm -c $QM_NAME
    strmqm $QM_NAME
    runmqsc $QM_NAME < "./mqsc/base.mqsc"
    runmqsc $QM_NAME < "./mqsc/rr.mqsc"
else
	echo "Cannot create queue manager $QM_NAME"
fi
