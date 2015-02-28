    


function [T, M2,fval] =  findOptimalAngles(NCS, angles_,o)



     
    
    LB = - ones(1,3);
    UB = ones(1,3);
    
            options = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotmaxconstr},'Display','iter','PopulationSize',1000,'HybridFcn',@fmincon);

    for j=1:size(angles_,2)       
        R{j} = findEulerO(angles_(:,j),o,0);
    end
        
    
    [T,fval] = ga(@nestedfun,length(LB),[],[],[],[],LB,UB,[],options);
    
    M1 = findEulerO(T,o,0);
    M2 = M1* NCS';
        
  
    %%  Nested function that computes the objective function
    
    function ribCost = nestedfun(T)
        
        M = findEulerO(T,o,0);
        M_ = M* NCS';
        
        for i=1:size(angles_,2)
            MM = M_* R{i}* M_';
            [a(1,i), a(2,i), a(3,i)]=findEulerO(MM,o,1);
        end
        
        ribCost = sum(sum(abs(a(2:3,:))));
    
    end


end