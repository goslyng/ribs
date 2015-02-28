


% longestRib = rightRibs(7);
% 
%        
% for s=ctSubjects
%        
% 
%        m=longestRib;
% 
%         rib = (m+1)/2;
%         j = ctSubject{s}.ribs{m}.anglePoint;
% 
%         ctSubject{s}.ribs{m}.spc(1:numKnots1,:)= smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(1:j,:),numKnots1,0);
%         [ctSubject{s}.ribs{m}.spc(numKnots1+(0:numKnots2),:), ~, arclength]= smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(j:end,:),numKnots2+1,0);
%         
%         
% %         arclength = sqrt(sum(ctSubject{s}.ribs{m}.spc(numKnots1+1,:)-ctSubject{s}.ribs{m}.spc(numKnots1,:)).^2)
%     for m=setdiff(    rightRibs,longestRib)
% %     ctSubject{s}.ribs{m} = rmfield(ctSubject{s}.ribs{m},'spc');
% 
%         rib = (m+1)/2;
%         j = ctSubject{s}.ribs{m}.anglePoint;
% 
%         ctSubject{s}.ribs{m}.spc(1:numKnots1,:)= smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(1:j,:),numKnots1,0);
%         tmp = smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(j:end,:),numKnots2+1,0,arclength);
%         ctSubject{s}.ribs{m}.spc(numKnots1+(0:size(tmp,1)-1),:)=tmp;
%      
% 
%     end
% end
%%

       
for s=ctSubjects
       
   for m=rightRibs


        rib = (m+1)/2;
        j = ctSubject{s}.ribs{m}.anglePoint;

        ctSubject{s}.ribs{m}.spc(1:numKnots1,:)= smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(1:j,:),numKnots1,0);
        [ctSubject{s}.ribs{m}.spc(numKnots1+(0:numKnots2),:)]= smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(j:end,:),numKnots2+1,0);

       
     

    end
end
     %%
for s=ctSubjects
    for m=rightRibs
% try
%         [ctSubject{s}.ribs{m}.rot_mat, ctSubject{s}.ribs{m}.proj_65]= findRotaionMatrixNew(ctSubject{s}.ribs{m}.spc,'Right',50);
%          [~, ctSubject{s}.ribs{m}.proj]= findRotaionMatrixNew(ctSubject{s}.ribs{m}.spc,'Right');
        [ctSubject{s}.ribs{m}.rot_mat, ctSubject{s}.ribs{m}.proj]= findRotaionMatrixNew(ctSubject{s}.ribs{m}.spc,'Right');
%          [~, ctSubject{s}.ribs{m}.proj]= findRotaionMatrixNew(ctSubject{s}.ribs{m}.spc,'Right');

% catch 
% s

    end
 
end


%% Reparameterize the curves so that angle points are coressponding
% longestRib = rightRibs(7);
% 
%        
% for s=ctSubjects
% 
%     m=longestRib;
%         rib = (m+1)/2;
%         j = ctSubject{s}.ribs{m}.anglePoint;
% 
%         sp{s,rib}(1:numKnots1,:)= smooth_and_fit_spline(ctSubject{s}.ribs{m}.proj(1:j,:),numKnots1,0);
%         sp{s,rib}(numKnots1+(0:numKnots2),:) = smooth_and_fit_spline(ctSubject{s}.ribs{m}.proj(j:end,:),numKnots2+1,0);
%         
%         arclength = sqrt(sum(sp{s,rib}(numKnots1+1,:)-sp{s,rib}(numKnots1,:)).^2)
%     for m=rightRibs
% 
% 
%         rib = (m+1)/2;
%         j = ctSubject{s}.ribs{m}.anglePoint;
% 
%         sp{s,rib}(1:numKnots1,:)= smooth_and_fit_spline(ctSubject{s}.ribs{m}.proj(1:j,:),numKnots1,0);
%         tmp = smooth_and_fit_spline(ctSubject{s}.ribs{m}.proj(j:end,:),numKnots2+1,0,arclength);
%         sp{s,rib}(numKnots1+(0:size(tmp,1)-1),:) = tmp;
% 
%     end
% end
% 
