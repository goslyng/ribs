
function  saveRegistrationForRotationScriptsMissedCycles(s,params)


    
    
    load(params.outputTranslationFile,'initialTranslation','initialRotation','t_','moved_center');
    cycleRegPath=[params.registrationPath '/scripts/reg_script' num2str(s) '_'  ];
    registrationPath = [params.registrationPath '/scripts/reg_script'];
    outputPrefix = [params.registrationPathLinux '/results/output'];

    for r = params.ribs

        ExhRibPath = [params.dataPathUnix num2str(s) '/ribs/RibRight' params.stateMiddleFix 'New' num2str(r)];
        pExh = readVTKPolyDataPoints(ExhRibPath);
        load(params.outputTranslationFile,'initialTranslation','initialRotation');                       
    
        c = pExh(:,1);
        
        for cyc = params.missedCycs{r}(:)'

            
            dt = initialTranslation(:,cyc);
            R = findEulerO(initialRotation(:,cyc),params.o,0);
            moved_center{r}(:,cyc) = (R * (c - params.meanP)) + params.meanP  + dt ; % a rotation around the center of rotation  - first position + displacement 
            t_{r}(:,cyc) = moved_center{r}(:,cyc) - c;
            
            fistState = params.err_cyc_states{r}{cyc}(1);
            numStates =    length( params.err_cyc_states{r}{cyc});%params.cycleinfo.nStates(cyc);% 
                    
            params.movingImagePrefix = [ params.stacksPath params.cycPrefix num2str(cyc) '_'];
            params.maskFile =[params.maskPrefix num2str(r)];
            params.registrationPath= [ registrationPath  num2str(s) '_' num2str(r) '_' num2str(cyc)];
            params.outputPrefix =[outputPrefix num2str(s)  '_' num2str(r)  '_' num2str(cyc)];
   
            writeScriptFile(numStates,c,params.err_initial{r}{cyc}(4:6),params.err_initial{r}{cyc}(1:3),params,fistState);
            
        end
        
        
        cycleRegPath_r = [cycleRegPath num2str(r) '_'];
        if (~isempty(params.missedCycs{r}))
            writeRegistrationRotationSungridMissed(params.missedCycs{r},cycleRegPath_r,params.registrationRotation_missed{r});
        end
    end

   

end
