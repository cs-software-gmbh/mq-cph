#!/bin/bash

cpu=$(dspmq -x -m PERF0 | grep PRIMARY | cut -d'(' -f3 | cut -d, -f1)
if ((cpu>=0 && cpu<=5)); then
run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 -rl 60 -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx 10 -dn 1 -pp -tx -jb PERF0 -jt mqb -tr
#  run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 -rl 0 -mg 32 -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx  1 -dn 1 -pp -tx -jb PERF0 -jt mqb
#  run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 -rl 30 -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx  1 -dn 1 -pp -tx -jb PERF0 -jt mqb
else
  echo "Could not determine primary CPU!"
  dspmq -x -m PERF0
fi

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
