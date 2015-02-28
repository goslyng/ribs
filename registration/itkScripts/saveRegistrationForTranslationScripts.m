

function saveRegistrationForTranslationScripts_rotation(s,params)
    
     
    
    if ~exist(params.registrationPath,'dir')
        mkdir(params.registrationPath);
    end
        registrationPathRes = [params.registrationPath 'results'];

    if ~exist(registrationPathRes,'dir')
        mkdir(registrationPathRes);
    end

    fileSpinePath = writeScriptInitialTranslationFile(s,params);
    registrationPath  = params.registrationPath;
    
     params.movingImagePrefix = [params.stacksPath params.cycPrefix '${1}_${2}'];
     params.maskFile = [params.subjectPath '/masterframes/spine'];
     params.angleBound = params.angleBoundSpine;
     params.translationBound = params.translationBoundSpine;
     params.registrationPath = [registrationPath '/scripts/reg_translation' num2str(s) ];
     params.outputPrefix = [registrationPath '/results/output_spine_' num2str(s) '_${1}' '_${2}'];
     params.centerBound = zeros(2,3);
     
     
     writeScriptFile(0,params.meanP,[0 0 0],[0 0 0],params,0);
            
            
    filePath = writeRegistrationSungrid(s,min(params.cycleinfo.nCycs,params.maxCycles),params.registrationPath,fileSpinePath);

    
    fprintf(1,['qsub ' filePath]);
    unix(['qsub ' filePath]);
    
 
end



