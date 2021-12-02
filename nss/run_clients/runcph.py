#!/usr/bin/env python
import os
import argparse

########################################################################################
#
# Start cph threads across multiple processes in the background (mimicking perf) 
# 
# For usage:
# run_cph.py -h 
#
# Specifying -e (even distribution) mimics the way perf starts requesters:
# First requester only has one thread, second has 'producer.inc'-1 threads.
# Subsequent processes have 'producer.inc' threads.
#
# Paul Harris - April 2020
########################################################################################
#

parser = argparse.ArgumentParser()
#process = parser.add_mutually_exclusive_group(required=True)

parser.add_argument("-c", "--cphcommand", dest="cmd",
                     help="a cph command (including any path), WITHOUT the -nt or -id parms(these will be added by this script)", 
                     metavar="<CPHCOMMAND>")
parser.add_argument("-t", "--threads", dest="threads",
                     type=int,
                     help="Total number of cph threads to be started", metavar="<THREADS>")              
parser.add_argument("-p", "--processes", dest="processes",
                     type=int,
                     help="Number of processes threads are to be spread over", metavar="<PROCESSES>")
parser.add_argument("-e", "--evendistribution", dest="evenDist",
                     default=False,
                     action='store_true',
                     help="Simulate mqperf even.distribution")              


args = parser.parse_args()
print(args.cmd)

threadsperprocess = int(args.threads) / int(args.processes)
#print("args.threads: {}").format(args.threads)
#print("args.processes: {}").format(args.processes)
print("Threads per process: {}").format(threadsperprocess)

if(args.evenDist):
   cphcmd = args.cmd + " -nt 1 -id 1 &"
   print(cphcmd)
   os.system(cphcmd)

   remainder=threadsperprocess-1
   cphcmd = args.cmd + " -nt " + str(remainder) + " -id 2 &"
   print(cphcmd)
   os.system(cphcmd)

   for x in range(3,int(args.processes)+2):
      cphcmd = args.cmd + " -nt " + str(threadsperprocess) + " -id " + str(x) + " &"
      print(cphcmd)
      os.system(cphcmd)
else:
   for x in range(0,int(args.processes)):
      cphcmd = args.cmd + " -nt " + str(threadsperprocess) + " -id " + str(x) + " &"
      print(cphcmd)
      os.system(cphcmd)

   

