

function createSpineMaskSnap(m,fitted)

% debugText='hi';

if ~(exist('fitted','var'))
    fitted=1;
end

runFittingSettings;
inh=0;
pathSettings;
addpath([codePath '//mvonSiebenthal/mri_toolbox_v1.5/']) 

%%



% if (m >= 60 )
    
%     imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster_rs.mat']);
%     imExh_.stack.par.thickness =2.5;

% else
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster7_unmasked_uncropped.mat']);
    
% end

subjectDataPath = [dataPath num2str(m) '/'];



%%
        
moving = imExh_.stack.im;

res_1(1,1) = imExh_.stack.par.inplane;
res_1(2,1) = imExh_.stack.par.inplane;
res_1(3,1) = imExh_.stack.par.thickness;






mask.par = imExh_.stack.par;



a = avw_img_read([dataPath num2str(m)  '/masterframes/spine_snap.img'],3);
a.img = permute(a.img,[2 1 3]);
a.img = flip(a.img,3)
saveAnlz(a.img,mask.par,[dataPath num2str(m)  '/masterframes/spine' ],0,3);

end
