#!/bin/bash
. ./config.sh
export CLASSPATH=$MQ_JAVALIB/com.ibm.mq.jar:$MQ_JAVALIB/com.ibm.mqjms.jar:$MQ_JAVALIB/com.ibm.mq.allclient.jar:$PERF_HARNESS_JAR

RUN_CLIENTS_DIR=$PWD

STATISTICS_INTERVAL=0

if [[ $RESPONDER_TYPE == 'B_NP' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -rl 0 -tc jms.r11.Responder -oq REPLY -iq REQUEST -cr -to 0 -db 1 -dx $NO_OF_QUEUES -dn 1 -jb $RESPONDER_QM -jt mqb -pc WebSphereMQ -wp true -wc 99999"
elif [[ $RESPONDER_TYPE == 'B_P' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -rl 0 -tc jms.r11.Responder -oq REPLY -iq REQUEST -cr -to 0 -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $RESPONDER_QM -jt mqb -pc WebSphereMQ -wp true -wc 99999"
elif [[ $RESPONDER_TYPE == 'C_NP' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -rl 0 -tc jms.r11.Responder -oq REPLY -iq REQUEST -cr -to 0 -db 1 -dx $NO_OF_QUEUES -dn 1 -jb $RESPONDER_QM -jt mqc -jh $RESPONDER_QM_HOST -jp $RESPONDER_QM_LISTENER_PORT -pc WebSphereMQ -wp true -wc 99999"
elif [[ $RESPONDER_TYPE == 'C_P' ]]
then
    TEMPLATE_COMMAND="$JAVA_BIN_DIR/java -Xms4096M -Xmx4096M -Xmn3072M JMSPerfHarness -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -sc BasicStats -rl 0 -tc jms.r11.Responder -oq REPLY -iq REQUEST -cr -to 0 -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $RESPONDER_QM -jt mqc -jh $RESPONDER_QM_HOST -jp $RESPONDER_QM_LISTENER_PORT -pc WebSphereMQ -wp true -wc 99999"
else
  echo "INVALID CLIENT TYPE"
  exit
fi

if [[ $2 > 1 ]]
then
  echo "Starting multiple processes"
  mkdir -p $MULTI_PROCESS_OUTPUT_DIR 
  $RUN_CLIENTS_DIR/runjms.py -c "$TEMPLATE_COMMAND" -t $1 -p $2 > $MULTI_PROCESS_OUTPUT_DIR/jms_responders.out 2>&1
  ps -ef | grep jms.r11.Responder
  echo "tail file  $MULTI_PROCESS_OUTPUT_DIR/jms_responders.out for responders output "
else
  echo $TEMPLATE
  $TEMPLATE_COMMAND -id 1 -nt $1
fi
