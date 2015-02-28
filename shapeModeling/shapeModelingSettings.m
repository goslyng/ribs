
%% Parameter Settings

ctSubjects=setdiff(1:20,[]);%[2:15 17:18 20];%

ctRibNumbers = 1:24;%3:22;
numSubjects = length(ctSubjects); 

ct_ap = [-1   0  0];
ct_is = [ 0   0 -1];
ct_lr = [ 0  -1  0];

rightRibs = 1:2:24;
testRibs = rightRibs(7:10);
displayImages=1;

nCompsAngle = 5;
nCompsShape = 6;
% nCompsRibCage = 6;
nCompsRibCage = 2;
nCompsLength = 2;

numKnotsVertebra = 100;

%Angle Point Reparameterization
numKnots1=20;
numKnots2=80;

%% Path Settings

ribDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';

if isunix
    codePath = '/home/sameig/codes/';
    ribDataPath = ribDataPathUnix;
else
    codePath = 'H:\codes\';
    ribDataPath = 'O:\Bjorn_CT\';
end

ribFolder = 'newRibs/newRib';% 'ribs/ribs'

for s = ctSubjects
    
        subjectDataPath{s} =[ ribDataPath 'v' num2str(s) '/'];
        vertebPath{s} = [ subjectDataPath{s} 'ribs/vertebrae/'];

end

ribDataPath = [ribDataPath 'new_'];

codePathSkeleton1=[codePath 'cloudcontr_2_0/matlab/'];
codePathSkeleton2=[codePath 'skeleton/'];

codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathRancac = [codePath 'ransac'];
codeLsqPath = [codePath 'mvonSiebenthal/leastSquaresFitting'];

ribShapeModelPath = [ribDataPath 'ribShapeModel'];
ribShapeCoefModelsPath =[ribDataPath 'ribShapeCoefModels'];
ribCageLengthModelPath = [ribDataPath 'ribCageLengthModel'];
ribAngleModelCTPath = [ribDataPath 'ribAngleModelCT'];
ribcageModelPath = [ribDataPath 'ribcageModel'];
ribcageWOAngleModelPath = [ribDataPath 'ribcageWOAngleModel'];

subjectsPath = [ribDataPath 'subjects'];

addpath(codePath);
addpath(genpath(codePathSkeleton1));
addpath(genpath(codePathSkeleton2));
addpath(codePathRancac);
addpath(codePathVTK);
addpath(codeLsqPath);


