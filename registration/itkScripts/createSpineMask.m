

function createSpineMask(m,fitted)

% debugText='hi';

if ~(exist('fitted','var'))
    fitted=1;
end

runFittingSettings;
inh=0;
pathSettings;
addpath([codePath '//mvonSiebenthal/mri_toolbox_v1.5/']) 

%%



if (m >= 60 )
    
%     imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster.mat']);
%     imExh_.stack.par.thickness =2.5;

% else
    
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

        ribiPath = [ribDir tag num2str(i)];
        ribsExh{i} = readVTKPolyDataPoints(ribiPath);
%             ribsExh{i} = transCoord(pts_mri,ap,is,lr);
    catch
        m
        i
    end
end
  



%%
        
moving = imExh_.stack.im;

res_1(1,1) = imExh_.stack.par.inplane;
res_1(2,1) = imExh_.stack.par.inplane;
res_1(3,1) = imExh_.stack.par.thickness;



%%
 

for r=7:10

    pp{r} = ribsExh{r};
    
    pp{r}(2,:) = size(moving,2)*res_1(2) -pp{r}(2,:);
    pp{r}(3,:) = size(moving,3)*res_1(3) -pp{r}(3,:);
   
end

numFirstPointsToCreateSpineMask=5;
p=[];
    for i=1:numFirstPointsToCreateSpineMask
        for r=7:9
            dt = (pp{r+1}(:,i) -pp{r}(:,i) )/20;
            newPoints = repmat(pp{r}(:,i),1,20) + (repmat(1:20,3,1).*repmat(dt,1,20));
            p=[p newPoints];
        end
    end
%         p=ceil(p);
%         %%
% figure
% 
% for z=50:70
%     hold off
% imshow(moving(:,:,z),[]);hold on; plot33(p(:,find(abs(p(3,:)-z)<1)),'b.')
% pause(2);
% end
%%
% % moveing_mask = zeros(size(moving).*res_1');
%   
% 
% for i=1:size(p,2)
%     for ii=-11:11
%         for jj=-11:11
%             for kk=-20:0
%                 try
%                     pnt = floor(p(:,i)+ [jj;ii;kk]);
%                     moveing_mask(pnt(2),pnt(1),pnt(3)) = 1;
% 
%                 catch
%                 end
%             end
%         end
%     end
% end
% 
% mask.par = imExh_.stack.par;
% mask.par.inplane = 1;
% mask.par.thickness =1;
% mask.par.w = size(moveing_mask,2);
% mask.par.h = size(moveing_mask,1);
% mask.par.nDats = size(moveing_mask,3);
% 
% 
% for r=7:10
%     moveing_mask = zeros(size(moving).*res_1');
%     firstPointRib{r} = ribsExh{r}(:,1);
%     for i=1:100
% 
%         for ii=-11:11
%             for jj=-11:11
%                 for kk=-2:2
%                     try
%                         pnt = ribsExh{r}(:,i);
% 
%                         pnt(2,1) = size(moveing_mask,2) -pnt(2);
%                         pnt(3,1) = size(moveing_mask,3) -pnt(3);
%     
%     
%                         pnt = floor(pnt+ [jj;ii;kk]);
%                         moveing_mask(pnt(2),pnt(1),pnt(3)) = 1;
%                     catch
%                         ii
%                         jj
%                         kk
%                     end
%                 end
%             end
%         end
% 
% 
%     end
moveing_mask = zeros(size(moving));
Qy_range = ceil(-11/res_1(1)):floor(11/res_1(1));
x_range = ceil(-11/res_1(2)):floor(11/res_1(2));
z_range = floor(-20/res_1(3)):0;
for i=1:size(p,2)
        
    pnt = ceil(p(:,i)./res_1);
    for ii= y_range + pnt(2)
        for jj= x_range + pnt(1)
            for kk= z_range + pnt(3)
                
                if  all ((size(moving) - [ii jj kk] )>=0) &&  all( [ii jj kk] >0)
                    moveing_mask(ii,jj,kk) = 1;

                end
            end
        end
    end
end

mask.par = imExh_.stack.par;
% mask.par.inplane = 1;
% mask.par.thickness =1;
% mask.par.w = size(moveing_mask,2);
% mask.par.h = size(moveing_mask,1);
% mask.par.nDats = size(moveing_mask,3);




saveAnlz(moveing_mask,mask.par,[dataPath num2str(m)  '/masterframes/spine' ],0,3);

end
