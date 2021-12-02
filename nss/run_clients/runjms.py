#!/usr/bin/env python
import os
import argparse

########################################################################################
#
# Start jmsperfharness threads across multiple processes in the background (mimicking perf) 
# 
# For usage:
# run_jmsperfharness.py -h 
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

parser.add_argument("-c", "--jmsperfharnesscommand", dest="cmd",
                     help="a jmsperfharness command (including any path), WITHOUT the -nt or -id parms(these will be added by this script)", 
                     metavar="<jmsperfharnessCOMMAND>")
parser.add_argument("-t", "--threads", dest="threads",
                     type=int,
                     help="Total number of jmsperfharness threads to be started", metavar="<THREADS>")              
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
print(threadsperprocess)

if(args.evenDist):
   jmsperfharnesscmd = args.cmd + " -nt 1 -id 1 &"
   print(jmsperfharnesscmd)
   os.system(jmsperfharnesscmd)

   remainder=threadsperprocess-1
   jmsperfharnesscmd = args.cmd + " -nt " + str(remainder) + " -id 2 &"
   print(jmsperfharnesscmd)
   os.system(jmsperfharnesscmd)

   for x in range(3,int(args.processes)+2):
      jmsperfharnesscmd = args.cmd + " -nt " + str(threadsperprocess) + " -id " + str(x) + " &"
      print(jmsperfharnesscmd)
      os.system(jmsperfharnesscmd)
else:
   for x in range(0,int(args.processes)):
      jmsperfharnesscmd = args.cmd + " -nt " + str(threadsperprocess) + " -id " + str(x) + " &"
      print(jmsperfharnesscmd)
      os.system(jmsperfharnesscmd)

   

