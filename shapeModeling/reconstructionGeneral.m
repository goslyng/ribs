%% Checking how good the fit is

close all
% clear all;
ctSubjects=1:20
subjectsPath ='/usr/biwinas03/scratch-b/sameig/Bjorn_CT/subjects'
ribModelPath ='/usr/biwinas03/scratch-b/sameig/Bjorn_CT/ribModel'
% ribModelPath = [ribDataPath 'ribModel'];

load(ribModelPath,'ribModel');
load(subjectsPath,'ctSubject')

nCompsRibcage = 5;
%%
% 
% ribModel = 
% 
%             ribShapeModel: [1x1 struct]
%       ribShapeCoeffsModel: {1x139 cell}
%        ribCageLengthModel: [1x1 struct]
%                angleModel: [1x1 struct]
ribcageParams = ribcageModel.proj(:,1:nCompsRibcage)

ribcageProj = pcaProject(ribcageModel,ribcageParams,nCompsRibcage)
% angleProj = ribModel.angleModel.proj;
% angleModel = ribModel.angleModel;
% angleParams = angleProj(:,1:nCompsAngle);
ang_proj = ribcageProj(:,13:24);% pcaProject(angleModel, angleParams, nCompsAngle);
testRibs = 7:10;

% ribCageLengthModel = ribModel.ribCageLengthModel;
% lenProjected = ribModel.ribCageLengthModel.proj;
lengthParams(:,testRibs) = 5*ribcageProj(:,9:12);% pcaProject(ribCageLengthModel, lenProjected, nCompsLength);
% ribShapeModel = ribModel.ribShapeModel;
% compModel = ribModel.ribShapeCoeffsModel;

%%
% for i=1:2%length(ribModel.ribShapeCoeffsModel)
    i=1;
    compProj{i} = 2*ribcageProj(:,4*(i-1)+(1:4));%ribModel.ribShapeCoeffsModel{i}.proj;
    i=2;
    compProj{i} = 3*ribcageProj(:,4*(i-1)+(1:4));%ribModel.ribShapeCoeffsModel{i}.proj;
% end


for c = 1 :nCompsShape
%     comp_ = reshape(ribProjected(:,c),[],length(ctSubjects));
    comp_ = pcaProject(compModel{c},compProj{c},nCompsRibCoef);
    ribProjected_(:,c) = reshape(comp_',[],1);
end


for i=1:nCompsShape
    ribShapeParams(:,testRibs,i) = reshape(ribProjected_(:,i),length(ribModel.ribs),[] )';
end


% ang_proj = repmat(ang_mean,length(ctSubjectsVert),1) + p(:,1:nComps)*c(:,1:nComps)';
for s=ctSubjects

     ang_rec(1,s,testRibs)=deg2rad(  ang_proj(s,1:4));%3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
     ang_rec(2,s,testRibs)=deg2rad( ang_proj(s,5:8));%:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
     ang_rec(3,s,testRibs)=deg2rad( ang_proj(s,9:12));%:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
end

for s=ctSubjects
    for r = testRibs
        firstPoint(s,r,:) = ctSubject{s}.ribs{(r*2-1)}.sp(2,:);
    end
end

%%
close all
for s=ctSubjects%1:3:12%3%
    
    figure(s);hold on;

    for r = testRibs%ribNumbersAngle%rightRibs%rightRibs%(ribNumbersAngle-7)/2
%         try
        
%         r=(rib+1)/2;

%         m= (rib-1)*numel(ctSubjects)+subjectCounter;

        Pp = pcaProject(ribShapeModel,squeeze(ribShapeParams(s,r,:))',nCompsShape);
        Pp = Pp*lengthParams(s,r)/meanLen;
%         Pp=lenMatrix(r,s)* rib_acc_pts0(:,(s-1)*7+r)';
        P=([Pp(1:100); Pp(101:200); Pp(201:300)]);
%         [~,P]=findRotaionMatrixNew(P,'Right',20);
%         P=P';
        rot_mat = findEuler(ang_rec(1,s,r),ang_rec(2,s,r),ang_rec(3,s,r),2);
        
%         reprojected = ([Pp(1:100)' Pp(101:200)' Pp(201:300)'])*ctSubject{s}.vertebra.coord(:,:,r+3)*rot_mat;%* ctSubject{s}.ribs{(r+3)*2-1}.rot_mat';%*ctSubject{s}.ribs{rib}.rot_mat'; 
%         reprojected = [ctSubject{s}.vertebra.coord(:,:,r+3)*rot_mat*([Pp(1:100); Pp(101:200); Pp(201:300)])]';%* ctSubject{s}.ribs{(r+3)*2-1}.rot_mat';%*ctSubject{s}.ribs{rib}.rot_mat'; 
%       
        reprojected = [rot_mat*P]';%* ctSubject{s}.ribs{(r+3)*2-1}.rot_mat';%*ctSubject{s}.ribs{rib}.rot_mat'; 

        reprojected = reprojected + repmat(squeeze(firstPoint(s,r,:))' - reprojected(2,:) ,100,1);
        plot333(reprojected,'r.',[1 3 2]);%(1:20,:));
%         x_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,1) - reprojected(1,1));
%         z_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,3) - reprojected(1,3));
%         x_z(s,rib) = 180/pi*atan2( reprojected(20,1) - reprojected(1,1),reprojected(20,3) - reprojected(1,3));
        plot333(ctSubject{s}.ribs{(r)*2-1}.sp,'b.',[1 3 2]);%(1:20,:)%sp{s,rib+4}
