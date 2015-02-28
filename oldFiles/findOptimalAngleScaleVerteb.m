

function [ang_, error_rib, offset_indx]= findOptimalAngleScaleVerteb(settings,testRibs,hypotheses,...
    offset_initial,firstPts,options,ang0,heatMaps,offset)

if ~exist('ang0','var')
    ang0=zeros(1,4);
end
if ~exist('errType','var')
    errType=1;
end
for r=testRibs
    firstPts(:,r) =firstPts(:,r) + offset_initial(:,r);
end

maxCost=10;


degs1 = ang0(1) + options{1};
degs2 = ang0(2) + options{2};
degs3 = ang0(3) + options{3};


scales = ang0(4) * options{4};

startPs = ang0(5) + options{5};
startPs(startPs<1)=[];

nSamples = length(degs1)*length(degs2)* length(degs3)*length(scales)*length(startPs);

err = 9999*ones( nSamples ,size(offset,2),testRibs(end));

ang = zeros(nSamples,5);

                    

for r=testRibs
    r
    kk=0;   
    % 	rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);    
    rot_mat = findRotaionMatrixNew(hypotheses{r});
    hyp_temp = hypotheses{r} - repmat(hypotheses{r}(:,1),1,size(hypotheses{r},2));
    direc1= rot_mat * [0 1 0 ]';

    for deg1= degs1

        M1 = vrrotvec2mat([0 1 0 deg1/180*pi]);
        M1_r =  rot_mat*M1*rot_mat';
        for scale=scales     

            P = scale*hyp_temp;
            hyp0 = M1_r * P; 
            points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);
            [~, direc2] = lsqLine(points');

            for deg2= degs2
                M2 = vrrotvec2mat([direc2 deg2/180*pi]);
                direc3 = cross(direc1,direc2);
                for deg3= degs3
                    
                    M3 = vrrotvec2mat([direc3 deg3/180*pi]);
                    hyp0_ = M3 * M2* hyp0;
                    for startP = startPs

                    	newData = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
                        kk=kk+1;

                        settings.rules={'angle'};
                        for o=1:size(offset,2)
                            err(kk,o,r) =  offsetCost(newData,offset(:,o),heatMaps,settings,startP);
                        end
                         
                        ang(kk,:) = [deg1 deg2 deg3 scale startP];

                    end
                end
            end 
        end      
    end
end


err_=sum(err(:,:,testRibs),3);
[bb, b]=min(err_,[],1);
[~,a]= min(bb);
ang_ = ang(b(a),:);
error_rib = reshape((err(b(a),a,:)),1,[]);
offset_indx = offset_initial;
offset_indx(:,testRibs) = offset_initial(:,testRibs) + repmat(offset(:,a),1,length(testRibs)) ;%reshape(offset_index(b,:,:),length(testRibs),[]);

