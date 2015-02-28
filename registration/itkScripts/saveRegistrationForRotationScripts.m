
function saveRegistrationForRotationScripts(s,params)


    dataPathUnix = params.dataPathUnix;
    firstCycle = params.okCycles(1);
    lastCycle  = params.okCycles(end);
    cycleRegPath=[params.registrationPath '/scripts/reg_script' num2str(s) '_'  ];
    
    registrationPath = [params.registrationPath '/scripts/reg_script'];

   
    outputPrefix = [params.registrationPathLinux '/results/output'];
    
    for r = params.ribs

        ExhRibPath = [dataPathUnix num2str(s) '/ribs/RibRight' params.stateMiddleFix 'New' num2str(r)];
        pExh = readVTKPolyDataPoints(ExhRibPath);
        load(params.outputTranslationFile,'initialTranslation','initialRotation');                       
    
        c = pExh(:,1);
        for cyc = params.okCycles %1 : params.cycleinfo.nCycs
            
        	dt = initialTranslation(:,cyc);
            R = findEulerO(initialRotation(:,cyc),params.o,0);
            moved_center{r}(:,cyc) = (R * (c - params.meanP)) + params.meanP  + dt ; % a rotation around the center of rotation  - first position + displacement 
            t_{r}(:,cyc) = moved_center{r}(:,cyc) - c;
            
            numStates = params.cycleinfo.nStates(cyc);
            
            params.movingImagePrefix = [ params.stacksPath params.cycPrefix num2str(cyc) '_'];
            params.maskFile =[    params.maskPrefix num2str(r)];
            params.registrationPath= [ registrationPath  num2str(s) '_' num2str(r) '_' num2str(cyc)];
            params.outputPrefix =[outputPrefix num2str(s)  '_' num2str(r)  '_' num2str(cyc)];
            
            
            writeScriptFile(numStates,c,t_{r}(:,cyc),initialRotation(:,cyc),params);

        end
        cycleRegPath_r = [cycleRegPath num2str(r) '_'];
        writeRegistrationRotationSungrid(firstCycle,lastCycle,cycleRegPath_r,params.registrationRotation{r});
    end
    
    save(params.outputTranslationFile,'initialTranslation','initialRotation','t_','moved_center');

end
