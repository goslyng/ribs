

function mean_er = saveNewHeatmaps(inh)
if ~exist('inh','var')
inh=0;
end



%%

runFittingSettings;


%%

for m=mriSubjects(6:end)
    
   
runFittingSettings;

pathSettings;
%     heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,1,im_size_path,settings,settings.hw_sigma0);
 for part=2:3
         heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,1,im_size_path,settings,settings.hw_sigma(part));
 end
 
end