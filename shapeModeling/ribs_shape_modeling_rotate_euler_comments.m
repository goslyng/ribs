% clear all
%% Settings

%% Parameter Settings

ctSubjects=setdiff(1:20,[]);%[2:15 17:18 20];%

ribNumbers = 1:24;%3:22;
numSubjects = length(ctSubjects); 

ct_ap = [-1   0  0];
ct_is = [ 0   0 -1];
ct_lr = [ 0  -1  0];

rightRibs = 1:2:24;
ribNumbersAngle = rightRibs(7:10);
displayImages=1;

nCompsAngle = 5;
nCompsShape = 6;
nCompsRibCage = 2;
nCompsLength = 2;

numKnotsVertebra = 100;

%Angle Point Reparameterization
numKnots1=20;
numKnots2=80;

%% Path Settings

ribDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';

if isunix
    codePath = '/home/sameig/codes/';
    ribDataPath = ribDataPathUnix;
else
    codePath = 'H:\codes\';
    ribDataPath = 'O:\Bjorn_CT\';
end

ribFolder = '/newRibs/newRib';% 'ribs/ribs'

for s = ctSubjects
    
        subjectDataPath{s} =[ ribDataPath 'v' num2str(s) ribFolder ];
        vertebPath{s} = [ ribDataPath 'v' num2str(s) '/ribs/vertebrae/'];

end

ribDataPath = [ribDataPath 'new_'];

codePathSkeleton1=[codePath 'cloudcontr_2_0/matlab/'];
codePathSkeleton2=[codePath 'skeleton/'];

codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathRancac = [codePath 'ransac'];
codeLsqPath = [codePath 'mvonSiebenthal/leastSquaresFitting'];

ribShapeModelPath = [ribDataPath 'ribShapeModel'];
ribShapeCoefModelsPath =[ribDataPath 'ribShapeCoefModels'];
ribCageLengthModelPath = [ribDataPath 'ribCageLengthModel'];
ribAngleModelCTPath = [ribDataPath 'ribAngleModelCT'];
ribcageModelPath = [ribDataPath 'ribcageModel'];
ribcageWOAngleModelPath = [ribDataPath 'ribcageWOAngleModel'];

subjectsPath = [ribDataPath 'subjects'];

addpath(codePath);
addpath(genpath(codePathSkeleton1));
addpath(genpath(codePathSkeleton2));
addpath(codePathRancac);
addpath(codePathVTK);
addpath(codeLsqPath);



        
%% Computations

loadCTData;

computeRibsRotationMatrix;

computeRibsAnglePoint;

computeRibsRotationMatrixAnglePoint;

% computeRibsAnglePoint;

% save(subjectsPath,'ctSubject');

reparameterizeFromAnglePoint

anglesModeling;

computeEigenRibs;

%%
% reconstruction;
close all
for s = ctSubjects
    figure(s);hold on;
    for m=11:2:21
       
        
        p=ctSubject{s}.vertebra.rib((m+1)/2);

       

        dif(s,m,:) = ctSubject{s}.vertebra.sp1(p,:) -  ctSubject{s}.ribs{m}.sp(1,:);
         plot333(ctSubject{s}.ribs{m}.sp,'b.',[1 3 2]);
        plot333(ctSubject{s}.vertebra.sp1(p,:),'r*',[1 3 2]);
    end
    axis equal
end
%%
close all
% for k=1:3
    % vec{k}=[];
figure(100)
for s = ctSubjects
%         figure(s);;
% subplot(4,5,s)
        for m=7:10%11:2:21%


    %         p=ctSubject{s}.vertebra.rib((m+1)/2);
    %         plot(ctSubject{s}.ribs{m}.sp(:,1))
    %         plot(sp{s,m}(:,k)*lenMatrix(m-6,s))
