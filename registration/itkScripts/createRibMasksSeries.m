

function createRibMasksSeries(m,params,fitted,ribs,okCycles,volume)

% debugText='hi';

if ~(exist('fitted','var'))
    fitted=1;
end

inh=0;
runFittingSettings;

pathSettings;
addpath([codePath '//mvonSiebenthal/mri_toolbox_v1.5/']) 




%%



if (m >= 60 )
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster.mat']);
    imExh_.stack.par.thickness =2.5;

else
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster7_unmasked_uncropped.mat']);
    
end


if fitted

  tag = 'RibFittedRight';
  else
    
    if m>=60
        tag = 'RibRightExhNew';
    else
        tag = 'RibRightNew';

    end
    
end

subjectDataPath = [dataPath num2str(m) '/'];

ribDir =[subjectDataPath 'ribs/' ];

for i= 1:12
    try
    if fitted
        ribiPath = ['/usr/biwinas03/scratch-c/sameig/Ribs/res_GA_9_3_60_r' num2str(i)];
        ribsExh{i} = readVTKPolyDataPoints(ribiPath);

    else
            ribiPath = [ribDir tag num2str(i)];
            ribsExh{i} = readVTKPolyDataPoints(ribiPath);
    end
    catch
        m
        i
    end
end
  
load([dataPath num2str(m) '/motionfields/ribsMotion'])
load(params.outputTranslationFile,'initialTranslation','initialRotation','t_','moved_center');

%%
        
moving = imExh_.stack.im;
res_1(1,1) = imExh_.stack.par.inplane;
res_1(2,1) = imExh_.stack.par.inplane;
res_1(3,1) = imExh_.stack.par.thickness;




%%
 

x_range = ceil(-11/res_1(2)):floor(11/res_1(2));
y_range = ceil(-11/res_1(1)):floor(11/res_1(1));
z_range = floor(-2.5/res_1(3)):ceil(2.5/res_1(3));
mask.par = imExh_.stack.par;

r_h2 = 22/2 ; 
r_w2 = 8/2;

mkdir([dataPath num2str(m)  '/mask_series/']);
for r=ribs
    mkdir([dataPath num2str(m)  '/mask_series/mask' num2str(r)]);
    [ribMeshPts, ribMeshPolygons]= readVTKPolyData([dataPath num2str(m) '/masterframes/mask' num2str(r)]);

    j=0;
    points = ribsExh{r};
    for cyc = okCycles %for a =1 :timeL
%         points = ribMeshPts;
        points = [-ribMeshPts(1,:);ribMeshPts(3,:);ribMeshPts(2,:)];
%         moveing_mask = zeros(size(moving));
        firstPointRep =repmat(ribsExh{r}(:,1)  ,1,size(points,2));%moved_center{r}(:,cyc)
        ribPoints = points -  firstPointRep ;
        for a=1: size(angles{r}{cyc},2)
            
            j=j+1;
            R = findEulerO( angles{r}{cyc}(:,a),params.o,0);
            ribsExh_rotated = R * ribPoints + firstPointRep + repmat(trans{r}{cyc}(:,a),1,size(points,2)) ;%
%             writeVTKPolyDataPoints([dataPath num2str(m)  '/mask_series/rib' num2str(r) '_' num2str(j)] ,ribsExh_rotated);
            writeVTKPolyData([dataPath num2str(m)  '/mask_series/rib' num2str(r) '_' num2str(j)] ,ribsExh_rotated,ribMeshPolygons);

            if volume
%                 for i=1:100
% 
%                     pnt = ribsExh_rotated(:,i)./res_1;
%                     pnt(2,1) = size(moveing_mask,1) -pnt(2);
%                     pnt(3,1) = size(moveing_mask,3) -pnt(3);
%                     pnt_= floor(pnt);
%                     for ii= y_range + pnt_(2)
%                         for jj=x_range + pnt_(1)
%                             for kk=z_range + pnt_(3)
%                                 if  all ((size(moving) - [ii jj kk] )>=0) &&  all( [ii jj kk] >0)
% 
%                                     vec_in_mm  = ([ jj; ii; kk] - pnt ).*res_1 ;
%                                     vec_normalized = vec_in_mm./[r_w2 ;r_h2 ;r_w2];
%                                     dist = sum(vec_normalized.^2);
%                                     if (dist<=1)
%                                         moveing_mask(ii,jj,kk) = 1;
%                                     end
% 
%                                 end
%                             end
%                         end
%                     end
% 
% 
%                 end
                moveing_mask = createMask(ribsExh_rotated,moving,res_1,r_h2,r_w2);

                saveAnlz(moveing_mask,mask.par,[dataPath num2str(m)  '/mask_series/mask' num2str(r) '/time' num2str(j)],0,3);
            end
        end
    end

end
