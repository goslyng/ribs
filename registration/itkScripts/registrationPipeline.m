clear all;
dataPathLinux = '/usr/biwinas03/scratch-c/sameig/Data/dataset';

if isunix()
    pathPrefix = '/home/sameig/';
    christinePrefix = '/usr/biwinas03/scratch-c/tannerch/FUSIMO/ETHliver/dataset';
    dataPath = dataPathLinux;
else
    pathPrefix = 'H:\';
    dataPath = 'M:/dataset';
    christinePrefix = 'Q:\dataset';
end

addpath([pathPrefix '/codes/ribFitting/oldFiles/'])
addpath([pathPrefix '/codes/ribFitting/'])

runFittingSettings;

unix('source /home/sgeadmin/BIWICELL/common/settings.sh');

addpath([pathPrefix 'codes/ribFitting/registration/itkScripts/']);
addpath([pathPrefix 'codes']);
addpath([pathPrefix 'codes/ribFitting/shapeModeling']);
addpath([pathPrefix '/codes/mvonSiebenthal/mri_toolbox_v1.5/']);


%%

 allMriSubjects= [18 19 23 24 25 26 27 28 31 32 33 34 50   51    52    53    54   56    57    58    59  60     63    64     66];
 
 config_registeration;


   %%
mriSubjects = [18 19 23 24 25 26 27 28 31 33:34 ];% 23 24 25 26 27 28 31 33:34 ]
% 18 19 23 24 25 26 27 28 31 33:34 
% mriSubjects=[   60     63    64     66];
% mriSubjects=[ 31 33:34  50   51    52    53    54   56    57    58    59    ];%60    61    63    64     66];

% mriSubjects= [  18 19 23 24 25];%][26 27 28 31 32 33 34];%;%


%% Create masks rib and spine masks for registeration 
% the spine mask can be made using the first points of the ribs
% with the function createRibMasks(s,0,params{s});
% however, it is not so accurate, therefore, I manually create spine masks
% using Snap, but it needs to be processed using function createSpineMaskSnap(s,0); 


for s = mriSubjects

%     createSpineMaskSnap(s,0); 
%     createRibMasksTrans(s,0);
    createRibMasks(s,0,params{s});
    
end

%% Save & Run Translation Scripts


for s = mriSubjects
    saveRegistrationForTranslationScripts(s,params{s});
end

%% Save & Run Translation Scripts

for s = mriSubjects

    saveRegistrationForTranslationScriptsRibs(s,params{s});

end


for s = mriSubjects
 
    for r=7:10
        
        unix(['qsub ' params{s}.registrationTransRibs{r}]);
%         fprintf(1,['qsub ' params{s}.registrationRotation{r} '\n']);

    end
end

for s = mriSubjects
    
    extractTransCycRibs(s,params{s},okCycles{s},[]);%,,'bigMask');
    
end

%% Load and save the rigid transformation of the exhale states

for s = mriSubjects
  s   
    extractTranslationCyc(s,params{s});
    
end
% 
% corruptCycles{18} = 14;
% 
% editTranslation(s,params{s},corruptCycles{s})
% 
% % 56 57 58 59
% corruptCycles{25}=[52 53 70 71 75 77 78]
% corruptCycles{66} = [6 42 56 76]
% corruptCycles{57} = [3 7 20 26 45]
% 28 and 27 are too jaggy
%%  Save Registration Scripts for Extracting Rotation

for s = mriSubjects
 
    saveRegistrationForRotationScripts(s,params{s});
    
end

for s = mriSubjects
   
    for r=7:10
        
        unix(['qsub ' params{s}.registrationRotation{r}]);
%         fprintf(1,['qsub ' params{s}.registrationRotation{r} '\n']);
    end
end
%% Load the results
for s = mriSubjects
    
    extractRotationCyc(s,params{s},[]);%,,'bigMask');
    
end

for s = mriSubjects
    % Compute the Position of the ribs points from the rotation matrices
    [params{s}.missedCycs, params{s}.err_cyc_states, params{s}.err_initial]= computeP(s,params{s},[]);
end
%% Save Registration Scripts for Extracting Rotation (for missed cycles)

for s = mriSubjects
%     params{s}.missedCycs = error_{s};
    saveRegistrationForRotationScriptsMissedCycles(s,params{s});

end

for s = mriSubjects
    
    for r=params{s}.ribs
    
        if (~isempty(params{s}.missedCycs{r}))

            unix(['qsub ' params{s}.registrationRotation_missed{r}]);
%                 fprintf(1,['qsub ' params{s}.registrationRotation_missed{r} '\n']);
        end
    end
end

%% This function is for registering BH images of 60s
commands= [];
fitted=1;

for s = mriSubjects

    params{s}.angleBound = [-0.1 -0.1 -0.1; 0.1 0.1 0.1];
    params{s}.translationBound = zeros(2,3);% [ -2 -2 -2 ; 2 2 2 ];

    commands_ = saveRegistrationForRotationScriptsBH(s,params{s},fitted);
    commands= [commands commands_];
end

for s = mriSubjects
    transformBH(s,params{s},1,8:10)
end


 