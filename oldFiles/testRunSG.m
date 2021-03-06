
duration=10;

save('/home/sameig/codes/matlab-distcomp/integration/duration','duration');
sched = findResource('scheduler', 'type', 'generic');
% set(sched, 'ClusterMatlabRoot', '/apps/matlab');
 set(sched,'ClusterMatlabRoot','/usr/pack/matlab-8.1r2013a-sd')
set(sched, 'ClusterOsType', 'unix');
% Use a folder that both the client and cluster can access
% as the DataLocation.  If your cluster and client use 
% different operating systems, you should specify DataLocation 
% to be a structure.  Refer to the documentation on 
% genericscheduler for more information.
set(sched, 'DataLocation', '/home/sameig/dstComp');
set(sched, 'HasSharedFilesystem', true);

set(sched, 'SubmitFcn', @distributedSubmitFcn);
% If you want to run parallel jobs (including matlabpool), you must specify a ParallelSubmitFcn

set(sched, 'ParallelSubmitFcn', @parallelSubmitFcn);
set(sched, 'GetJobStateFcn', @getJobStateFcn);
set(sched, 'DestroyJobFcn', @destroyJobFcn);


j = createJob(sched);
set(j,'PathDependencies',{'/home/sameig/codes/ribFitting/'...
%     ,'/home/sameig/codes/ribFitting/shapeModeling'...
%     ,'/home/sameig/codes/ribFitting/appearanceModeling'...
%     ,'/home/sameig/codes/ribFitting/icp'...
%     ,'/home/sameig/codes/ribFitting/generateHypotheses'...
%     ,'/home/sameig/codes/ribFitting/sge'...
%     ,'/home/sameig/codes/ribFitting/appearanceModeling/building_classifier'...
%     ,'/home/sameig/codes/vertebrae'...
 });


m=57;
k=3;
%         createTask(j,@testF,1,{});
           createTask(j,@setAngeModulNccFullCycle_2,1,{m,k,0});
     
    submit(j);