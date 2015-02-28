

    
%% Accumulate subjects
% clear ctSubject

for s = ctSubjects
    
        %subjectDataPath{s}=[ ribDataPath 'v' num2str(s) '/ribs/'];
%         unix(['mv ' subjectDataPath 'rib.MAT ' subjectDataPath 'rib.mat'])
try
        ctSubject{s} =load([subjectDataPath{s} '/newRibs/newRib.mat']);
catch
    s
end

    
end

%% Transform to standard coordinates

for s = ctSubjects
    
    for rib = ctRibNumbers
       ctSubject{s}.ribs{rib}.sp = transCoord(ctSubject{s}.ribs{rib}.sp,ct_ap,ct_is,ct_lr);
    end
    
end

%% read vertebrae

for s = ctSubjects

%     subjectDataPath=[ ribDataPath 'v' num2str(s) '/ribs/'];
    vertebPath{s} = [subjectDataPath{s} '/ribs/vertebrae'];
    ctSubject{s}.vertebra = readVertebrae(vertebPath{s},numKnotsVertebra,ct_ap,ct_is,ct_lr);


end
%%  Subtract the mean of each rib on that rib

 findLocalCoordinatesForCT;

for s = ctSubjects
    for m = ctRibNumbers
        
        ctSubject{s}.ribs{m}.mean_sp = mean(ctSubject{s}.ribs{m}.sp);
        ctSubject{s}.ribs{m}.sp0 = (ctSubject{s}.ribs{m}.sp-repmat(ctSubject{s}.ribs{m}.mean_sp,100,1));% *s{subject}.ribs{m}.sp_axiscoeff;
        ctSubject{s}.ribs{m}.sp_v =ctSubject{s}.ribs{m}.sp0';% ctSubject{s}.vertebra.coord(:,:,floor((m+1)/2))' * ctSubject{s}.ribs{m}.sp0';
    end
end
         