%         catch
%             m=m+1
%         end
    end
    
%     subjectCounter = subjectCounter+1;
    axis equal
end
%%
% ctSubjects=ctSubjects;%[3:12 14 15 17 18 20]
% figure;
% n=(ribNumbersAngle(1)+1)/2
% subplot(2,3,1);plot(squeeze(ang(3,ctSubjects,n:end))'*180/pi)
% subplot(2,3,2);plot(squeeze(ang(2,ctSubjects,n:end))'*180/pi)
% subplot(2,3,3);plot(squeeze(ang(1,ctSubjects,n:end))'*180/pi)
% subplot(2,3,4);plot((squeeze(ang(3,ctSubjects,n:end) - repmat(mean(ang(3,ctSubjects,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
% subplot(2,3,5);plot((squeeze(ang(2,ctSubjects,n:end) - repmat(mean(ang(2,ctSubjects,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
% subplot(2,3,6);plot((squeeze(ang(1,ctSubjects,n:end) - repmat(mean(ang(1,ctSubjects,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
% 
% counter=1;
% for s=ctSubjects
%     
%     ang_mat(counter,:)=reshape(ang(:,s,n:end),1,[]);%-repmat(mean(ang(:,s,5:end),3),[1 1 6]),1,[]);%
%     counter=counter+1;
% end
% 
% ang_mean = m(2,s,n:10)=ang_proj(s,2:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
%      ang_rec(3,s,n:10)=ang_proj(s,3:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
%             counter=counter+1;
% 
% end
% cumsum(sc)/sum(sc)
% 
% X= mean(abs(ang_rec-ang),3)*180/pi
% mean(X(:,ctSubjects),2)
% max(X(:,ctSubjects),[],2)
% 
% ean(ang_mat)
% [c p sc]=princomp(ang_mat)
% 
% 
% ang_proj = repmat(ang_mean,length(ctSubjects),1) + p(:,1:nCompsAngle)*c(:,1:nCompsAngle)';
% counter=1;
% for s=ctSubjects
% 
%      ang_rec(1,s,n:10)=ang_proj(s,1:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
%      ang_rec(2,s,n:10)=ang_proj(s,2:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
%      ang_rec(3,s,n:10)=ang_proj(s,3:3:end);%reshape(mean(ang_mat),3,[]) + squeeze(repmat(mean(ang(:,s,5:end),3),[1 1 6]));
%             counter=counter+1;
% 
% end
% cumsum(sc)/sum(sc)
% 
% X= mean(abs(ang_rec-ang),3)*180/pi
% mean(X(:,ctSubjects),2)
% max(X(:,ctSubjects),[],2)


%%
% for s=ctSubjects
%     
%     figure(s);hold on;
% 
%     for rib = 1:6
%     
%         m= (rib-1)*20+s;
%         Pp= ((rib_acc_.projected(m,1:nCompsShape)*rib_acc_.coeff(:,1:nCompsShape)' + meanRib)*len(m)/meanLen);
%         reprojected = ([Pp(1:100)' Pp(101:200)' Pp(201:300)']*ctSubject{s}.ribs{rib*2+7}.rot_mat); 
%         reprojected = reprojected + repmat(ctSubject{s}.ribs{rib*2+7}.sp(2,:) - reprojected(2,:) ,100,1);
%         plot33(reprojected(1:20,:));
% %         x_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,1) - reprojected(1,1));
% %         z_y(s,rib) = 180/pi*atan2( reprojected(20,2) - reprojected(1,2),reprojected(20,3) - reprojected(1,3));
% %         plot33(ctSubject{s}.ribs{rib*2+7}.sp,'r.');
%         
%     end
%     axis equal
% end
  %%
%    for s=ctSubjects
%             figure(s);hold on;
% 
%     for rib = 1:6
%     
%         m= (rib-1)*20+s;
%         Pp= ((rib_acc_.projected(m,1:nComps)*rib_acc_.coeff(:,1:nComps)' + meanRib)*len(m)/meanLen);
%         reprojected = ([Pp(1:100)' Pp(101:200)' Pp(201:300)']*ctSubject{s}.ribs{rib*2+7}.rot_mat'); 
%         reprojected = reprojected + repmat(ctSubject{s}.ribs{rib*2+7}.sp(2,:) - reprojected(2,:) ,100,1);
%         subplot(2,3,rib);
%         plot(reprojected(1:20,3),reprojected(1:20,1),'b.');hold on;
%         plot(reprojected(1,3),reprojected(1,1),'r.')
%         plot(reprojected(1:20,3),reprojected(1:20,1),'b');
%         vec = ctSubject{s}.ribs{rib*2+7}.rot_mat(1:2,1) ;
%         v(s,rib) = atan2(vec(2),vec(1))
%         title(['Rib No: ' num2str(rib)]);
%     end
%    end
 
        