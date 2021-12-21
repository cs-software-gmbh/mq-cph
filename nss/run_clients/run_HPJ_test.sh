#!/bin/bash

cpu=$(dspmq -x -m PERF0 | grep PRIMARY | cut -d'(' -f3 | cut -d, -f1)

if ((cpu<0 || cpu>5)); then
  echo "Could not determine primary CPU!"
  dspmq -x -m PERF0
fi

function run_test_runtime_length
{
  rl="-rl ${1}"
  echo "run_test_runtime_length: ${rl}"
  # Runtime length 60 seconds test
  # run -cpu=${cpu} cph -vo 4 -ms 2048 -su -wt 9999 -wi 0 -ss 0 ${rl} -tc Responder -oq REPLY -iq REQUEST -cr -to -1 -db 1 -dx 10 -dn 1 -pp -tx -jb PERF0 -jt mqb -id 1 -nt 1 -tr
  # run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 ${rl} -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx 10 -dn 1 -pp -tx -jb PERF0 -jt mqb -tr
  echo "run -cpu=${cpu} cph -vo 4 -ms 2048 -su -wt 9999 -wi 0 -ss 0 ${rl} -tc Responder -oq REPLY -iq REQUEST -cr -to -1 -db 1 -dx  1 -dn 1 -pp -tx -jb PERF0 -jt mqb -id 1 -nt 1"
  responderPID=$!
  echo "run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 ${rl} -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx  1 -dn 1 -pp -tx -jb PERF0 -jt mqb"
  requesterPID=$!

#  wait $responderPID
#  wait $requesterPID
}

function run_test_message_number
{
  mg="-mg ${1}"
  echo "run_test_message_number: ${mg}"
  echo "run -cpu=${cpu} cph -vo 4 -ms 2048 -su -wt 9999 -wi 0 -ss 0 -rl 0 ${mg} -tc Responder -oq REPLY -iq REQUEST -cr -to -1 -db 1 -dx  1 -dn 1 -pp -tx -jb PERF0 -jt mqb -id 1 -nt 1"
  responderPID=$!
  echo "run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 -rl 0 ${mg} -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx  1 -dn 1 -pp -tx -jb PERF0 -jt mqb"
  requesterPID=$!

#  wait $responderPID
#  wait $requesterPID
}

run_test_message_number 8096 
#run_test_runtime_length 20

# mg: Number of iterations
# ss: Statistics interval
# ls: collect latency stats
# ms: message size
# pp: perstistent messages
# tx: use transactions
# jb: queue amanager
# iq: input queue
# oq: output queue
# tr: tracing
# jt: mqb = local binding

