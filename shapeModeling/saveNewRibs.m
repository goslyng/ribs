
for s=mriSubjects
    
%     subjectDataPath=[ dataPath num2str(s) '/ribs/'];
    pts_all=[];
    
    for m = 7:10%mriSubject{s}.ribNumbers
        
            
           ribFileName = [subjectDataPaths{s} 'Rib' side 'New' num2str(m)];
           pts_ = transCoord(mriSubject{s}.ribs{m}.spc,apMRI,isMRI,lrMRI);
           writeVTKPolyDataPoints(ribFileName, pts_');
% pts_=readVTKPolyDataPoints(ribFileName)
%            pts_all = [pts_all;pts_'];
      
pts_all = [pts_all;pts_];
    end
        ribFileName = [subjectDataPaths{s} 'Rib' side 'NewAll' ];

%     ribFileName = [subjectDataPaths{s} 'Rib' side 'NewAll_710' ];
    writeVTKPolyDataPoints(ribFileName, pts_all');
    
    
end

%%
% 
% for s=mriSubjects
%     
%     subjectDataPath=[ dataPath num2str(s) '/ribs/'];
%     pts_all=[];
%     
%     for m = 8:10% mriSubject{s}.ribNumbers
%         
%             
%            ribFileName = [subjectDataPath 'Rib' side 'New' num2str(m)];
% %            pts_ = transCoord(mriSubject{s}.ribs{m}.spc,apMRI,isMRI,lrMRI);
%             pts_ = readVTKPolyDataPoints(ribFileName);
% mriSubject{s}.ribs{m}.spc = transCoord(pts_,apMRI,isMRI,lrMRI);
% %            pts_all = [pts_all pts_];
%       
% 
%     end
%     
% %     ribFileName = [subjectDataPath 'Rib' side 'NewAll' ];
% %     writeVTKPolyDataPoints(ribFileName, pts_all);
%     
%     
% end
