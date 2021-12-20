#!/bin/bash
. ./config.sh
export CLASSPATH=$MQ_JAVALIB/com.ibm.mq.jar:$MQ_JAVALIB/com.ibm.mqjms.jar:$MQ_JAVALIB/com.ibm.mq.allclient.jar:$PERF_HARNESS_JAR

RUN_CLIENTS_DIR=$PWD

STATISTICS_INTERVAL=5

if [[ $REQUESTER_TYPE == 'B_NP' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -su -wt 10 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -ms $MESSAGE_SIZE -rl 0  -tc jms.r11.Requestor -iq REQUEST -oq REPLY -co -to 30 -mt text -db 1 -dx $NO_OF_QUEUES -dn 1 -jb $REQUESTER_QM -jt mqb -pc WebSphereMQ -ja 100"

    PAUL="java  -Xms768M -Xmx768M -Xmn600M JMSPerfHarness -su -wt 10 -wi 0 -nt 1 -ss 10 -sc BasicStats -ms 2048 -rl 0 -tc jms.r11.Requestor -co -iq REQUEST -oq REPLY -to 30 -mt text -db 1  -dx 10 -dn 1 -jp 1420 -jc SYSTEM.DEF.SVRCONN -jb PERF1 -jt mqb -pc WebSphereMQ -ja 100"
elif [[ $REQUESTER_TYPE == 'B_P' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -su -wt 10 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -ms $MESSAGE_SIZE -rl 0  -tc jms.r11.Requestor -iq REQUEST -oq REPLY -co -to 30 -mt text -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $REQUESTER_QM -jt mqb -pc WebSphereMQ -ja 100"
elif [[ $REQUESTER_TYPE == 'C_NP' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -su -wt 10 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -ms $MESSAGE_SIZE -rl 0  -tc jms.r11.Requestor -iq REQUEST -oq REPLY -co -to 30 -mt text -db 1 -dx $NO_OF_QUEUES -dn 1 -jb $REQUESTER_QM -jt mqc -jh $REQUESTER_QM_HOST -jp $REQUESTER_QM_LISTENER_PORT -pc WebSphereMQ -ja 100"
elif [[ $REQUESTER_TYPE == 'C_P' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -su -wt 10 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -ms $MESSAGE_SIZE -rl 0  -tc jms.r11.Requestor -iq REQUEST -oq REPLY -co -to 30 -mt text -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $REQUESTER_QM -jt mqc -jh $REQUESTER_QM_HOST -jp $REQUESTER_QM_LISTENER_PORT -pc WebSphereMQ -ja 100"
else
  echo "INVALID CLIENT TYPE"
  exit
fi

if [[ $2 > 1 ]]
then
  echo "Starting multiple processes"
  mkdir -p $MULTI_PROCESS_OUTPUT_DIR 
  $RUN_CLIENTS_DIR/runjms.py -c "$TEMPLATE_COMMAND" -t $1 -p $2 > $MULTI_PROCESS_OUTPUT_DIR/jms_requesters.out 2>&1
  ps -ef | grep jms.r11.Requestor
  echo "tail file  $MULTI_PROCESS_OUTPUT_DIR/jms_requesters.out for requesters output "
else
  $TEMPLATE_COMMAND -id 1 -nt $1
fi


