

function createRibMasksTrans(m,fitted)

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
%     imExh_.stack.par.thickness =2.5;
    imExh_.stack.par.thickness =5;

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

        ribiPath = [ribDir tag num2str(i)];
        ribsExh{i} = readVTKPolyDataPoints(ribiPath);
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
 
r_h2 = 22/2 ; 
r_w2p = 20/2;
r_w2n = 8/2;

x_range = ceil(-r_w2n/res_1(2)):floor(r_w2p/res_1(2));
y_range = ceil(-r_h2/res_1(1)):floor(r_h2/res_1(1));
z_range = ceil(-r_w2p/res_1(3)):floor(r_w2n/res_1(3));

mask.par = imExh_.stack.par;


for r=7:10
    moveing_mask = zeros(size(moving));
 
    for i=1:2
      
        pnt = ribsExh{r}(:,i)./res_1;
        pnt(2,1) = size(moveing_mask,1) -pnt(2);
        pnt(3,1) = size(moveing_mask,3) -pnt(3);
        pnt_= floor(pnt);
        for ii= y_range + pnt_(2)
            for jj=x_range + pnt_(1)
                for kk=z_range + pnt_(3)
                    if  all ((size(moving) - [ii jj kk] )>=0) &&  all( [ii jj kk] >0)
%                         vec_in_mm  = ([ jj; ii; kk] - pnt ).*res_1 ;
%                         vec_normalized = vec_in_mm./[r_w2 ;r_h2 ;r_w2];
%                         dist = sum(vec_normalized.^2);
%                         if (dist<1)
                            moveing_mask(ii,jj,kk) = 1;
%                         end
                        
                    end
                end
            end
        end


    end

    saveAnlz(moveing_mask,mask.par,[dataPath num2str(m)  '/masterframes/mask_rib' num2str(r)],0,3);

end
