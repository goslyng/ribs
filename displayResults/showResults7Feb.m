


%% The Rib Detection
for m=mriSubjects
    displayAngleIndividualScale(m,1,2)
    input(num2str(m))
end


%% Breath-hold

%% Rib Registration starting from manual segmentation

setAngeModulNcc(63,false,false);
setAngeModulNcc(60,false,false);


%% Rib Registration starting from automatic segmentation

setAngeModulNcc(60,false,true);
setAngeModulNcc(63,false,true);


%% Reconstructed Volumes

%% Rib Registration for subject 50 using automatic segmentation 

setAngeModulNccCycles(50,250,false)