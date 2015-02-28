     
% On the overhead taskbar, go to the environment tab, click on "parallel", 
% then click on "Manage Cluster Profiles", then on "Add", then "Custom" 
% ( Build a custom cluster profile), then under 3RD PARTY CLUSTER PROFILE 
% click on "Generic" , and name it "MyGenericProfile" for example. 

    duration = 2; % the expected duration of the job in hours
    save('/home/$user/duration','duration');
    sched = parcluster('MyGenericProfile');
    set(sched,'ClusterMatlabRoot','/usr/pack/matlab-8.3r2014a-fg')
    set(sched, 'JobStorageLocation', '/home/$user/dstComp');
    set(sched, 'HasSharedFilesystem', true);
    set(sched, 'IndependentSubmitFcn', @independentSubmitFcn);
    set(sched, 'CommunicatingSubmitFcn', @communicatingSubmitFcn);

    j = createJob(sched);
    createTask(j,@myfunction,0,{input1,input2})
    submit(j);