    


function M=  planeFit( ribsExh)


    
%       LB = -[0.5 0.5 0.5];
%       UB=-LB;
   
%        [T,fval] =     fmincon( @nestedfun,zeros(1,3),[],[],[],[],double(LB),double(UB));
    
    
    
    %%  Nested function that computes the objective function
    
%     function ribCost = nestedfun(T)
        
        
%         R  = findEulerO(T(1:3),[ 1 3 2],0);
offset = repmat(mean(ribsExh,2),1,size(ribsExh,2));
[~,~, d]=svd((ribsExh - offset )');

x = vrrotvec(d(:,3),[0 d(2) 0]);
        M = vrrotvec2mat(x);
        
%         ribCost = sum(sp_temp(2,:).^2);
   
      
    end

% end