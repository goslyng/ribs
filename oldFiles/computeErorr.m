function [cost, dist ,errors,lenError,outOfPlaneError]=computeErorr(p_best,pts,ribNumber,settings,step,start,errorType)


% 
% for r=ribNumber
%     
% %     p_test = p_best{r}(:,start:step:end);
%     p_test = p_best{r}(:,start:step:end);
% %     d = zeros(3,size(p_test,2),size(pts{r},2));
% %         d = zeros(3,size(pts{r},2),size(p_test,2));
%         d = zeros(3,settings.nPoints,size(p_test,2));
% 
%     for i=1:settings.nPoints%size(pts{r},2)
%         
%             
%             d(:,i,:) = repmat(pts{r}(:,i),[1 size(p_test,2)]) - p_test;
% 
%     end      
%    
%     dists{r}=sqrt(squeeze(sum(d.^2,1)));
%     [a, b]=min( dists{r},[],2);
%     errors{r}=a;
%     dist(r) = mean(a);
%      
% end
% cost = mean(dist(ribNumber));

%%
if errorType==1
    
    outOfPlaneError=[];
    for r=ribNumber

      p_test = p_best{r}(:,start:step:end);
      len1 = sum(sqrt(sum((p_test(:,2:end) - p_test(:,1:end-1)).^2,1)));
      cumlen1  = cumsum(sqrt(sum((p_test(:,2:end) - p_test(:,1:end-1)).^2,1)));
      len2 = sum(sqrt(sum((pts{r}(:,2:end) - pts{r}(:,1:end-1)).^2,1)));
      cumlen2 = cumsum(sqrt(sum((pts{r}(:,2:end) - pts{r}(:,1:end-1)).^2,1)));
      
      len = min([len1 len2]);
      lenError = len1-len2;
      indx1 = find ( (cumlen1>=len)==1);
      indx2 = find( (cumlen2>=len)==1);
      
      p_test = p_best{r}(:,start:step:indx1(1)+start);

      pts{r} = pts{r}(:,1:indx2(1)+1);
      
      
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

    %     p_test = p_best{r}(:,start:step:end);
    %     p_test = p_best{r}(:,start:step:end);
    %     d = zeros(3,size(p_test,2),size(pts{r},2));
    %         d = zeros(3,size(pts{r},2),size(p_test,2));
            d = zeros(3,size(pts{r},2),size(sp_temp,2));

        for i=1:size(pts{r},2)

                d(:,i,:) = repmat(pts{r}(:,i),[1 size(sp_temp,2)]) - sp_temp;

        end      

        dists{r}=sqrt(squeeze(sum(d.^2,1)));
        [a, b]=min( dists{r},[],2);
        errors(:,r)=a;
        dist(r) = mean(a);
        for i=1:size(d,2)
            err3D(:,i) = d(:,i,b(i));
        end
        R = findRotaionMatrixNew(pts{r});
        errProj = R*err3D;
        outOfPlaneError= [outOfPlaneError abs(errProj(2,:))];

    end
    cost = mean(dist(ribNumber));
end
%%

if errorType==2
    for r=ribNumber

      p_test =pts{r} ;
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

    %     p_test = p_best{r}(:,start:step:end);
    %     p_test = p_best{r}(:,start:step:end);
    %     d = zeros(3,size(p_test,2),size(pts{r},2));
    %         d = zeros(3,size(pts{r},2),size(p_test,2));
            d = zeros(3,settings.nPoints,size(sp_temp,2));

        for i=start:settings.nPoints%size(pts{r},2)


                d(:,i,:) = repmat(p_best{r}(:,i),[1 size(sp_temp,2)]) - sp_temp;

        end      

        dists{r}=sqrt(squeeze(sum(d.^2,1)));
        [a, b]=min( dists{r},[],2);
        errors{r}=a;
        dist(r) = mean(a(start:end));

    end
    cost = mean(dist(ribNumber));
end
