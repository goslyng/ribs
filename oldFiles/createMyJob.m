
sched = findResource('scheduler', 'type', 'generic');
% sched = findResource('scheduler', 'type', 'pbspro');


% myCluster = parcluster('local');
% 
% defaultProfile = parallel.defaultClusterProfile
% myCluster = parcluster(defaultProfile);
% 


if (isunix)
   
    set(sched, 'DataLocation', '/usr/biwinas03/scratch-c/sameig/dct-scheduler');
%     set(sched,'ClusterMatlabRoot','/usr/pack/matlab-7.10r2010a-sd')
    set(sched,'ClusterMatlabRoot','/usr/pack/matlab-8.1r2013a-sd')
    
else

    set(sched, 'DataLocation', 'H:\dct-scheduler');
    set(sched,'ClusterMatlabRoot','H:\mvonSiebenthal/matlabcode/')
end
set(sched,'ParallelSubmitFcn',@sgeParallelSubmitFcn)
set(sched,'SubmitFcn',@sgeSubmitFcn)

j = createJob(sched);
set(j,'PathDependencies',{'/home/sameig/codes/ribFitting/'...
    ,'/home/sameig/codes/ribFitting/shapeModeling'...
    ,'/home/sameig/codes/ribFitting/appearanceModeling'...
    ,'/home/sameig/codes/ribFitting/icp'...
    ,'/home/sameig/codes/ribFitting/generateHypotheses'...
    ,'/home/sameig/codes/ribFitting/sge'...
    ,'/home/sameig/codes/ribFitting/appearanceModeling/building_classifier'...
    ,'/home/sameig/codes/vertebrae'...
    ,'/home/sameig/codes/ribFitting/ribFitting'...
 });
% set(j,'PathDependencies',{'/home/sameig/codes/mvonSiebenthal/subscripts/'});
% set(j,'PathDependencies',{'/home/sameig/libsvm-3.12/matlab/'});
% set(jj,'PathDependencies',{'/home/sameig/mvonsieb_reg/bin/'});
