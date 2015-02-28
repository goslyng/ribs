clear all

%% Parameter Settings

runFittingSettings;

pathSettings;


%% Save the ribs

for s = ctSubjects

    dataFiles = dir(subjectDataPath{s});
    c=[];
    file_num=[];
    nums=[];
    
    clear ribs;
    clear rib;
    clear center;

    % Load the .vtk files

    for m = ctRibNumbers
        filename = [subjectDataPath{s} 'Model_' num2str(m) ];
        display(['loading file ' filename])

        [rib{m}.pts, rib{m}.faces] = readVTKPolyData(filename);

        rib{m}.pts = rib{m}.pts';
        rib{m}.faces= rib{m}.faces';
   
        [~, angle, maxDist ]= sort_using_center_point_CT(rib{m});
        rib{m}.cntr = find_center_using_angle(rib{m},angle);
        [~, angle ]= sort_using_center_point_CT_points(rib{m}.cntr);
        [angle,b]=sort(angle);
        points = rib{m}.cntr(b,:);

        dists = sqrt(sum((points(1:end-1,:) - points(2:end,:)).^2,2));
        firstPoint=find(dists>0.9*maxDist);

        if ~isempty(firstPoint)
            
            eps=deg2rad(.1);
            offset = 2*pi - eps - angle(firstPoint);
            angle_of= angle+offset;
            angle_of(angle_of>2*pi) = angle_of(angle_of>2*pi) - 2*pi;
            [~,b]=sort(angle_of);
            rib{m}.cntrs = points(b,:);
            
        else
            rib{m}.cntrs = points;
        end
        
        [rib{m}.sp, rib{m}.der]= smooth_and_fit_spline(rib{m}.cntrs,numKnots);
        pts = rib{m}.pts;
        center(m,:) = pts(1,:);
     end

    % find the center of the ribs and sort the ribs 

    [~, b] = sort(center(:,3));
    center_ = center(b,:);

    for i=1:2:length(b)
        if center_(i,2)> center_(i+1,2)
            b=b([1:i-1 i+1 i i+2:end]);
        end

    end

    for m = ctRibNumbers
        ribs{m}=rib{b(m)};
        
        if (m==23 || m==24)
            if ribs{m}.sp(1,3) > ribs{m}.sp(end,3)  
                ribs{m}.sp =  ribs{m}.sp(end:-1:1,:);
            end
        elseif ribs{m}.sp(1,1) < ribs{m}.sp(end,1) 

            ribs{m}.sp =  ribs{m}.sp(end:-1:1,:);
        end

    end
    
    display(['saving ribs to file' subjectsRibsPath{s} ])
    save(subjectsRibsPath{s},'ribs');
    
end
%% Load CT Data

for s = ctSubjects

    ctSubject{s} =load([subjectsRibsPath{s} ]);
    
    % Transform to standard coordinates
    
    for rib = ctRibNumbers
        ctSubject{s}.ribs{rib}.sp = transCoord(ctSubject{s}.ribs{rib}.sp,ct_ap,ct_is,ct_lr);
    end
    
    % read vertebrae
    
    ctSubject{s}.vertebra = readVertebrae(vertebPath{s},numKnotsVertebra,ct_ap,ct_is,ct_lr);
    
    %  Subtract the mean of each rib on that rib
    
    for m = ctRibNumbers

        ctSubject{s}.ribs{m}.mean_sp = mean(ctSubject{s}.ribs{m}.sp);
        ctSubject{s}.ribs{m}.sp0 = (ctSubject{s}.ribs{m}.sp-repmat(ctSubject{s}.ribs{m}.mean_sp,numKnots,1));
        ctSubject{s}.ribs{m}.sp_v =ctSubject{s}.ribs{m}.sp0';
    end
end


%% Compute Angle Point, reparametrize from angel point and find rotation matrix


for s=ctSubjects

    for m=rightRibs

        b = ctSubject{s}.ribs{m}.sp(:,nn);
        
        if b(end)<b(1)
            ctSubject{s}.ribs{m}.sp = ctSubject{s}.ribs{m}.sp(end:-1:1,:);
        end

        b = ctSubject{s}.ribs{m}.sp(:,nn);
        [~, j]= min(b(anglePointRange));
        ctSubject{s}.ribs{m}.anglePoint = j;
             
        ctSubject{s}.ribs{m}.spc(1:numKnots1,:)= smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(1:j,:),numKnots1,0);
        [ctSubject{s}.ribs{m}.spc(numKnots1+(0:numKnots2),:)]= smooth_and_fit_spline(ctSubject{s}.ribs{m}.sp(j:end,:),numKnots2+1,0);

        [ctSubject{s}.ribs{m}.rot_mat, ctSubject{s}.ribs{m}.proj]= findRotaionMatrixNew(ctSubject{s}.ribs{m}.spc,'Right');

    end
end


%% Modeling the angles


for s=ctSubjects
    
    for rib = testRibs2
        
        r=(rib+1)/2 - testRibs(1) +1;
        [ang(1,s,r), ang(2,s,r), ang(3,s,r)] = findEuler(ctSubject{s}.ribs{rib}.rot_mat,2);
        
    end
end


%% Building the models

rib_acc_pts = zeros(3*numKnots,numel(ctSubjects)*numel(testRibs2));

counter=1;
for s = ctSubjects
    for m = testRibs2
        
       rib_acc_pts(:,counter) =reshape(ctSubject{s}.ribs{m}.proj,[],1);
       counter=counter+1;
        
    end
end


% Model the length of the ribs
x = rib_acc_pts(001:numKnots,:);
y = rib_acc_pts(numKnots+1:2*numKnots,:);
z = rib_acc_pts(2*numKnots+1:3*numKnots,:);

pp=cat(3,x,y,z);
len =  squeeze(sum(sqrt(sum((pp(2:end,:,:)-pp(1:end-1,:,:)).^2,3)),1));

% PCA

meanLen = mean(len);
lenghthModel.mean = meanLen;
lenMatrix = reshape(len/meanLen,[],numel(ctSubjects));

% Model the ribs normalized according to length, and rotated


rib_acc_pts0 = rib_acc_pts ./repmat(len/meanLen,[ size(rib_acc_pts,1) 1]);

% Building the models

ribShapeModel= pcaModeling(rib_acc_pts0');


ribcage=[reshape(ribShapeModel.proj(:,1),[],length(ctSubjects))',... 
        reshape(ribShapeModel.proj(:,2),[],length(ctSubjects))' ,... 
        lenMatrix',...reshape(len,[],numel(ctSubjects))',... 
        squeeze(rad2deg(ang(1,:,:)))  ,... 
        squeeze(rad2deg(ang(2,:,:))) ,... 
        squeeze(rad2deg(ang(3,:,:))) ];
    
meanRibCageCT =repmat(mean(ribcage),size(ribcage,1),1);
ribcageCT = ribcage - meanRibCageCT ; 
coefs = 100./ mean(abs(ribcageCT));

ribcageCT = ribcageCT.*repmat(coefs,size(ribcageCT,1),1);
ribcageCT = ribcageCT+meanRibCageCT;

ribcageCTModel = pcaModeling (ribcageCT);
ribcageCTModel.coefs  = coefs;
ribcageCTModel.ribs = (testRibs2+1)/2;
ribcageCTModel.meanLen = meanLen;

ribcageModel = ribcageCTModel;

save(ribShapeModelPath, 'ribShapeModel');
save(ribcageModelPath,  'ribcageModel');