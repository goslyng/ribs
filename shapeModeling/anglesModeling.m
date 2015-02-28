%% Modeling the angles
n=(testRibs(1)+1)/2 ;

clear ang_mat;
clear ang


for s=ctSubjects
    
    for rib = testRibs
        
        r=(rib+1)/2;
        rot_mat = ctSubject{s}.ribs{rib}.rot_mat;

        [ang(1,s,r), ang(2,s,r), ang(3,s,r)] = findEuler(rot_mat,2);
        
    end
    ang_mat(s,:)=reshape(ang(:,s,n:end),1,[]);
end

CTangleModel = pcaModeling(ang_mat);
CTangleModel.ribNumbers= (testRibs+1)/2;

%%

ctSubjectsVert=ctSubjects;%ctSubjects;%[3:12 14 15 17 18 20]
if displayImages
    figure;
    n=(testRibs(1)+1)/2;
% n=7;
    nn=(testRibs(end)+1)/2;
    subplot(2,3,1);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),squeeze(ang(1,ctSubjectsVert,n:end))'*180/pi)
    subplot(2,3,2);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),squeeze(ang(2,ctSubjectsVert,n:end))'*180/pi)
    subplot(2,3,3);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),squeeze(ang(3,ctSubjectsVert,n:end))'*180/pi)
%     subplot(2,3,4);plot(repmat([n:nn]',1,20),(squeeze(ang(1,ctSubjectsVert,n:end) - repmat(mean(ang(3,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
%     subplot(2,3,5);plot(repmat([n:nn]',1,20),(squeeze(ang(2,ctSubjectsVert,n:end) - repmat(mean(ang(2,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
%     subplot(2,3,6);plot(repmat([n:nn]',1,20),(squeeze(ang(3,ctSubjectsVert,n:end) - repmat(mean(ang(1,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
  subplot(2,3,4);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),(squeeze(ang(1,ctSubjectsVert,n:end) - repmat(mean(ang(3,ctSubjectsVert,n:end),2),[1  numel(ctSubjectsVert) 1])))'*180/pi)
    subplot(2,3,5);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),(squeeze(ang(2,ctSubjectsVert,n:end) - repmat(mean(ang(2,ctSubjectsVert,n:end),2),[1  numel(ctSubjectsVert) 1])))'*180/pi)
    subplot(2,3,6);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),(squeeze(ang(3,ctSubjectsVert,n:end) - repmat(mean(ang(1,ctSubjectsVert,n:end),2),[1  numel(ctSubjectsVert) 1])))'*180/pi)
end

if displayImages
    figure;
    n=(testRibs(1)+1)/2;
% n=7;
    nn=(testRibs(end)+1)/2;
    subplot(1,3,1);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),squeeze(rad2deg(ang(1,ctSubjectsVert,n:end)))')
    subplot(1,3,2);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),squeeze(rad2deg(ang(2,ctSubjectsVert,n:end)))')
    subplot(1,3,3);plot(repmat([n:nn]',1,numel(ctSubjectsVert)),squeeze(rad2deg(ang(3,ctSubjectsVert,n:end)))')
%     subplot(2,3,4);plot(repmat([n:nn]',1,20),(squeeze(ang(1,ctSubjectsVert,n:end) - repmat(mean(ang(3,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
%     subplot(2,3,5);plot(repmat([n:nn]',1,20),(squeeze(ang(2,ctSubjectsVert,n:end) - repmat(mean(ang(2,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
%     subplot(2,3,6);plot(repmat([n:nn]',1,20),(squeeze(ang(3,ctSubjectsVert,n:end) - repmat(mean(ang(1,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
end
