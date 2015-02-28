    


function [T, fval] =  fitnessFunctionGT(LB,UB, pTest,ribsExh,displayImages)


    
%     options = gaoptimset('PopulationSize',100);
    if displayImages
        options = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotmaxconstr},'Display','iter','PopulationSize',200,'HybridFcn',@fmincon);
    else
        options = gaoptimset('PopulationSize',200,'HybridFcn',@fmincon);

    end
    
    precision = 0.5;
    xx =ribsExh(1,:);
    yy =ribsExh(2,:);
    zz =ribsExh(3,:);
    cumLen = cumsum(sqrt(sum([xx(2:end)-xx(1:end-1) ;yy(2:end)-yy(1:end-1); zz(2:end)-zz(1:end-1)].^2,1)));

    nKnots = size(xx,2);
    tvec1 = [0 cumLen];%0:(nKnots-1);
    tvec2 = 0:precision:cumLen(end);%tvec2 = 0:nKnots/numKnots:(nKnots-1);

    pp1 = spline(tvec1,xx);
    pp2 = spline(tvec1,yy);
    pp3 = spline(tvec1,zz);

    ribsExh_resampled(:,1) = ppval(pp1,tvec2);
    ribsExh_resampled(:,2) = ppval(pp2,tvec2);
    ribsExh_resampled(:,3) = ppval(pp3,tvec2);
    
    
    ribsExh_resampled=ribsExh_resampled';
            
       [T,fval] =     fmincon( @nestedfun,zeros(1,6),[],[],[],[],double(LB),double(UB))
%     [T,fval] = ga(@nestedfun,length(LB),[],[],[],[],double(LB),double(UB),[],options);
    
    
    
    %%  Nested function that computes the objective function
    
    function ribCost = nestedfun(T)
        
        
        R  = findEulerO(T(1:3),[ 1 3 2],0);
        sp_temp = R * (ribsExh_resampled - repmat(ribsExh_resampled(:,1),1,size(ribsExh_resampled,2))) + repmat(ribsExh_resampled(:,1)+T(4:6)',1,size(ribsExh_resampled,2));
        

   
        d = zeros(3,size(pTest,2),size(sp_temp,2));

        for i=1:size(pTest,2)

                d(:,i,:) = repmat(pTest(:,i),[1 size(sp_temp,2)]) - sp_temp;

        end      
        
         dists=sqrt(squeeze(sum(d.^2,1)));
        [a, b]=min( dists,[],2);
        ribCost = mean(a);
    end

end