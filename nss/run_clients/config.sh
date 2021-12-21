#!/bin/bash

# Flag to create trace output
# TRACE_FLAG=-tr

#REQUESTER_QM = the CLIENT_QM in the setup
#RESPONDER_QM = the SERVER_QM in the setup

REQUESTER_QM=PERF0
RESPONDER_QM=PERF0

#The four settings below are only required for client mode tests
REQUESTER_QM_HOST=cs5
RESPONDER_QM_HOST=cs5
REQUESTER_QM_LISTENER_PORT=1501
RESPONDER_QM_LISTENER_PORT=1500

MESSAGE_SIZE=2048
NO_OF_QUEUES=10

#If running cph clients then DQ_CHANNELS must match DQ_CHANNELS value used during setup.
DQ_CHANNELS=1

#Types (applies to cph and jms)
# B_NP : Bindings mode (non-persistent)
# C_NP : Client mode (non-persistent)
# B_P : Bindings mode (persistent)
# C_P : Client mode (persistent)
REQUESTER_TYPE=B_P
RESPONDER_TYPE=B_P

MULTI_PROCESS_OUTPUT_DIR=/tmp/mqclient_output

CPH_DIR=/home/franz/mq-cph/mq-cph/Release/NONSTOP_KERNEL_NSV
#MQ_JAVALIB=/opt/mqm/java/lib
MQ_JAVALIB=/dont/have/one
PERF_HARNESS_JAR=/mqperf/perf/clients/_Client/jmsperfharness.jar
#JAVA_BIN_DIR=/opt/mqm/java/jre64/jre/bin
JAVA_BIN_DIR=/usr/tandem/nssjava/current/bin
#This library path is needed for bindings mode Java clients
#export LD_LIBRARY_PATH=/opt/mqm/java/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/tandem/nssjava/current/lib:$LD_LIBRARY_PATH
