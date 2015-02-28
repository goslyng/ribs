clear all;
addpath('/home/sameig/codes/ribFitting/oldFiles/')

runFittingSettings;

dataPathUnix = '/usr/biwinas03/scratch-c/sameig/Data/dataset';
unix('source /home/sgeadmin/BIWICELL/common/settings.sh');

addpath('/home/sameig/codes/ribFitting/registeration/itkScripts/');
addpath('/home/sameig/codes');
addpath('/home/sameig/codes/ribFitting/shapeModeling');

mriSubjects=[50 51 53 54 56 57 58 59 60 61 63 64 66 ];
%%
for s = mriSubjects
    
    load([dataPathUnix num2str(s)  '/allcycles_nrig10_masked.mat'],'cycleinfo');
    params{s}.cycleinfo = cycleinfo;

    params{s}.dataPathUnix = dataPathUnix;
	if s >=60
        params{s}.stateMiddleFix ='Exh';
        params{s}.fixedImage='exhMaster.hdr';
        params{s}.cycPrefix = 'cyc_';
    else
        params{s}.stateMiddleFix =''; 
        params{s}.fixedImage='exhMaster7_unmasked_uncropped.hdr';
        
        if (ismember(s,[50 51 52 53 54 58]))
            params{s}.cycPrefix = 'original_5_cyc_';
        else
            params{s}.cycPrefix = 'cyc_';
        end

	end
end
%%
for s = mriSubjects
    
    extractTranslationCyc(s,params{s});
    
end
