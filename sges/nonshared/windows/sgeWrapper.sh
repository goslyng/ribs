#!/bin/sh
# Ensure that under SGE, we're in /bin/sh too:
#$ -S /bin/sh
#$ -v MDCE_DECODE_FUNCTION,MDCE_STORAGE_LOCATION,MDCE_STORAGE_CONSTRUCTOR,MDCE_JOB_LOCATION,MDCE_TASK_LOCATION,MDCE_MATLAB_EXE,MDCE_MATLAB_ARGS,MDCE_DEBUG

# Copyright 2006-2007 The MathWorks, Inc.
# $Revision: 1.1.6.1 $   $Date: 2008/06/24 17:02:56 $

echo "Executing: ${MDCE_MATLAB_EXE} ${MDCE_MATLAB_ARGS}"
exec "${MDCE_MATLAB_EXE}" ${MDCE_MATLAB_ARGS}