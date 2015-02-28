%% Checking how good the fit is

subjectCounter=1;
close all
m=1;



% ang_mean = angleModel.mean;
% c=angleModel.coeffs;

ang_proj = pcaProject(angleModel, p, nCompsAngle);
% ang_proj = repmat(ang_mean,length(ctSubjectsVert),1) + p(:,1:nComps)*c(:,1:nComps)';
counter=1;
for s=ctSubjectsVert

     ang_rec(1,s,n:10)=ang_proj(s,1:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
     ang_rec(2,s,n:10)=ang_proj(s,2:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
     ang_rec(3,s,n:10)=ang_proj(s,3:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
            counter=counter+1;

end

for s=ctSubjects%3:12%
    
    figure(s);hold on;

    for rib = ribNumbersAngle%rightRibs%rightRibs%(ribNumbersAngle-7)/2
        try
%         m= (rib-1)*numel(ctSubjects)+subjectCounter;
        
        input_vec(1:nCompsShape) = rib_acc_.projected(m,1:nCompsShape);
        input_vec(7)=len(m);
        
        
        
        Pp= ((input_vec(1:nCompsShape)*rib_acc_.coeff(:,1:nCompsShape)' + meanRib)*input_vec(7)/meanLen);
%         Pp= (meanRib*input_vec(7)/meanLen);
        
%         ctSubject{s}.ribs{rib}.rot_mat';

%         ctSubject{s}.ribs{rib*2+7}.rot_mat'
%         rot_mat = vertebra{s}.coord(:,:,(rib+1)/2)'*ctSubject{s}.ribs{rib}.rot_mat'; 
        r=(rib+1)/2;
%         [ang(1,s,r), ang(2,s,r), ang(3,s,r)] = findEuler(rot_mat);
%         rot_mat = findEuler(0,0,ang(3,s,r));%ang(1),ang(3) ,
        rot_mat = findEuler(ang_rec(1,s,r),ang_rec(2,s,r),ang_rec(3,s,r));
        reprojected = ([Pp(1:100)' Pp(101:200)' Pp(201:300)'])* vertebra{s}.coord(:,:,(rib+1)/2)*rot_mat;%*ctSubject{s}.ribs{rib}.rot_mat'; 
        
%        [sp_s der_s ] = smooth_and_fit_spline(reprojected,100,0.1);

        reprojected = reprojected + repmat(ctSubject{s}.ribs{rib}.sp(2,:) - reprojected(2,:) ,100,1);
        plot333(reprojected,'r.',[1 3 2]);%(1:20,:));
%         x_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,1) - reprojected(1,1));
%         z_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,3) - reprojected(1,3));
%         x_z(s,rib) = 180/pi*atan2( reprojected(20,1) - reprojected(1,1),reprojected(20,3) - reprojected(1,3));
        plot333(ctSubject{s}.ribs{rib}.sp,'b.',[1 3 2]);%(1:20,:)%sp{s,rib+4}
        m=m+1;
        catch
            m=m+1
        end
    end
    
    subjectCounter = subjectCounter+1;
    axis equal
end
%%
ctSubjectsVert=ctSubjects;%[3:12 14 15 17 18 20]
figure;
n=(ribNumbersAngle(1)+1)/2
subplot(2,3,1);plot(squeeze(ang(3,ctSubjectsVert,n:end))'*180/pi)
subplot(2,3,2);plot(squeeze(ang(2,ctSubjectsVert,n:end))'*180/pi)
subplot(2,3,3);plot(squeeze(ang(1,ctSubjectsVert,n:end))'*180/pi)
subplot(2,3,4);plot((squeeze(ang(3,ctSubjectsVert,n:end) - repmat(mean(ang(3,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
subplot(2,3,5);plot((squeeze(ang(2,ctSubjectsVert,n:end) - repmat(mean(ang(2,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
subplot(2,3,6);plot((squeeze(ang(1,ctSubjectsVert,n:end) - repmat(mean(ang(1,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)

counter=1;
for s=ctSubjectsVert
    
    ang_mat(counter,:)=reshape(ang(:,s,n:end),1,[]);%-repmat(mean(ang(:,s,5:end),3),[1 1 6]),1,[]);%
    counter=counter+1;
end

ang_mean = mean(ang_mat)
[c p sc]=princomp(ang_mat)


ang_proj = repmat(ang_mean,length(ctSubjectsVert),1) + p(:,1:nCompsAngle)*c(:,1:nCompsAngle)';
counter=1;
for s=ctSubjectsVert

     ang_rec(1,s,n:10)=ang_proj(s,1:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
     ang_rec(2,s,n:10)=ang_proj(s,2:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
     ang_rec(3,s,n:10)=ang_proj(s,3:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
            counter=counter+1;

end
cumsum(sc)/sum(sc)

X= mean(abs(ang_rec-ang),3)*180/pi
mean(X(:,ctSubjectsVert),2)
max(X(:,ctSubjectsVert),[],2)


%%
for s=ctSubjects
    
    figure(s);hold on;

    for rib = 1:6
    
        m= (rib-1)*20+s;
        Pp= ((rib_acc_.projected(m,1:nCompsShape)*rib_acc_.coeff(:,1:nCompsShape)' + meanRib)*len(m)/meanLen);
        reprojected = ([Pp(1:100)' Pp(101:200)' Pp(201:300)']*ctSubject{s}.ribs{rib*2+7}.rot_mat); 
        reprojected = reprojected + repmat(ctSubject{s}.ribs{rib*2+7}.sp(2,:) - reprojected(2,:) ,100,1);
        plot33(reprojected(1:20,:));
%         x_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,1) - reprojected(1,1));
%         z_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,3) - reprojected(1,3));
%         plot33(ctSubject{s}.ribs{rib*2+7}.sp,'r.');
        
    end
    axis equal
end
  %%
   for s=ctSubjects
            figure(s);hold on;

    for rib = 1:6
    
        m= (rib-1)*20+s;
        Pp= ((rib_acc_.projected(m,1:nComps)*rib_acc_.coeff(:,1:nComps)' + meanRib)*len(m)/meanLen);
        reprojected = ([Pp(1:100)' Pp(101:200)' Pp(201:300)']*ctSubject{s}.ribs{rib*2+7}.rot_mat'); 
        reprojected = reprojected + repmat(ctSubject{s}.ribs{rib*2+7}.sp(2,:) - reprojected(2,:) ,100,1);
        subplot(2,3,rib);
        plot(reprojected(1:20,3),reprojected(1:20,1),'b.');hold on;
        plot(reprojected(1,3),reprojected(1,1),'r.')
        plot(reprojected(1:20,3),reprojected(1:20,1),'b');
        vec = ctSubject{s}.ribs{rib*2+7}.rot_mat(1:2,1) ;
        v(s,rib) = atan2(vec(2),vec(1))
        title(['Rib No: ' num2str(rib)]);
    end
   end
 
        