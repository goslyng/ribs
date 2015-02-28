function saveHeatMaps(m,settings)

%% Path Settings

ribsDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';
dataPathUnix = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
    ribsDataPath = ribsDataPathUnix;
    rootPath = '/usr/biwinas01/scratch-g/sameig/';
    dataPath = dataPathUnix;
    rfCodePath ='/home/sameig/codes/RF_MexStandalone-v0.02/randomforest-matlab/RF_Class_C';
    cd(rfCodePath);
%     compile_linux;
else
    codePath = 'H:\codes\';
    rootPath = 'N:/';
    ribsDataPath = 'O:\Bjorn_CT\';
    dataPath = 'N:/Data/dataset';
    addpath(genpath([codePath 'RF_MexStandalone-v0.02-precompiled']));

end

codePathRibs=[codePath 'ribFitting/'];

codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathSkeleton =   [codePath 'skeleton/'];
mriDataPath = [rootPath 'Ribs/resized_exhMaster7_unmasked_uncropped_'];


treePath = [rootPath 'Ribs/Trees/'];
heatMapPath = [rootPath 'Ribs/heatMap'];

addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);

for i=1:length(settings.rules);
    
    treePaths{m}{i} = [treePath 'tree_cntr2_' settings.rules{i} '_ps_new_' num2str(settings.x_hw) '_' num2str(settings.y_hw) '_s' num2str(m)];
end

%% Load images


tmp=load( [mriDataPath num2str(m)],'im');
im{m}=tmp.im;
 


%% Find the best cases
rules = {'angle','last','middle','postSagittal'};

for i=1:length(rules);
    
%     treePaths{m}{i} = [treePath 'tree_cntr2_' rules{i} '_ps_new_' num2str(settings.x_hw) '_' num2str(settings.y_hw) '_s' num2str(m)];
    heatMapPath_rule{i} = [heatMapPath num2str(m) '_' rules{i} ];
    heatMap=-9999*ones(size(im{m}));
    
    z_vec=1:size(im{m},3)/2;
    
    heatMap = generateHeatMap(im{m},treePaths{m}{i},settings.patch_size,heatMap,z_vec);

    save(heatMapPath_rule{i},'heatMap');

% for i=1:length(rules);
% 
%     treePaths{m}{i} = [treePath 'tree_cntr2_' rules{i} '_ps_new_' num2str(settings.x_hw) '_' num2str(settings.y_hw) '_s' num2str(m)];
%     heatMapPath_rule{i} = [heatMapPath num2str(m) '_' rules{i} ];
%     heatMap=-9999*ones(size(im{m}));
% 
%     z_vec=size(im{m},3)/2:size(im{m},3);
%     
%     try
%         load(heatMapPath_rule{i},'heatMap');
%     catch
%     end
%     heatMap = generateHeatMap(im{m},treePaths{m}{i},settings.patch_size,heatMap,z_vec);
% 
%     save(heatMapPath_rule{i},'heatMap');
% 
% end
end

