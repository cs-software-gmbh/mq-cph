#!/bin/bash
. ./config.sh

RUN_CLIENTS_DIR=$PWD

STATISTICS_INTERVAL=0

if [[ $RESPONDER_TYPE == 'B_NP' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -rl 0 -tc Responder -oq REPLY -iq REQUEST -cr -to -1 -db 1 -dx $NO_OF_QUEUES -dn 1 -jb $RESPONDER_QM -jt mqb"

elif [[ $RESPONDER_TYPE == 'B_P' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -rl 0 -tc Responder -oq REPLY -iq REQUEST -cr -to -1 -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $RESPONDER_QM -jt mqb"
elif [[ $RESPONDER_TYPE == 'C_NP' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -rl 0 -tc Responder -oq REPLY -iq REQUEST -cr -to -1 -db 1 -dx $NO_OF_QUEUES -dn 1 -jb $RESPONDER_QM -jt mqc -jh $RESPONDER_QM_HOST -jp $RESPONDER_QM_LISTENER_PORT"
elif [[ $RESPONDER_TYPE == 'C_P' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ms $MESSAGE_SIZE -su -wt 9999 -wi 0 -ss $STATISTICS_INTERVAL -rl 0 -tc Responder -oq REPLY -iq REQUEST -cr -to -1 -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $RESPONDER_QM -jt mqc -jh $RESPONDER_QM_HOST -jp $RESPONDER_QM_LISTENER_PORT"
else
  echo "INVALID CLIENT TYPE"
  exit
fi

cd $CPH_DIR

if [[ $2 > 1 ]]
then
  echo "Starting multiple processes"
  mkdir -p $MULTI_PROCESS_OUTPUT_DIR 
  $RUN_CLIENTS_DIR/runcph.py -c "$TEMPLATE_COMMAND" -t $1 -p $2 > $MULTI_PROCESS_OUTPUT_DIR/cph_responders.out 2>&1
  ps -ef | grep Responder | grep cph
  echo "tail file  $MULTI_PROCESS_OUTPUT_DIR/cph_responders.out for responders output "
else
  echo "$TEMPLATE_COMMAND -id 1 -nt $1 ${TRACE_FLAG}"
#  $TEMPLATE_COMMAND -id 1 -nt $1 ${TRACE_FLAG}
fi

cd $RUN_CLIENTS_DIR
