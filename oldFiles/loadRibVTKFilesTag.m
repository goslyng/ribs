    




function [ptsI, rib_nos]=loadRibVTKFilesTag(dataPath,m,ap,is,lr,tag)

display(['Subject : ' num2str(m)]);

    subjectDataPath = [dataPath num2str(m) '/'];

    ribDir =[subjectDataPath 'ribs/' ];

    rib_nos=[];
    for i= 1:12
        try
            
            ribiPath = [ribDir tag num2str(i)];
            pts_mri = readVTKPolyDataPoints(ribiPath);
            ptsI{i} = transCoord(pts_mri,ap,is,lr);
            rib_nos=[rib_nos i];
        catch
            m
            i
        end
    end
