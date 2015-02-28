% clear all
%% Settings

shapeModelingSettings
        
%% Computations

loadCTData;

computeRibsRotationMatrix;

computeRibsAnglePoint;

computeRibsRotationMatrixAnglePoint;

displayCT;

% computeRibsAnglePoint;
% save(subjectsPath,'ctSubject');

reparameterizeFromAnglePoint

anglesModeling;

computeEigenRibs;
%%
%%
if displayImages
    for s=ctSubjects


            figure(s*100);
            for m=rightRibs
                plot333(ctSubject{s}.ribs{m}.spc,'b.',[1 3 2]);
                hold on;
                plot333(ctSubject{s}.ribs{m}.spc(numKnots1,:),'r*',[1 3 2]);
            end
            axis equal
    end
end