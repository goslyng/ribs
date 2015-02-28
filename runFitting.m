runFittingSettings;

%%
for m= mriSubjects
    ribFittingMain(m,settings);
end
% displayResults(m)
%%
    
saveHeatMaps(m,settings)

%%
for m=mriSubjects
     
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     ribFit(m)=j;
     createTask(j,@ribFittingMain,0,{m,settings});
     submit(j);
end
%%
for m=mriSubjects
     
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     ribFit(m)=j;
     createTask(j,@ribFittingMain,0,{m});
     submit(j);
end


%%

for m=mriSubjects
     
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     ribFit6(m)=j;
     createTask(j,@ribFittingMainImportance,0,{m});
     submit(j);
end
%%
for m=mriSubjects
     
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     ribFit6(m)=j;
%      createTask(j,@setAngleIndividual,0,{m});
     createTask(j,@setAngeModulOpt_temp,0,{m,0});

     submit(j);
end
%%
for m = mriSubjects
     
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     ribFit6(m)=j;
%      createTask(j,@setAngleIndividual,0,{m});
%      createTask(j,@setAngeModulOpt_verteb2,0,{m,0,0});
     createTask(j,@setAngeModulOpt_iterWF,0,{m,3})
     submit(j);
end
setAngeModulOpt_GA6(50,1,0)
%%
mriSubjects = [18 19 23 24 25 26 27 28 31 33:34 ]
for m = mriSubjects
     
     cd /home/sameig/codes/ribFitting/
     ribFit6{m} = createRibJob(1);
     createTask(ribFit6{m},@setAngeModulOpt_GA6,0,{m,1});
     submit(ribFit6{m});
end
%%
mriSubjects = [18 19 23 24 25 26 27 28 31 33:34 ]
for m = mriSubjects
     
     cd /home/sameig/codes/ribFitting/
     ribFit4{m} = createRibJob(1);
     createTask(ribFit4{m},@setAngeModulOpt_GA4,0,{m,2});
     submit(ribFit4{m});
end
%%
mriSubjects = [18 19 23 24 25 26 27 28 31 33:34 ]
for m = mriSubjects
     m
     cd /home/sameig/codes/ribFitting/
     ribFit2{m} = createRibJob(1);
     createTask(ribFit2{m},@setAngeModulOpt_GA2,0,{m,1});
     submit(ribFit2{m});
end
%%
%%
mriSubjects = [18 19 23 24 25 26 27 28 31 33:34 ]
for s = mriSubjects
     s
     cd /home/sameig/codes/ribFitting/  
     addpath('/home/sameig/codes/ribFitting/registration/')    
     addpath(genpath('./sge'))
     for cyc=1:50
         for r=7:10
         ribFit2{s,r,cyc} = createRibJob(1);
         createTask(ribFit2{s,r,cyc},@setAngeModulNccFullCycle_5,0,{s,r,cyc,params{18}});%});%
         submit(ribFit2{s,r,cyc});
         end
     end
end

%%
for m=mriSubjectsBH
     
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     ribFit6(m)=j;
%      createTask(j,@setAngleIndividual,0,{m});
     createTask(j,@setAngeModulOptInh,0,{m});

     submit(j);
end
%%
compute=1;
fitted=1;
for m=mriSubjectsBH
     
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     ribFit6(m)=j;
%      createTask(j,@setAngleIndividual,0,{m});
     createTask(j,@setAngeModulNcc,0,{m,compute,fitted});

     submit(j);
end
%%

mriSubjects =[57 60 63 64 66];%[56:59];
mriSubjects = 57;
dataPath = '/usr/biwinas01/scratch-g/sameig/Data/dataset';
 for m=mriSubjects
 
     load(['/usr/biwinas01/scratch-g/sameig/Data/dataset' num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');
     cd /home/sameig/codes/ribFitting/
     ribsNCCPath = [dataPath num2str(m) '/ribsNCC' ];
     mkdir(ribsNCCPath);
     clear j;
     j = createRibJob(24);
     for k=1:cycleinfo.nCycs
  
        createTask(j,@setAngeModulNccFullCycle_2,0,{m,k,0});
     end
     submit(j);
end
% 


%%
for m=mriSubjects
     for i=1:4
         cd /home/sameig/codes/ribFitting/
         clear j;
         createMyJob;
         makeTree_11(m,i)=j;
         createTask(j,@mainBuildClassifiers,0,{m,i});
         submit(j);
     end
end
%%
for m=mriSubjects
     for i=1:4
         cd /home/sameig/codes/ribFitting/
         clear j;
         createMyJob;
         makeTree_11(m,i)=j;
         createTask(j,@mainBuildClassifiersBothSides,0,{m,i});
         submit(j);
     end
end
%%


for m=mriSubjects
    
     cd /home/sameig/codes/ribFitting/
     clear j;
     createMyJob;
     heat(m)=j;
     createTask(j,@saveHeatMaps,0,{m,settings});
     submit(j);
end






















