

function writeRegistrationRotationSungrid(firstCycle,lastCycle,cycleRegPath,filePath)

lines ={
'#!/bin/bash'
'# Sun Grid file generated by writeRegistrationSungrid.m'
'#'
'#(the running time for this job)'
'#$ -l h_rt=05:00:00'
'#'
'#(the maximum memory usage of this job)'
'#$ -l h_vmem=2G'
'#'
'#(stderr and stdout are merged together to stdout)'
'#$ -j y'
'#'
'#(reserve memory for the job)'
'#$ -R y'
'#'
'# schedule 389 jobs with ids 1-389'
['#$ -t ' num2str(firstCycle) '-' num2str(lastCycle)]
'#$ -o /dev/null'
'#$ -cwd'
'# call your calculation executable'
[cycleRegPath '${SGE_TASK_ID}.sh']
};




fid=fopen(filePath,'w');
for i=1:length(lines)
    fprintf(fid,lines{i});
    fprintf(fid,'\n');
end


fclose(fid);

unix(['chmod 755 ' filePath]);