
for s = allMriSubjects

    okCycles{s}=1:100;

    params{s}.cycleinfoPath = [christinePrefix num2str(s)  '/allcycles_nrig10_masked.mat'];
    load(params{s}.cycleinfoPath,'cycleinfo');
    params{s}.cycleinfo = cycleinfo;
    params{s}.subjectPath =[dataPath  num2str(s) ];
    params{s}.subjectPathLinux =[dataPathLinux  num2str(s) ];
    
    
    if ismember(s, [18 19 23 24 25 26 27 28 31 32 33 34])
        params{s}.stacksPath = [christinePrefix num2str(s) '/stacks_uncropped/' ] ;
    else
    	params{s}.stacksPath = [christinePrefix num2str(s) '/stacks/' ] ;

%         params{s}.stacksPath = [params{s}.subjectPath '/stacks/' ] ;

    end
    
    params{s}.dataPathUnix = dataPath;
    params{s}.registrationPath = [dataPath num2str(s) '/rib_registration/'];
    params{s}.registrationPathLinux = ['/home/sameig/M/dataset' num2str(s) '/rib_registration/'];

    params{s}.angleBoundSpine = [0 0 0 ;0 0 0];
    params{s}.translationBoundSpine = [ -20 -50 -20; 20 50 20 ] ;
    
    
    params{s}.angleBound = [-0.1 -0.1 -0.1; 0.1 0.1 0.1];
    params{s}.translationBound = zeros(2,3);%[ -2 -2 -2; 2 2 2] ;    
    params{s}.centerBound = 5  * [-1 -1 -1 ;1 1 1];
    params{s}.translationScale = 0.01;
    params{s}.outputTranslationFile=[ params{s}.registrationPath 'results/translation_spine_' num2str(s)  ];
    
	if s >=60
        params{s}.stateMiddleFix ='Exh';
        params{s}.fixedImage= [params{s}.subjectPathLinux '/masterframes/exhMaster_rs_padded2.hdr'];
        params{s}.cycPrefix = 'cyc_';
        params{s}.maskPrefix = [params{s}.subjectPathLinux  '/masterframes/mask'];
        params{s}.ribPath =[ params{s}.subjectPath  '/ribs/RibRightExhNew' ];

    else
        params{s}.stateMiddleFix =''; 
        params{s}.fixedImage= [params{s}.subjectPathLinux '/masterframes/exhMaster7_unmasked_uncropped.hdr'];
        
%         if (ismember(s,[50 51 52 53 54 58]))
%             params{s}.cycPrefix = 'original_5_cyc_';
%         else
        params{s}.cycPrefix = 'cyc_';
        params{s}.maskPrefix = [params{s}.subjectPathLinux  '/masterframes/mask']
        params{s}.ribPath =[ params{s}.subjectPath  '/ribs/RibRightNew' ]
%         end

    end
    
    params{s}.okCycles = okCycles{s};
    params{s}.maxCycles = 300;
    params{s}.paramConvTol = 0.1;
    params{s}.functionConvTol = 0.1;
    params{s}.populationSize = 1000;
    params{s}.ribs = 7:10;
    params{s}.r_h2 = 22/2; 
    params{s}.r_w2 = 8/2;
    a = avw_img_read([params{s}.subjectPath '/masterframes/spine']);
    s_=[];
    for z=1:size(a.img,3)
        [x y ]=find(a.img(:,:,z)==1);
        s_=[s_ [x' ;y';z*ones(1,length(x))]];
    end
    params{s}.meanP(:,1) = mean(s_').*a.hdr.dime.pixdim(2:4);
    for r = params{s}.ribs
        params{s}.registrationRotation{r}=[params{s}.registrationPath '/scripts/reg_rotation_sungrid' num2str(s) '_' num2str(r) '.sh'];
        params{s}.registrationTransRibs{r}=[params{s}.registrationPath '/scripts/reg_ribTrans_sungrid' num2str(s) '_' num2str(r) '.sh'];

        
        
        params{s}.registrationRotation_missed{r} = [params{s}.registrationPath '/scripts/reg_rotation_sungrid_missed' num2str(s) '_' num2str(r) '.sh'];;
    end
   params{s}.o =[ 3 1 2];         
end
params{60}.ribs=8:10
params{56}.okCycles = 100:200;
params{24}.okCycles = 200:300;
params{25}.okCycles = 43:143;