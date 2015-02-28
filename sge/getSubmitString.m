function submitString = getSubmitString(jobName, quotedLogFile, quotedCommand, ...
    varsToForward, additionalSubmitArgs)
%GETSUBMITSTRING Gets the correct qsub command for an SGE cluster

% Copyright 2010-2011 The MathWorks, Inc.

envString = sprintf('%s,', varsToForward{:});
% Remove the final ','
envString = envString(1:end-1);

% Submit to SGE using qsub. Note the following:
% "-S /bin/sh" - specifies that we run under /bin/sh
% "-N Job#" - specifies the job name
% "-j yes" joins together output and error streams
% "-o ..." specifies where standard output goes to
% "-v ..." specifies which environment variables to forward
load('/home/sameig/codes/matlab-distcomp/integration/duration','duration');
submitString = sprintf( 'qsub -S /bin/sh -N %s -j yes -l h_rt=%d:30:00 -l h_vmem=30G -o %s -v %s %s %s', ...
    jobName, duration,quotedLogFile, envString, additionalSubmitArgs, quotedCommand);

