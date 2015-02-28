
function  writeScriptFile(numStates,c,...
    initialTranslation,initialRotation,params,firstState)

if ~exist('firstState','var')
    firstState=1;
end

% movingImagePrefix = ['../stacks/cyc_${1}_'];

lines={

'excecutable=/home/sameig/itk-projects/registration3DMasked/ImageRegistration3DMaskedEulerParticleSwarm'

['fixedImage='  params.fixedImage]
['movingImage=' params.movingImagePrefix]
['maskImage=' params.maskFile '.hdr']
% ['maskImage=' subjectPath 'mask${1}.hdr']

['firstState=' num2str(firstState) ]
['numStates=' num2str(numStates)]
' ' 

  
['centerRotationX=' num2str(c(1)) ]
['centerRotationY=' num2str(c(2)) ]
['centerRotationZ=' num2str(c(3)) ]
' '

['initialAngleX=' num2str(initialRotation(1))]
['initialAngleY=' num2str(initialRotation(2))]
['initialAngleZ=' num2str(initialRotation(3))]

'  '
['initialTranslationX=' num2str(initialTranslation(1))]
['initialTranslationY=' num2str(initialTranslation(2))]
['initialTranslationZ=' num2str(initialTranslation(3))]
'  '
'angleScale=1'
'translationScale=0.01'
' '
['AngleXLowerBound=' num2str(params.angleBound(1,1))]
['AngleXUpperBound=' num2str(params.angleBound(2,1))]
' '
['AngleYLowerBound=' num2str(params.angleBound(1,2))]
['AngleYUpperBound=' num2str(params.angleBound(2,2))]
'  '
['AngleZLowerBound=' num2str(params.angleBound(1,3))]
['AngleZUpperBound=' num2str(params.angleBound(2,3))]
'  '
['TranslataionXLowerBound=' num2str(params.translationBound(1,1))]
['TranslataionXUpperBound=' num2str(params.translationBound(2,1))]
' '
['TranslataionYLowerBound=' num2str(params.translationBound(1,2))]
['TranslataionYUpperBound=' num2str(params.translationBound(2,2))]
' '
['TranslataionZLowerBound=' num2str(params.translationBound(1,3))]
['TranslataionZUpperBound=' num2str(params.translationBound(2,3))]
' '
'maxNumIteration=100'
['outputFile=' params.outputPrefix ]
% ['outputFile=' registrationPath 'output' num2str(s) '_' num2str(cyc)  '_${1}' ]
['ParametersConvergenceTolerance='  num2str(params.paramConvTol)]
['FunctionConvergenceTolerance='  num2str(params.functionConvTol)]

['PopulationSize=' num2str(params.populationSize)]

['CenterXLowerBound=' num2str(params.centerBound(1,1))]
['CenterXUpperBound=' num2str(params.centerBound(2,1))]
' '
['CenterYLowerBound=' num2str(params.centerBound(1,2))]
['CenterYUpperBound=' num2str(params.centerBound(2,2))]
' '
['CenterZLowerBound=' num2str(params.centerBound(1,3))]
['CenterZUpperBound=' num2str(params.centerBound(2,3))]


['commands=" ${excecutable} ${fixedImage}  ${maskImage}  ${movingImage} '...
'${firstState} ${numStates} ${centerRotationX} ${centerRotationY} ${centerRotationZ} '...
'${initialAngleX} ${initialAngleY} ${initialAngleZ} ${initialTranslationX} ${initialTranslationY} '...
'${initialTranslationZ} ${angleScale} ${translationScale}  ${AngleXLowerBound} ${AngleXUpperBound} '...
'${AngleYLowerBound} ${AngleYUpperBound} ${AngleZLowerBound} ${AngleZUpperBound}  ${TranslataionXLowerBound} '...
'${TranslataionXUpperBound}   ${TranslataionYLowerBound}   ${TranslataionYUpperBound}   ${TranslataionZLowerBound} '...
'${TranslataionZUpperBound} ${maxNumIteration}  ${outputFile} ${ParametersConvergenceTolerance} '...
'${FunctionConvergenceTolerance} ${PopulationSize} '...
'${CenterXLowerBound} ${CenterXUpperBound} ${CenterYLowerBound}  ' ...
'${CenterYUpperBound} ${CenterZLowerBound} ${CenterZUpperBound} '...
'"']
'echo $commands'
'$commands'
};

filePath=[params.registrationPath  '.sh'];

fid=fopen(filePath,'w');
for i=1:length(lines)
    fprintf(fid,lines{i});
    fprintf(fid,'\n');
end
fclose(fid);

unix(['chmod 755 ' filePath]);




