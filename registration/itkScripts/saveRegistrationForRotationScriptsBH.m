
function cmnds = saveRegistrationForRotationScriptsBH(s,params,fitted)


    cmnds='';
    if fitted
        fitTag='fitted';
        params.maskPrefix=[params.maskPrefix 'fitted'];
    else
        fitTag='';

    end

        dataPathUnix = params.dataPathUnix;
%         cycleRegPath=[params.registrationPath '/scripts/reg_script' num2str(s) '_' fitTag  ];
        outputPrefix = [params.registrationPathLinux '/results/output' num2str(s)  '_BH' fitTag];
        registrationPath = [params.registrationPath '/scripts/reg_script' num2str(s) '_BH' fitTag];
%         cycleRegPathLinux=[params.registrationPathLinux '/scripts/reg_script'  num2str(s) '_BH'  fitTag];
        params.movingImagePrefix = [params.subjectPathLinux '/masterframes/inhMaster_rs'];

        for r = params.ribs

            ExhRibPath = [dataPathUnix num2str(s) '/ribs/RibRight' params.stateMiddleFix 'New' num2str(r)];
            pExh = readVTKPolyDataPoints(ExhRibPath);

            c = pExh(:,1);
            params.fixedImage = [params.subjectPathLinux '/masterframes/exhMaster_rs.img'];
            params.outputPrefix =[outputPrefix  num2str(r)];
            params.registrationPath= [ registrationPath  num2str(r)  ];
            params.maskFile =[params.maskPrefix num2str(r)];

            writeScriptFile(0,c,[0 0 0],[0 0 0],params,0);

        end
        params.registrationPath =registrationPath;
        writeRegistrationRotationSungridBH(params,[registrationPath '.sh'])
    %      system(['qsub ' cycleRegPath 'sg.sh'])
        cmnds = sprintf([cmnds 'qsub ' registrationPath '.sh\n']);

end
