apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

apMRIv = [1  0 0];
isMRIv = [0  0 1];
lrMRIv = [0 -1 0];


numKnotsVertebra=100;
%% Accumulate subjects

for s = mriSubjects
%     
% if s>59
%     side = 'RightExh';
% else
%     side = 'Right';
% end
    ribs=[];
if strcmp(side,'RightInh')
    for rib=1:12
        [str, out]=system(['ls ' subjectDataPaths{s} 'Rib' side num2str(rib) '.vtk']);
        if str==0
            ribs=[ribs rib];
            ribFile{rib} = [subjectDataPaths{s} 'Rib' side num2str(rib)];
        end
    end
else
    for rib=1:12
%         [str, out]=system(['ls ' subjectDataPaths{s} 'Rib' side sprintf('%02d',rib) '.vtk']);
        [str, out]=system(['ls ' subjectDataPaths{s} 'Rib' side sprintf('%d',rib) '.vtk']);

        if str==0
            ribs=[ribs rib];
%             ribFile{rib} = [subjectDataPaths{s} 'Rib' side sprintf('%02d',rib) ];
            ribFile{rib} = [subjectDataPaths{s} 'Rib' side sprintf('%d',rib) ];
        end
    end
    
    
    
    
    
    
end
    

    for rib = ribs

        mriSubject{s}.ribs{rib}.pts=transpose(readVTKPolyDataPoints(ribFile{rib}));

    end
    mriSubject{s}.ribNumbers=ribs;
end
%%
for s=mriSubjects

%     offset = 10 - rib_nos{s}(end);
    mriSubject{s}.trueRibNumbers =  mriSubject{s}.ribNumbers%rib_nos{s} +offset;
%     rib_nos{s} +offset;
    mriSubject{s}.offset=0;%offset;
end

%% Transform to standard coordinates
% 
for s = mriSubjects
figure(s);hold on;
    for rib = mriSubject{s}.ribNumbers
      mriSubject{s}.ribs{rib}.pts = transCoord(mriSubject{s}.ribs{rib}.pts,apMRI,isMRI,lrMRI);
      plot333(mriSubject{s}.ribs{rib}.pts,'b.',[1 3 2])

    end
    axis equal
end



 %% read vertebrae
% 
if readVertebraeFlag
for s = mriSubjects
% 
    subjectDataPaths{s}=[ dataPath num2str(s) '/ribs/'];

    vertebPath = [subjectDataPaths{s} '/vertebrae/'];
    mriSubject{s}.vertebra = readVertebrae(vertebPath,numKnotsVertebra,apMRIv,isMRIv,lrMRIv);
    writeVTKPolyDataPoints([vertebPath 'verteb'],mriSubject{s}.vertebra.pts )

    figure(s*100);  hold on;
%     for rib = mriSubject{s}.ribNumbers
%     plot333(mriSubject{s}.ribs{rib}.pts,'b.',[1 3 2])
%     end
    plot333(mriSubject{s}.vertebra.pts,'r*',[1 3 2])
    axis equal
% 
% 
end
%%
smooth_factor=4;


verteb{50}= 0+(1:24);
verteb{51}= 0+(1:24);
verteb{52}= 0+(1:24);
verteb{53}= 0+(1:24);
verteb{54}= 0+(1:24);
verteb{56}= 0+(1:24);
verteb{57}= 0+(1:24);
verteb{58}= 0+(1:24);
verteb{59}= 0+(1:24);

rib_nos{50} = [2:7]; 
rib_nos{51} = [3:8];
rib_nos{52} = [2:6];
rib_nos{53} = [1:6];
rib_nos{54} = [1:7];
% rib_nos{55} = [:];
rib_nos{56} = [1:7];
rib_nos{57} = [1:6];
rib_nos{58} = [3:8];
rib_nos{59} = [4:8];

for s = mriSubjects(13:end)
    
    ribNumbers_Coord=1:12;
    vertebs=[zeros(1,(mriSubject{s}.ribNumbers(rib_nos{s}(1))-1)*2) verteb{s}]
    mriSubject{s}.vertebra = findLocalCoordinates(mriSubject{s}.vertebra,mriSubject{s}.ribNumbers(rib_nos{s}),vertebs,smooth_factor,numKnotsVertebra);
    
    
end



end
% %%  Subtract the mean of each rib on that rib
% 
%  
% for s = ctSubjects
%     for m = ribNumbers
%         
%         ctSubject{s}.ribs{m}.mean_sp = mean(ctSubject{s}.ribs{m}.sp);
%         ctSubject{s}.ribs{m}.sp0 = (ctSubject{s}.ribs{m}.sp-repmat(ctSubject{s}.ribs{m}.mean_sp,100,1));% *s{subject}.ribs{m}.sp_axiscoeff;
%         ctSubject{s}.ribs{m}.sp_v = ctSubject{s}.vertebra.coord(:,:,floor((m+1)/2))' * ctSubject{s}.ribs{m}.sp0';
%     end
% end
%          