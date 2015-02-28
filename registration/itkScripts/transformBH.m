

function [err_ribs1 lenError outOfPlaneError1 angls_bucket_pump] = transformBH(m,params,fitted,ribs)

% debugText='hi';

if ~(exist('fitted','var'))
    fitted=1;
end

inh=0;
runFittingSettings;

pathSettings;
addpath([codePath '//mvonSiebenthal/mri_toolbox_v1.5/']) 

writeRib=1;
displayImages=1;


%%



if (m >= 60 )
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster.mat']);
    imExh_.stack.par.thickness =2.5;

else
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster7_unmasked_uncropped.mat']);
    
end

fitTag='';
if fitted
 fitTag='fitted';
  tag = 'RibFittedExhRight';
  else
    
    if m>=60
        tag = 'RibRightExhNew';
    else
        tag = 'RibRightNew';

    end
    
end
params.outputFile = [params.registrationPath 'results/output' num2str(m) '_BH' fitTag];

subjectDataPath = [dataPath num2str(m) '/'];

ribDir =[subjectDataPath 'ribs/' ];

for i= 1:12
    try
        
        ribiPath = [ribDir tag num2str(i)];
        ribsExh{i} = readVTKPolyDataPoints(ribiPath);
        
              
    catch
        m
        i
    end
end
  
for i= 1:12
    try
        
        tag = 'RibRightInhNew';

        ribiPath = [ribDir tag num2str(i)];
        ribsInh{i} = readVTKPolyDataPoints(ribiPath);
        
        
    catch
        m
        i
    end
end
  

%%



for r=ribs
    
    outputFile=[ params.outputFile num2str(r) '.txt'];
%     outputFile=['/usr/biwinas03/scratch-c/sameig/Data/dataset' num2str(m) '/rib_registration/results/output' num2str(m) '_' num2str(r) '_0.txt'];
    fid = fopen(outputFile);
    [angles(:,r), trans(:,r), cntr(:,r)] = readRegResults(fid);


    fclose(fid);

end



    testRibPath = [params.subjectPath '/stacks_gt/rib' num2str(r) '_full'] 
    sp_temp = readVTKPolyDataPoints(testRibPath );
%%
%  angles(3,:)= - angles(3,:);
%   angles(2,:)= - angles(2,:);

for r=ribs

    firstPointRep =  repmat(cntr(:,r) ,1,100);%  repmat(ribsExh{r}(:,1) ,1,100);%
    ribPoints = ribsExh{r} -  firstPointRep ;
%     angles = [angles(1) angles(2) -angles(3)]
    R = findEulerO(angles(:,r),params.o,0);
    ribsExh_rotated = R * ribPoints + firstPointRep + repmat(trans(:,r),1,100) ;%
    [~,~,err_ribs1{r},lenError(r),outOfPlaneError1{r}]= computeErorr({ribsExh_rotated},ribsInh(r),1,settings,1,1,1);

    rot_mat = findRotaionMatrixNew(ribsExh{r});
    angls_bucket_pump(r,:)=findEulerO(rot_mat'*R*rot_mat,[1 3  2 ],1);
    if writeRib
        writeVTKPolyDataPoints([dataPath num2str(m)  '/rib' num2str(r) '_BH' ] ,ribsExh_rotated);
    end
    if displayImages
        figure;plot33(ribsExh_rotated,'b.',[1 3 2]);
        title([num2str(m) '  ' num2str(r)]);
        hold on;
        plot33(ribsInh{r},'r.',[1 3 2 ]);
        plot33(ribsExh{r},'g.',[1 3 2 ]);
        axis equal
    end

    vec = vrrotvec(ribsExh{r}(:,80) - ribsExh{r}(:,1),ribsInh{r}(:,80) - ribsInh{r}(:,1));
    M__ = vrrotvec2mat(vec);
    [a b c]=findEulerO(M__,[1 3 2],1)



end
