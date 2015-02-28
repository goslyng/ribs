

function setAngeModulNccFullCycle_load(s,r,cycles,params,fitted)%)%
% debugText='hi';

if ~(exist('fitted','var'))
    fitted=1;
end

% inh=1;
% runFittingSettings;

% pathSettings;

% settings.nSamplesRibcage = 6;
% settings.wFirstPoint = [0 0 0];
% errs1=6;
% save('/home/sameig/debugText','debugText');
%% Load Rib Model

% 
% load(ribcageModelPath,'ribcageModel');
% load(ribShapeModelPath,'ribShapeModel');
% allmodels.ribcageModel=ribcageModel;
% allmodels.ribShapeModel = ribShapeModel;


if (s==59 || s==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

if fitted
    fittedText='fitted_';
else
    fittedText='';
end
if isunix()
    pathPrefix = '/home/sameig/';
    dataPath = '/usr/biwinas03/scratch-c/sameig/Data/dataset';
    christinePrefix = '/usr/biwinas03/scratch-c/tannerch/FUSIMO/ETHliver/dataset';
else
    pathPrefix = 'H:\';
    dataPath = 'M:/dataset';
    christinePrefix = 'Q:\dataset';
end

NCCPath = [dataPath num2str(s) '/ribsNCC/'];
% mkdir(NCCPath)


load(['/usr/biwinas01/scratch-g/sameig/Data/dataset' num2str(s) '/allcycles_nrig10_masked'],'cycleinfo');

if (s >= 60 )
    
    imExh_ = load([dataPath num2str(s)  '/masterframes/exhMaster.mat']);
    imExh_.stack.par.thickness =2.5;
    imInh_ = load([dataPath num2str(s)  '/masterframes/inhMaster.mat']);
    imInh_.stack.par.thickness=2.5
else
    
    imExh_ = load([dataPath num2str(s)  '/masterframes/exhMaster7_unmasked_uncropped.mat']);
    
end

if s>=60
    %         ribsExh = loadRibVTKFilesTag(dataPath,s,settings.ap,settings.is,settings.lr,'RibRightExhNew');
    %         ribsInh = loadRibVTKFilesTag(dataPath,s,settings.ap,settings.is,settings.lr,'RibRightInhNew');
    tag = 'RibRightExhNew';
else
    %         ribsExh = loadRibVTKFilesTag(dataPath,s,settings.ap,settings.is,settings.lr,'RibRightNew');
    tag = 'RibRightNew';
end
    
 

subjectDataPath = [dataPath num2str(s) '/'];
ribDir =[subjectDataPath 'ribs/' ];


ribiPath = [ribDir  tag num2str(r)];
ribsExh = readVTKPolyDataPoints(ribiPath);

   

    
    


%% 
    fixed  = imExh_.stack.im;



    res_1(1,1) = imExh_.stack.par.inplane;
    res_1(2,1) = imExh_.stack.par.inplane;
    res_1(3,1) = imExh_.stack.par.thickness;
    
    [s_1, s_2 ,s_3]= size(imExh_.stack.im);
      
    LB = [-0.2 -0.2 -0.2 -5 -5 -5];
    UB = [0.2 0.2 0.2 5 5 5 ];

    pp  =  ribsExh./repmat(res_1,1,size(ribsExh,2));
    
    
    pp(1,:) = pp(1,:);
    pp(2,:) = s_2-pp(2,:);
    pp(3,:) = s_3 -pp(3,:);
    
    
    patch_size=[4 6 1];
    displayImages=0;
% for r= settings.ribNumber
   %% 
   j=0;
for cycle=cycles
    
    
resultPathNCC = [NCCPath  fittedText 'r_' num2str(r) 'cycle_' num2str(cycle)  ];

load(resultPathNCC);
% figure;plot33(pp)
    for state = 1:cycleinfo.nStates(cycle)
        
      

        
        R  = findEulerO(T(state,1:3),[ 1 3 2],0);
        pn = R * (pp - repmat(pp(:,1),1,100)) + repmat(pp(:,1)+T(state,4:6)',1,100);
        j=j+1;
        TT(j,:)=T(state,:);
        P(j,:)=pn(:,100);
        if displayImages

            
            hold on;plot33(pn,'g.')
            axis equal
%             pn(1,:) = pn(1,:);
%             pn(2,:) = s_2-pn(2,:);
%             pn(3,:) = s_3- pn(3,:)  ;
%             pn = pn.*repmat(res_1,1,size(ribsExh,2));
%             pn = transCoord(pn,settings.ap,settings.is,settings.lr);
%             writeVTKPolyDataPoints([dataPath num2str(s) '/ribs/RibRightInhReg' num2str(r)],pn)
        end
%         save(resultPathNCC,'T','fval');
    end
    
end
end
% end

% 
%   vec = vrrotvec(pp(:,80) - pp(:,1),pn2(:,80) - pn2(:,1));
%     M__ = vrrotvec2mat(vec);
%     [a b c]=findEulerO(M__,[1 3 2],1)
%     
%     R= M__
%     
%     
%   ribCost =  - nccCycle2(fixed,moving,pp,pn2,patch_size);
%   
%   
