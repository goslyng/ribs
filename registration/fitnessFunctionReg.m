    


function [T, fval] =  fitnessFunctionReg(LB,UB, ImageExh,ImageInh,ribsExh,patch_size,displayImages)


    
%     options = gaoptimset('PopulationSize',100);
    if displayImages
        options = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotmaxconstr},'Display','iter','PopulationSize',200,'HybridFcn',@fmincon);
    else
        options = gaoptimset('PopulationSize',200,'HybridFcn',@fmincon);

    end
    [T,fval] = ga(@nestedfun,length(LB),[],[],[],[],double(LB),double(UB),[],options);
    
    
    
    %%  Nested function that computes the objective function
    
    function ribCost = nestedfun(T)
        
        
        R  = findEulerO(T(1:3),[ 1 3 2],0);
        pn = R * (ribsExh - repmat(ribsExh(:,1),1,100)) + repmat(ribsExh(:,1)+T(4:6)',1,100);
%         ribCost=0;
%         for i=1:size(ribsExh,2)
%             ribCost = ribCost - nccCycle(ImageInh.im,ImageExh.im,ribsExh(:,i),pn(:,i),patch_size);
%         end
%         for i=1:size(ribsExh,2)
            ribCost =  - nccCycle2(ImageExh,ImageInh,ribsExh,pn,patch_size);
%         end

    end

end