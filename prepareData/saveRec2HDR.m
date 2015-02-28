
addpath /home/sameig/codes/mvonSiebenthal/mri_toolbox_v1.5/
addpath /home/sameig/codes/mvonSiebenthal/subscripts/

dataPath =  '/usr/biwinas03/scratch-c/sameig/Data/dataset';
%%

filename{1}{60} = 'Lohmann,Martin_WIP_NAVSLICE_BH_SENSE_13_1' ;%inhale
filename{2}{60} = 'Lohmann,Martin_WIP_NAVSLICE_BH_SENSE_14_1' ;%exhale

filename{1}{61} = 'Julien_Weissenberg_WIP_NAVSLICE_BH_Ex_SENSE_14_1'; %exhale
filename{2}{61} = 'Julien_Weissenberg_WIP_NAVSLICE_BH_Ex_SENSE_13_1'; %inhale

% filename = 'Danfeng_Qin_WIP_NAVSLICE_20_SENSE_17_1';

filename{1}{63} = 'Gemma_Roig_WIP_NAVSLICE_BH_IN_SENSE_12_1'; %exhale
filename{2}{63} = 'Gemma_Roig_WIP_NAVSLICE_BH_IN_SENSE_13_1'; %inhale


filename{1}{64} = 'Elke_Schapper_WIP_NAVSLICE_IN_SENSE_14_1';%exhale
filename{2}{64} = 'Elke_Schapper_WIP_NAVSLICE_IN_SENSE_13_1';%inhale


filename{1}{65}= 'Ellen_Becker_WIP_NAVSLICE_BH_SENSE_13_1'; %Exhale 
filename{2}{65} = 'Ellen_Becker_WIP_NAVSLICE_BH_SENSE_12_1'; %Inhale

% filename = 'Ellen_Becker_WIP_NAVSLICE_BH_SENSE_14_1' %Inhale SliceThickness 5
% filename = 'Ellen_Becker_WIP_NAVSLICE_BH_SENSE_15_1' %Exhale SliceThickness 5


filename{1}{66} = 'Claudio_Bruker_WIP_NAVSLICE_BH_SENSE_11_1';%Exhale 
filename{2}{66} = 'Claudio_Bruker_WIP_NAVSLICE_20_SENSE_9_1';%Inhale




%%
fnameSavePostFix{1} = '/masterframes/exhMaster';
fnameSavePostFix{2} = '/masterframes/inhMaster';
for s = [ 60 61 63 64 65 66]


    for i=1:2
        
        fname = [ dataPath  num2str(s) '/rawdata/' filename{i}{s}];
        fnameSave = [ dataPath  num2str(s)  fnameSavePostFix{i}];
        [im, par]   = readRawData(fname);
        par.thickness=2.5;
        im = permute(im,[2 1 3]);
        saveAnlz2(im,par,fname,0,3);
        saveAnlz2(im,par,fnameSave,0,3);

        stack.im = im;
        stack.par = par;
        save(fnameSave,'stack');
        
    end

end
%%
