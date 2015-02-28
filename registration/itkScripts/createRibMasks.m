

function createRibMasks(m,fitted,params,displayTag)

% debugText='hi';

if ~(exist('displayTag','var'))
    displayTag='';
end
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
%     imExh_.stack.par.thickness =2.5;
    imExh_.stack.par.thickness =5;

else
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster7_unmasked_uncropped.mat']);
    
end


if fitted

  tag = 'RibFittedExhRight';
  else
    
    if m>=60
        tag = 'RibRightExhNew';
    else
        tag = 'RibRightNew';

    end
    
end

subjectDataPath = [dataPath num2str(m) '/'];

ribDir =[subjectDataPath 'ribs/' ];


if (s==60)
    ribPrefix = '/usr/biwinas03/scratch-c/sameig/Ribs/res_GA_9_3_60_r';
else
    ribPrefix = [ribDir tag];
end

for i= 1:12
    try
    if fitted
        ribiPath = [ribPrefix num2str(i)];
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
  



%%
        
moving = imExh_.stack.im;
res_1(1,1) = imExh_.stack.par.inplane;
res_1(2,1) = imExh_.stack.par.inplane;
res_1(3,1) = imExh_.stack.par.thickness;




%%
 
% r_h2 = 30/2 ; 
% r_w2 = 20/2;
% 
% x_range = ceil(-r_w2/res_1(2)):floor(r_w2/res_1(2));
% y_range = ceil(-r_h2/res_1(1)):floor(r_h2/res_1(1));
% z_range = ceil(-r_w2/res_1(3)):floor(r_w2/res_1(3));
mask.par = imExh_.stack.par;
r_h2= params.r_h2;
r_w2= params.r_w2;
% r_b2 = 1;

for r= params.ribs
    
    moveing_mask = createMask(ribsExh{r},moving,res_1,r_h2,r_w2);
%  
%     moveing_mask = zeros(size(moving));
%     NCS = findRotaionMatrixNew(ribsExh{r});
%     x = findEulerO(NCS',[1 3 2],1);
% % pt=[];
%     for i=1:100
%       
%         pnt = ribsExh{r}(:,i)./res_1;
%         pnt(2,1) = size(moveing_mask,1) -pnt(2);
%         pnt(3,1) = size(moveing_mask,3) -pnt(3);
%         pnt_= floor(pnt);
%         for ii= y_range + pnt_(2)
%             for jj=x_range + pnt_(1)
%                 for kk=z_range + pnt_(3)
%                     if  all ((size(moving) - [ii jj kk] )>=0) &&  all( [ii jj kk] >0)
%                         vec_in_mm  = ([ jj; ii; kk] - pnt ).*res_1 ;
%                         if i>=40
%                             vec_inNCS=NCS'*[vec_in_mm(1);-vec_in_mm(2);-vec_in_mm(3)];
%                         elseif (i<=20)
%                             vec_inNCS=vec_in_mm;
%                         else
%                             R = findEulerO([(-20+i)/20*x(1) (-20+i)/20*x(2) (-20+i)/20*x(3)],[1 3 2],0);
%                             vec_inNCS=R*[vec_in_mm(1);-vec_in_mm(2);-vec_in_mm(3)];
% 
%                         end
%                         vec_normalized = vec_inNCS./[r_w2 ;r_h2 ;r_w2];
%                    
%                         dist = sum(vec_normalized.^2);
%                         if (dist<1)
% %                             pt=[pt [jj;ii;kk]];
%                             moveing_mask(ii,jj,kk) = 1;
%                         end
%                         
%                     end
%                 end
%             end
%         end
% 
% 
%     end

    if (fitted)
        fitTag='fitted';
    else
        fitTag='';
    end
    saveAnlz(moveing_mask,mask.par,[dataPath num2str(m)  '/masterframes/mask' fitTag displayTag num2str(r) ],0,3);

end
