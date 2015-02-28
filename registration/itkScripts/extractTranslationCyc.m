
function initialTranslation = extractTranslationCyc(s,params)


dataPathUnix = params.dataPathUnix;
initialTranslation=[];
registrationPath = [dataPathUnix num2str(s) '/rib_registration/'];

tokenAngleX = 'angle X      = ';
tokenAngleY = 'angle Y      = ';
tokenAngleZ = 'angle Z      = ';
tokenTransX = 'Translation X = ';
tokenTransY = 'Translation Y = ';
tokenTransZ = 'Translation Z = ';  

for cyc = 1:params.maxCycles

    outputFile=[ registrationPath 'results/output_spine_' num2str(s) '_' num2str(cyc) '_1.txt'];

    fid = fopen(outputFile);
    if fid<0
        cyc
    else
        if ismember(s,[19 23 ])
            [initialRotation(:,cyc), initialTranslation(:,cyc), ~] =readRegResults19(fid);% readRegResults19(fid);
        else
            [initialRotation(:,cyc), initialTranslation(:,cyc), ~] =readRegResults(fid);% readRegResults19(fid);

        end
        fclose(fid);      
    end
end

save(params.outputTranslationFile,'initialTranslation','initialRotation');
figure;plot(initialTranslation')
title([num2str(s) ' displacement in mm'])

figure;plot(180/pi*initialRotation')
title([num2str(s) ' rotation in degrees'])
