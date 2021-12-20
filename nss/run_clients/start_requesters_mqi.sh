#!/bin/bash

. ./config.sh

RUN_CLIENTS_DIR=$PWD

STATISTICS_INTERVAL=5

if [[ $REQUESTER_TYPE == 'B_NP' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ss $STATISTICS_INTERVAL -ms $MESSAGE_SIZE -wt 120 -wi 0 -rl 0 -dq $DQ_CHANNELS -tc Requester -to 9999 -iq REQUEST -oq REPLY -co -db 1 -dx $NO_OF_QUEUES -dn 1  -jb $REQUESTER_QM -jt mqb"

elif [[ $REQUESTER_TYPE == 'B_P' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ss $STATISTICS_INTERVAL -ms $MESSAGE_SIZE -wt 120 -wi 0 -rl 0 -dq $DQ_CHANNELS -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $REQUESTER_QM -jt mqb"
elif [[ $REQUESTER_TYPE == 'C_NP' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ss $STATISTICS_INTERVAL -ms $MESSAGE_SIZE -wt 120 -wi 0 -rl 0 -dq $DQ_CHANNELS -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx $NO_OF_QUEUES -dn 1 -jb $REQUESTER_QM -jt mqc -jh $REQUESTER_QM_HOST -jp $REQUESTER_QM_LISTENER_PORT"
elif [[ $REQUESTER_TYPE == 'C_P' ]]
then
    TEMPLATE_COMMAND="./cph -vo 3 -ss $STATISTICS_INTERVAL -ms $MESSAGE_SIZE -wt 120 -wi 0 -rl 0 -dq $DQ_CHANNELS -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx $NO_OF_QUEUES -dn 1 -pp -tx -jb $REQUESTER_QM -jt mqc -jh $REQUESTER_QM_HOST -jp $REQUESTER_QM_LISTENER_PORT"
else
  echo "INVALID CLIENT TYPE"
  exit
fi

cd $CPH_DIR
echo "cd $CPH_DIR"



echo "TEMPLATE_COMMAND: $TEMPLATE_COMMAND"

if [[ $2 > 1 ]]
then
  echo "Starting multiple processes"
  mkdir -p $MULTI_PROCESS_OUTPUT_DIR
  $RUN_CLIENTS_DIR/runcph.py -c "$TEMPLATE_COMMAND" -t $1 -p $2 > $MULTI_PROCESS_OUTPUT_DIR/cph_requesters.out 2>&1
  ps -ef | grep Requester | grep cph
  echo "tail file  $MULTI_PROCESS_OUTPUT_DIR/cph_requesters.out for requesters output "
else
  echo "$TEMPLATE_COMMAND -id 1 -nt $1 ${TRACE_FLAG}"
#  $TEMPLATE_COMMAND -id 1 -nt $1 ${TRACE_FLAG}
fi

cd $RUN_CLIENTS_DIR
