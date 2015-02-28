function [cost, dist ,errors,lenError,outOfPlaneError]=computeErorrRibs(p_test,pts,errorType)


%%
if errorType==1
    
    outOfPlaneError=[];
%     for r=ribNumber

%       p_test = p_best{r}(:,start:step:end);
      len1 = sum(sqrt(sum((p_test(:,2:end) - p_test(:,1:end-1)).^2,1)));
      cumlen1  = cumsum(sqrt(sum((p_test(:,2:end) - p_test(:,1:end-1)).^2,1)));
      len2 = sum(sqrt(sum((pts(:,2:end) - pts(:,1:end-1)).^2,1)));
      cumlen2 = cumsum(sqrt(sum((pts(:,2:end) - pts(:,1:end-1)).^2,1)));
      
      len = min([len1 len2]);
      lenError = len1-len2;
      indx1 = find ( (cumlen1>=len)==1);
      indx2 = find( (cumlen2>=len)==1);
      
            precision = 0.01;
            xx =p_test(1,:);
            yy =p_test(2,:);
            zz =p_test(3,:);
            cumLen = cumsum(sqrt(sum([xx(2:end)-xx(1:end-1) ;yy(2:end)-yy(1:end-1); zz(2:end)-zz(1:end-1)].^2,1)));

            nKnots = size(xx,2);
            tvec1 = [0 cumLen];%0:(nKnots-1);
            tvec2 = 0:precision:cumLen(end);%tvec2 = 0:nKnots/numKnots:(nKnots-1);

            pp1 = spline(tvec1,xx);
            pp2 = spline(tvec1,yy);
            pp3 = spline(tvec1,zz);

            sp_temp(:,1) = ppval(pp1,tvec2);
            sp_temp(:,2) = ppval(pp2,tvec2);
            sp_temp(:,3) = ppval(pp3,tvec2);
            sp_temp=sp_temp';

  
            d = zeros(3,size(pts,2),size(sp_temp,2));

        for i=1:size(pts,2)

                d(:,i,:) = repmat(pts(:,i),[1 size(sp_temp,2)]) - sp_temp;

        end      

        dists=sqrt(squeeze(sum(d.^2,1)));
        [a, b]=min( dists,[],2);
        errors=a;
        dist = mean(a);
        for i=1:size(d,2)
            err3D(:,i) = d(:,i,b(i));
        end
        R = findRotaionMatrixNew(pts(:,20:100));
        errProj = R*err3D;
        outOfPlaneError= [outOfPlaneError abs(errProj(2,:))];

%     end
    cost = mean(dist);
end
%%

if errorType==2

%       p_test =pts ;
            precision = 0.01;
            xx =pts(1,:);
            yy =pts(2,:);
            zz =pts(3,:);
            cumLen = cumsum(sqrt(sum([xx(2:end)-xx(1:end-1) ;yy(2:end)-yy(1:end-1); zz(2:end)-zz(1:end-1)].^2,1)));

            nKnots = size(xx,2);
            tvec1 = [0 cumLen];%0:(nKnots-1);
            tvec2 = 0:precision:cumLen(end);%tvec2 = 0:nKnots/numKnots:(nKnots-1);

            pp1 = spline(tvec1,xx);
            pp2 = spline(tvec1,yy);
            pp3 = spline(tvec1,zz);

            sp_temp(:,1) = ppval(pp1,tvec2);
            sp_temp(:,2) = ppval(pp2,tvec2);
            sp_temp(:,3) = ppval(pp3,tvec2);
            sp_temp=sp_temp';
            d = zeros(3,size(p_test,2),size(sp_temp,2));

        for i=1:size(p_test,2)


                d(:,i,:) = repmat(p_test(:,i),[1 size(sp_temp,2)]) - sp_temp;

        end      

        dists=sqrt(squeeze(sum(d.^2,1)));
        [a, b]=min( dists,[],2);
        errors=a;
        dist = mean(a);

    cost = mean(dist);
end
