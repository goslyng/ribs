% loadMrRibs

apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

for s=mriSubjects
    
%     subjectDataPath=[ dataPath num2str(s) '/ribs/'];
    if s<60
        side='Right'
    else
        side='RightExh'
    end
    for m = 7:10
        
            
           ribFileName = [subjectDataPaths{s} 'Rib' side 'New' num2str(m)];
           pts_ = readVTKPolyDataPoints(ribFileName);

               mriSubject{s}.ribs{m}.spc   = transCoord(pts_,apMRI,isMRI,lrMRI);


    end
    
    
    
end