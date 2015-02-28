

function [ang_, error_rib, offset_indx,heatMaps]= computeCost(settings,testRibs,hypotheses,...
    offset_initial,x_dif,z_dif,firstPts,ptsI,options,ang0,heatMaps,offset,errType,imInh)

if ~exist('ang0','var')
    ang0=zeros(1,4);
end
if ~exist('errType','var')
    errType=1;
end
for r=testRibs
    firstPts(:,r) =firstPts(:,r) + offset_initial(:,r);
end

if errType==3
    
imExh = heatMaps;
end
if size(ang0,1)==1
    angTmp=ang0;
    clear ang0;
    
    ang0(testRibs,:) = repmat(angTmp,length(testRibs),1);
end
    
maxCost=10;


nSamples = length(options{1})*length(options{2})* length(options{3})*length(options{4})*length(options{5});

err = 9999*ones( nSamples ,testRibs(end));
offset_index = zeros( nSamples ,testRibs(end));
ang = zeros(nSamples,5);
extents = zeros(nSamples,3,2,testRibs(end));

if (~exist('pExh','var') && errType==3)

    for r=testRibs

    %     rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);    
        rot_mat = findRotaionMatrixNew(hypotheses{r});

        direc1= rot_mat * [0 1 0 ]';

        deg1= ang0(r,1);
        deg2= ang0(r,2);   
        deg3= ang0(r,3);
        scale =   ang0(r,4); 
        startP = ang0(r,5);

        M1 = vrrotvec2mat([0 1 0 deg1/180*pi]);
        M1_r =  rot_mat*M1*rot_mat';

        P = scale*hypotheses{r};
        hyp0 = M1_r * P; 
        points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);
        [~, direc2] = lsqLine(points');


        M2 = vrrotvec2mat([direc2 deg2/180*pi]);
        direc3 = cross(direc1,direc2);


        M3 = vrrotvec2mat([direc3 deg3/180*pi]);
        hyp0_ = M3 * M2* hyp0;

        pExh{r} = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
    end     
end                     
ribPoints = hypotheses{r};
for r=testRibs
    r
    kk=0;   
    % 	rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);    
    rot_mat = findRotaionMatrixNew(hypotheses{r});
    hyp_temp = ribPoints - repmat(ribPoints(:,1),1,size(ribPoints,2));
    
    [errtmp(o), heatMaps] =  offsetCost(ribPoints,offset,heatMaps,settings,startP);

    direc1= rot_mat * [0 1 0 ]';

    for d1= options{1}
        deg1 = ang0(r,1) + d1;

        M1 = vrrotvec2mat([0 1 0 deg1/180*pi]);
        M1_r =  rot_mat*M1*rot_mat';
        
        for sc=options{4} 
            
            scale = ang0(r,4) * sc;
            P = scale*hyp_temp;
            hyp0 = M1_r * P; 
            points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);
            [~, direc2] = lsqLine(points');

            for d2= options{2}

                deg2 = ang0(r,2) + d2;
                M2 = vrrotvec2mat([direc2 deg2/180*pi]);
                direc3 = cross(direc1,direc2);
                
                for d3= options{3}

                    deg3 = ang0(r,3) + d3;        
                    M3 = vrrotvec2mat([direc3 deg3/180*pi]);
                    hyp0_ = M3 * M2* hyp0;
                    
                    for sP = options{5}
                        
                        startP = ang0(r,5) + sP;
                        kk=kk+1;
                        
                        if startP>0
                            
                            newData = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
                            

                            if errType==1

                                for o=1:size(offset,2)

                                    [errtmp(o), heatMaps] =  offsetCost(newData,offset(:,o),heatMaps,settings,startP);
                                end

                                [err(kk,r), offset_index(kk,r)] = min(errtmp);

                            elseif errType==2
                                dummyData{r}=newData;
                                err(kk,r) = computeErorr(dummyData,ptsI,r,settings, settings.step,startP);
                            elseif errType==3

                                for o=1:size(offset,2)
                                	newData_(1,:) = newData(1,:,:) + offset(1,o);
                                    newData_(2,:) = newData(2,:,:) + offset(2,o);
                                    newData_(3,:) = newData(3,:,:) + offset(3,o);
                                    errtmp(o) = regCostPar(newData_,pExh{r},imInh,imExh,settings);
                                end

                                [err(kk,r), offset_index(kk,r)] = min(errtmp);
                            end


                            ang(kk,:) = [d1 d2 d3 sc sP];
                            extents(kk,:,2,r) = max( newData,[],2);
%                             extents(kk,:,2,r) = max(hyp0_(:,startP:end),[],2);
%                             extents(kk,:,1,r) = min(hyp0_(:,startP:end),[],2);
                           
                        end
                    end
                end
            end 
        end      
    end
end

if (~isempty (x_dif) && ~isempty (z_dif))
%     nonvalid = false(size(extents,1),1);
%     for kk=1:size(extents,1)
        extents_ = max(extents(:,:,2,testRibs),[],4) ;%- min(extents(:,:,1,testRibs),[],4);
        
%         extents_(3) = max(extents(kk,3,2,testRibs)) - min(extents(kk,3,1,testRibs));
%         extents_(2) = max(extents(kk,2,2,testRibs)) - min(extents(kk,2,1,testRibs));
%         extents_(1) = max(extents(kk,1,2,testRibs)) - min(extents(kk,1,1,testRibs));
        extZ = abs(extents_(:,3) - z_dif)  ;
        extX = abs(extents_(:,1) - x_dif)  ;
        
        penaltyX = (exp((extX)/2) -1) *0.006;
        penaltyZ = (exp((extZ)/2) -1) *0.006;

        penaltyZ(extZ>5) = 10;
        penaltyX(extX>5) = 10;
%         penaltyZ(extZ>10) = 10;
%         penaltyX(extX>10) = 10;
        penaltyZ(extZ<3) = 0;
        penaltyX(extX<3) = 0;
       
        err(:,testRibs)= err(:,testRibs) + repmat(penaltyX+penaltyZ,1,length(testRibs));
%         if ( extZ >  settings.tol || extX >  settings.tolX)
            
%             err(kk,:) = err(kk,:) + 
%             nonvalid(kk) = true;
%         end                     
%     end

%     err(nonvalid,:)=maxCost;
end

[~, b]=min(sum(err(:,testRibs),2));

ang_(testRibs,[1 2 3 5]) = repmat(ang(b,[1 2 3 5]),length(testRibs),1) + ang0(testRibs,[1 2 3 5]);
ang_(testRibs,4) = repmat(ang(b,4),length(testRibs),1) .* ang0(testRibs,4);

error_rib = err(b,:);
offset_indx = offset_initial;
offset_indx(:,testRibs) = offset_initial(:,testRibs) + offset(:,offset_index(b,testRibs)) ;

