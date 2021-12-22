#!/bin/bash

# . ./config.sh

NUM_PARALLEL=16
NUM_THREADS="-nt ${NUM_PARALLEL}"
NO_OF_QUEUES="-dx ${NUM_PARALLEL}"
DQ_CHANNELS="-dq 1"
NUM_MESSAGES="-mg 32768"

cpu=$(dspmq -x -m PERF01 | grep PRIMARY | cut -d'(' -f3 | cut -d, -f1)

if ((cpu<0 && cpu>5)); then
  echo "Could not determine primary CPU!"
  dspmq -x -m PERF01
  exit 1
fi

run -cpu=${cpu} cph -vo 4 -ss 10 -ms 2048 -wt 120 -wi 120 -rl 0 ${NUM_MESSAGES} ${DQ_CHANNELS} -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 ${NO_OF_QUEUES} -dn 1 -pp -tx -jb PERF01 -jt mqb ${NUM_THREADS}

# run -cpu=${cpu} cph -vo 4 -ss 0 -ms 2048 -rl 60 -tc Requester -iq REQUEST -oq REPLY -db 1 -dx 1 -dn 1 -pp -tx -jb PERF01 -jt mqb -nt 1
# run -cpu=${cpu} cph -vo 4 -ss 0 -ms 2048 -mg 32768 -tc Requester -iq REQUEST -oq REPLY -db 1 -dx 1 -dn 1 -pp -tx -jb PERF01 -jt mqb -nt 1
# run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 -rl 0 -mg 32 -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx 1 -dn 1 -pp -tx -jb PERF01 -jt mqb
# run -cpu=${cpu} cph -vo 4 -ss 5 -ms 2048 -wt 120 -wi 0 -rl 30          -dq 1 -tc Requester -to 9999 -iq REQUEST -oq REPLY -db 1 -dx  1 -dn 1 -pp -tx -jb PERF01 -jt mqb


# vo: Verbosity to stdout. Log none = 0. Log all = 4
# ss: Statistics reporting period. (default: 10)
#     Setting this to 0 will disable periodic reporting entirely.
# ms: message size
# wt: WorkerThread start timeout (s). (default: 30)
#     The maximum number of seconds after starting a worker thread to wait for its status to change to 'running',
#     CPH will fail if any thread takes longer than this time to start.
#     Special case: if set to zero (0), CPH will not wait for each worker thread to start.
# wi: WorkerThread start interval (ms). (default: 1000)
#     The number of milliseconds between one thread reaching the status of 'running'
#     and the next being started, unless wt is set to zero, in which case this is simply the interval
#     between starting each worker thread.
# rl: Run length in seconds. (default: 60)
#     Setting this to 0 will disable the timer and run forever.
# mg: Fixed number of iterations to run per session. (default: 0)
#     The default setting of 0 means there is no iteration limit.
# dq: Number of DQ channels to configure
# tc: Modul (Requester|Responder)
# to: Polling timeout on receiving messages. (default: 5)
#     Polling interval in seconds. Threads will exit if a timeout occurs.
#     Set this option to -1 to wait indefinitely.
# iq: Put destination prefix. (default: REQUEST)
# oq: Get destination prefix. (default: REPLY)
# db: First number in the range
# dx: Multi-destination numeric maximum
# dn: Number of destinations in the range
# pp: Use persistent messages. (default: false)
# jb: Queue manager to connect to (PERF00|PERF01)
# jt: transport local-binding or TCP/IP (mqb|mqc)
#     mqb = local binding
# tr: Tracing
# nt: Number of worker threads
# tx: use transactions
# ls: collect latency stats

