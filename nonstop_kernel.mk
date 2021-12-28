#<copyright notice="lm-source" pids="" years="2014,2017">
#***************************************************************************
# Copyright (c) 2014,2017 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Contributors:
#    Various members of the WebSphere MQ Performance Team at IBM Hursley UK
#***************************************************************************
#*</copyright>
############################################################################
#                                                                          #
# Performance Harness for IBM MQ C-MQI interface                           #
#                                                                          #
############################################################################

# Get processor architecture
ARCH ?= $(shell /usr/coreutils/bin/uname -p)

# Add AMQ_UNIX preprocessor definition

# with tracing
#CPPDEFS += _REENTRANT _PUT_MODEL_ _XOPEN_SOURCE _XOPEN_SOURCE_EXTENDED=1 CPH_HPNS CPH_DOTRACE
# without tracing
CPPDEFS += CPH_UNIX _REENTRANT _PUT_MODEL_ _XOPEN_SOURCE _XOPEN_SOURCE_EXTENDED=1 CPH_HPNS

# Executable file extension
EXE =

# Object file extension
OBJ = .o

#Command to delete files
RM = rm -f

#Command to delete directories
RMDIR = rm -rf

#Command to make a directory
MKDIR = mkdir -p

#Command to create a parent directory if it's missing
KDIRPART = if [ ! -d $(@D) ]; then echo "Creating output directory: $(@D)"; echo ""; $(MKDIR) $(@D); fi

#Command to link file
LN = ln -fs

#Command to copy a file or directory
CP = cp -r

# CC Flags for TANDEM compile
CCFLAGS += -Wextensions

# Option to specify target as compiler output file
OUT = -o $@

#Option to add include directory (headers)
INC = -I


#Option to add lib directory to libpath
LP = -L

#Option to add preprocessor symbol
SYM = -D

#Option to link library
LIB = -l

# Set default MQ installation path
MQ_INSTALLATION_PATH ?= $(MQINST)/opt/mqm

#Set addressing mode
BITNESS ?= 64

# Set MQ library path
ifeq ($(BITNESS),64)
	MQLIB = $(MQ_INSTALLATION_PATH)/lib64
else
	MQLIB = $(MQ_INSTALLATION_PATH)/lib
endif

# Libraries to link
#LIBS = pthread c dl rt m
LIBS = xputdll xcppcdll xcpp4dll c m

#-L /G/system/sys04
#-L /G/system/system
#-L /G/system/zdll004
#-L/usr/local/lib

#-lcre -L/usr/local/lib -lfloss -lutil -lrld
#-lwputdll -lcre -lfloss -lutil -lrld -lxcppcdll -lxcpp4dll -lwcppcdll -lwcpp4dll -lcrtl -lossk -lossf -lsec -li18n -licnv -losse -linet -lossh -lossc -allow_duplicate_procs
#-lxputdll -lcre -lfloss -lutil -lrld -lxcppcdll -lxcpp4dll -lcrtl -lossk -lossf -lsec -li18n -licnv -losse -linet -lossh -lossc -allow_duplicate_procs

# C compiler command
cc = c99 -c -g
#cc = c99 -c -g

# C++ compiler command
#CC = c99 -c -Wcplusplus
CC = c11 -c -g -Wcplusplus
