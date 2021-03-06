

function writeRegistrationRotationSungridBH(params,filePath)

lines ={
'#!/bin/bash'
'# Sun Grid file generated by writeRegistrationSungrid.m'
'#'
'#(the running time for this job)'
'#$ -l h_rt=05:00:00'
'#'
'#(the maximum memory usage of this job)'
'#$ -l h_vmem=20G'
'#'
'#(stderr and stdout are merged together to stdout)'
'#$ -j y'
'#'
'#(reserve memory for the job)'
'#$ -R y'
'#'
'# schedule 389 jobs with ids 1-389'
['#$ -t ' num2str(params.ribs(1)) '-' num2str(params.ribs(end))]
'#$ -o /dev/null'
'#$ -cwd'
'# call your calculation executable'
[params.registrationPath '${SGE_TASK_ID}.sh']
};




fid=fopen(filePath,'w');
for i=1:length(lines)
    fprintf(fid,lines{i});
    fprintf(fid,'\n');
end


fclose(fid);

unix(['chmod 755 ' filePath]);