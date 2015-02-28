
function filePath = writeScriptInitialTranslationFile(s,params)



lines={

'excecutable=/home/sameig/itk-projects/registration3DMasked/ImageRegistration3DMaskedEulerParticleSwarm'
['fixedImage='  params.fixedImage]
['movingImage=' params.stacksPath params.cycPrefix '${1}_${2}']
['maskImage=' params.subjectPath '/masterframes/spine.hdr']

'firstState=0' 
'numStates=0'
' ' 

  
['centerRotationX=' num2str(params.meanP(1))]
' '
['centerRotationY=' num2str(params.meanP(2))]
' '
['centerRotationZ=' num2str(params.meanP(3))]  
' '

'initialAngleX=0'
'initialAngleY=0'
'initialAngleZ=0'
'  '
'initialTranslationX=0'
'initialTranslationY=0' 
'initialTranslationZ=0' 
'  '
'angleScale=1'
['translationScale=' num2str(params.translationScale)]
' '
['AngleXLowerBound=' num2str(params.angleBoundSpine(1,1))]
['AngleXUpperBound=' num2str(params.angleBoundSpine(2,1))]
' '
['AngleYLowerBound=' num2str(params.angleBoundSpine(1,2))]
['AngleYUpperBound=' num2str(params.angleBoundSpine(2,2))]
'  '
['AngleZLowerBound=' num2str(params.angleBoundSpine(1,3))]
['AngleZUpperBound=' num2str(params.angleBoundSpine(2,3))]
'  '
['TranslataionXLowerBound=' num2str(params.translationBoundSpine(1,1))]
['TranslataionXUpperBound=' num2str(params.translationBoundSpine(2,1))]
' '
['TranslataionYLowerBound=' num2str(params.translationBoundSpine(1,2))]
['TranslataionYUpperBound=' num2str(params.translationBoundSpine(2,2))]
' '
['TranslataionZLowerBound=' num2str(params.translationBoundSpine(1,3))]
['TranslataionZUpperBound=' num2str(params.translationBoundSpine(2,3))]
' '
'maxNumIteration=100'
% ['outputFile=' registrationPath 'output_spine_' num2str(s) '_' num2str(cyc)]
['outputFile=' params.registrationPath '/results/output_spine_' num2str(s) '_${1}' '_${2}']
'commands="${excecutable} ${fixedImage}  ${maskImage}  ${movingImage}  ${firstState} ${numStates} ${centerRotationX} ${centerRotationY} ${centerRotationZ} ${initialAngleX} ${initialAngleY} ${initialAngleZ} ${initialTranslationX} ${initialTranslationY} ${initialTranslationZ} ${angleScale} ${translationScale}  ${AngleXLowerBound} ${AngleXUpperBound} ${AngleYLowerBound} ${AngleYUpperBound} ${AngleZLowerBound} ${AngleZUpperBound}  ${TranslataionXLowerBound}   ${TranslataionXUpperBound}   ${TranslataionYLowerBound}   ${TranslataionYUpperBound}   ${TranslataionZLowerBound}   ${TranslataionZUpperBound} ${maxNumIteration}  ${outputFile} "'
'echo $commands'
'$commands'
};

% filePath=[registrationPath 'reg' num2str(s) '_' num2str(cyc) '.sh'];
if ~(exist([params.registrationPath '/scripts/'],'dir'))
    mkdir([params.registrationPath '/scripts/']);
end
filePath=[params.registrationPath  '.sh'];

fid=fopen(filePath,'w');
for i=1:length(lines)
    fprintf(fid,lines{i});
    fprintf(fid,'\n');
end




fclose(fid);

unix(['chmod 755 ' filePath]);