%             plot(sp{s,m}(:,k) - mean(vec{k}')');
spp = ctSubject{s}.ribs{2*m-1}.proj_65;%sp{s,m} ;%*ctSubject{s}.ribs{2*m-1}.rot_mat';
spp (:,1) = spp(:,1) - spp(1,1) + ctSubject{s}.ribs{2*7-1}.sp(1,1);
spp (:,2) = spp(:,2) - spp(1,2) + ctSubject{s}.ribs{2*7-1}.sp(1,2);
spp (:,3) = spp(:,3) - spp(1,3)+ ctSubject{s}.ribs{2*7-1}.sp(1,3);
plot333(spp,'b.',[1 3 2]);hold on
plot333(spp(65,:),'r*',[1 3 2])
% plot333(sp{s,m},'b.',[1 3 2]);
% plot333(ctSubject{s}.ribs{m}.spc,'b.',[1 3 2]); 
% plot333(ctSubject{s}.ribs{m}.spc(50,:),'r*',[1 3 2]);
    %         vec{k}=[vec{k} sp{s,m}(:,k)];
    %         dif(s,m,:) = ctSubject{s}.vertebra.sp1(p,:) -  ctSubject{s}.ribs{m}.sp(1,:);
    %          plot333(ctSubject{s}.ribs{m}.sp,'b.',[1 3 2]);
    %         plot333(ctSubject{s}.vertebra.sp1(p,:),'r*',[1 3 2]);
        end
        axis equal
view(2)
%     end
end


%%
close all
% for k=1:3
    % vec{k}=[];
figure(100*s);
    for s = ctSubjects
        hold on;
        for m= 11:2:21%7:10 %


    %         p=ctSubject{s}.vertebra.rib((m+1)/2);
    %         plot(ctSubject{s}.ribs{m}.sp(:,1))
    %         plot(sp{s,m}(:,k)*lenMatrix(m-6,s))
%            plot333( sp{s,m},'b.',[1 3 2]);
    %         vec{k}=[vec{k} sp{s,m}(:,k)];
    %         dif(s,m,:) = ctSubject{s}.vertebra.sp1(p,:) -  ctSubject{s}.ribs{m}.sp(1,:);
%              plot333(ctSubject{s}.ribs{m}.sp,'b.',[1 3 2]);
[a b c]=findEuler(ctSubject{s}.ribs{m}.rot_mat,2)
rot=findEuler(0, b, 0,2);
ribss=(ctSubject{s}.ribs{m}.proj*rot');
            offset=ribss(1,:);

ribss = ribss-repmat(offset,100,1);

             plot333(ribss,'b.',[1 3 2]);
%             plot333(ribss(50,:),'r*',[1 3 2]);
%             plot333(ctSubject{s}.vertebra.sp1,'r*',[1 3 2]);

        end
        axis equal
    end
% end
%%
for k=1:3
ribs_{k}=[]
end
  for s=ctSubjects

         
%             figure(s*100); hold on
            for m=rightRibs([5 6 7 8 9 10])
%                 hold on;
%                 plot333(ctSubject{s}.ribs{m}.sp(ctSubject{s}.ribs{m}.anglePoint,:),'r*',[1 3 2]);
                for k=1:3
                    ribs_{k}=[ribs_{k} ctSubject{s}.ribs{m}.proj(:,k)/ctSubject{s}.ribs{m}.len*200];
                end
lens(s,(m+1)/2) = ctSubject{s}.ribs{m}.len;
            end
    end

lens(:,1:4)=[];
lens(:)
rib_mean = [mean(ribs_{1}');mean(ribs_{2}');mean(ribs_{3}')]';
rib_vec = [ribs_{1};ribs_{2};ribs_{3}];
[rot_mat,proj,score]=princomp(rib_vec');
jing=cumsum(score)/sum(score);


%%
X=[
ribs_{1}
ribs_{2}
ribs_{3}
ribs_{1}.*ribs_{2}
ribs_{1}.*ribs_{3}
ribs_{2}.*ribs_{3}
ribs_{1}.^2
ribs_{2}.^2
ribs_{3}.^2
];
Y=X(301:end,:);
X(301:900,:)=sign(Y).*sqrt(abs(Y));
[s u v]=princomp(X');
sd = cumsum(v)/sum(v);
sd(1:10)
g=u(1:6)*s(:,1:6)';
%%
  for s=ctSubjects

            figure(100); hold on

%             figure(s*100); hold on
            for m=rightRibs([5 6 7 8 9 10])
%                 plot333(ctSubject{s}.ribs{m}.proj/ctSubject{s}.ribs{m}.len*200 - rib_mean,'b.',[1 3 2]);
                plot333(ctSubject{s}.ribs{m}.proj/ctSubject{s}.ribs{m}.len*200 ,'b.',[1 3 2]);
                plot333(ctSubject{s}.ribs{m}.proj(50,:)/ctSubject{s}.ribs{m}.len*200 ,'r*',[1 3 2]);

%                 hold on;
%                 plot333(ctSubject{s}.ribs{m}.sp(ctSubject{s}.ribs{m}.anglePoint,:),'r*',[1 3 2]);
%                input('hi')
            end
            
    end
axis equal
 %% Compute the angles
% figure;
% 
% 
% % ctSubject{s}.ribs{m}.sp(1:j,:)
% %     figure;plot(ctSubject{s}.ribs{m}.sp(1:j,3),ctSubject{s}.ribs{m}.sp(1:j,2),'r.')
% %     figure;plot(ctSubject{s}.ribs{m}.sp(1:j,1),ctSubject{s}.ribs{m}.sp(1:j,2),'r.')
% for s=ctSubjects
%     
%     for m=ribNumbersAngle
% 
%         j = ctSubject{s}.ribs{m}.anglePoint ;
% 
%         Z = [ ctSubject{s}.ribs{m}.sp(1:j,3) ones(j,1)];
%         YZ = [ ctSubject{s}.ribs{m}.sp(1:j,2)] ;
%         tmp = Z\YZ;
%         ang_z(s,(m+1)/2) = 180/pi*atan(tmp(1));
% 
%         X = [ ctSubject{s}.ribs{m}.sp(j+1:end,1) ones(100-j,1)];
%         YX = [ ctSubject{s}.ribs{m}.sp(j+1:end,2)];
%         tmp = X\YX;
%         ang_x(s,(m+1)/2) = 180/pi*atan(tmp(1) );
%         
%         ax = princomp(sp{s,(m+1)/2}(1:20,1:2));
%         ang_y(s,(m+1)/2) = 180/pi*atan2(ax(1),ax(2));
%         
% %         X = [ ctSubject{s}.ribs{m}.sp(j+1:end,1) ones(100-j,1)];
% %         YX = [ ctSubject{s}.ribs{m}.sp(j+1:end,2)];
% %         tmp = X\YX;
% %         ang_x(s,(m+1)/2) = 180/pi*atan(tmp(1) );
%         
% 
%     end
% end
