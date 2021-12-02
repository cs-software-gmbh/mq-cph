#/bin/sh
#For multiple QMs
QM_NAME_PREFIX=PERF
#For Single QM
QM_NAME=PERF0
LISTENER_PORT=1414

MQ_DEFAULT_INSTALLATION_PATH=/opt/mqm
MQ_INSTALLATION_PATH=${MQ_INSTALLATION_PATH:=$MQ_DEFAULT_INSTALLATION_PATH}
. $MQ_INSTALLATION_PATH/bin/setmqenv

#Override the following two variables for non-default file locations
LOG_DIR=$MQ_DATA_PATH/log
#LOG_DIR=/var/mqm/log
#LOG_DIR=/var/ssdsata800/log
#LOG_DIR=/var/nfs10/log
#LOG_DIR=/var/san2/log
#LOG_DIR=/var/r10ext4/log
#LOG_DIR=/var/r10xfs/log
#LOG_DIR=/var/m500ssd/mqm/log

DATA_DIRECTORY=$MQ_DATA_PATH/qmgrs
#DATA_DIRECTORY=/var/mqm/qmgrs
#DATA_DIRECTORY=/ssd/mqm/qmgrs
#DATA_DIRECTORY=/var/san1/qmgrs
#DATA_DIRECTORY=/var/nfs10/qmgrs
#DATA_DIRECTORY=/var/m500ssd/mqm/qmgrs

#For 2K Message Size
LOG_PRIMARY_FILES=16
QUEUE_BUFF_SIZE=10485760

#For 20K Message Size
#LOG_PRIMARY_FILES=24
#QUEUE_BUFF_SIZE=10485760

#For 200K,2M Message Size
#LOG_PRIMARY_FILES=32
#QUEUE_BUFF_SIZE=104857600
