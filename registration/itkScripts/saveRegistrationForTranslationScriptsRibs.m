

function cycleRegPath_r = saveRegistrationForTranslationScriptsRibs(s,params)
    
     
    
    firstCycle = params.okCycles(1);
    lastCycle  = params.okCycles(end);
    cycleRegPath=[params.registrationPath '/scripts/reg_script_ribs' num2str(s) '_'  ];
    params.maskPrefix = [  params.maskPrefix '_rib'];
    params.angleBound=[0  0 0;0 0 0];
    dt=7;
    params.translationBound = [-dt*ones(1,3);dt*ones(1,3)];
    params.registrationPath = [params.registrationPath '/scripts/reg_script_ribs'];
    
    params.outputPrefix = [params.registrationPathLinux '/results/output_rib'];
    
    
    for r = params.ribs
        
        load(params.outputTranslationFile,'initialTranslation','initialRotation');                       
        for cyc = params.okCycles
            
          
            numStates = params.cycleinfo.nStates(cyc);
            params.movingImagePrefix = [ params.stacksPath params.cycPrefix num2str(cyc) '_'];
            
            
            writeScriptFile(s,cyc,r,numStates,[0 0 0],...
            initialTranslation(:,cyc),[0 0 0],params);
        end
        cycleRegPath_r = [cycleRegPath num2str(r) '_'];
        writeRegistrationRotationSungrid(firstCycle,lastCycle,cycleRegPath_r,params.registrationTransRibs{r});
    end
    
