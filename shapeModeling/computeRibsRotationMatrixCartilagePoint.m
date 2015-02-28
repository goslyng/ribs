

%% rotate
close all
for s = mriSubjects
%     figure(1000);hold on;
    figure(s);hold on;
    for m = 7:10%mriSubject{s}.ribNumbers%7:11%%1:10%setdiff(mriSubject{s}.ribNumbers,[11 12])%rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset

try
%         [mriSubject{s}.ribs{m}.rot_mat, proj, alpha(s,m) betha(s,m)] = findRotaionMatrixNew(mriSubject{s}.ribs{m}.boneRibs ,'Right');
%         [mriSubject{s}.ribs{m}.rot_mat, proj] = findRotaionMatrixNew(mriSubject{s}.ribs{m}.boneRibs );
%         [mriSubject{s}.ribs{m}.rot_mat, proj,~,~,proj1,angle] = findRotaionMatrixNew(mriSubject{s}.ribs{m}.spc );
       [mriSubject{s}.ribs{m}.rot_mat, proj,~,~,proj1,angle] = findRotaionMatrixNew(mriSubject{s}.ribs{m}.spc,'Right',numKnotAngle );
     angle
        plot33(proj1,'b');
catch
    s
end

    end
    view(0,0)
%     input(num2str(s))
%         axis equal
end
%%
% -23.44 10
% -20.42 21
% -13.58 1
% -7.731 19
offsetRibs=[ 18   26 27    32    33 ];%19 21];
for r=offsetRibs
    mriSubject{r}.offset=0;%-1
end

% offsetRibs=[    32   52  ];%19 21];
% for r=offsetRibs
%     mriSubject{r}.offset=-1;%-1
% end
% 
% offsetRibs=[ 25    ];%19 21];
% for r=offsetRibs
%     mriSubject{r}.offset=1;%-1
%     mriSubject{r}.ribNumbers=setdiff(mriSubject{r}.ribNumbers,12);
% end
% 
% 
% rib11=[24 25 34 51 57 59]
wierdAngles=[28 ];
% short_ribs=[52, 57,27]

28 
%%
ribNumbers=7:10

angMRI= zeros(3,mriSubjects(end),12);
clear ang_matMRI;
n=1;
% mriSubjects=setdiff(mriSubjects,short_ribs)
for s=mriSubjects
%     mriSubject{s}.trueRibNumbers
    for rib = ribNumbers%rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
        rot_mat = mriSubject{s}.ribs{rib}.rot_mat;
%         try
        [angMRI(1,s,rib), angMRI(2,s,rib), angMRI(3,s,rib)] = findEuler(rot_mat,2);
%         catch
%             rib
%         end
        
    end
    ang_matMRI(s,:)=reshape(angMRI(:,s,:),1,[]);
end

% angMRIM = angMRIM(:,mriSubjects,7:10) - repmat(mean(angMRIM(:,mriSubjects,7:10),2),[1,length(mriSubjects(1:end)),1])
displayImages=1
if displayImages
%     figure;
%     for k=1:3
%         subplot(1,3,k)
% %         plot(repmat([7:10]',1,  length(mriSubjects(1:end))),squeeze(rad2deg(angMRIM(k,mriSubjects(1:end),7:10)))');
%         plot(repmat([7:10]',1,  length(mriSubjects(1:end-1))),squeeze(rad2deg(angMRIM(k,1:end-1,:)))');
% 
%     end
testS=[1:8 10:15];1:length(mriSubjects);[1:16];% 11:14 16:21];
wierdAngles=[]
    figure;
    for k=1:3
        subplot(1,3,k)
        plot(repmat([ribNumbers]',1,  length(mriSubjects(testS))),squeeze(rad2deg(angMRI(k,mriSubjects(testS),ribNumbers)))');
    end
figure;
    for k=1:3
        subplot(1,3,k)
        plot(repmat([ribNumbers]',1,  length(setdiff(mriSubjects,wierdAngles))),squeeze(rad2deg(angMRI(k,setdiff(mriSubjects,wierdAngles),ribNumbers)))');
    end
end