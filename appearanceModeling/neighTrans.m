
function totalNeighboursCost = neighTrans(ribCost, neighCost, inRange, settings) 

sumMethod = settings.sumMethod;
costMethod = settings.costMethod;


if size(ribCost,1)==1
    ribCost=ribCost';
end

if size(neighCost,1)~=size(ribCost,1)
    if size(neighCost,2)==size(ribCost,1)
        neighCost=neighCost';
    else
        error('The size of neighCost should be N X 2hw');
    end
end


indxN = logical(neighCost==-9999);
indx = logical(ribCost==-9999);
    
    
if strcmp(costMethod,'log')
    maxCost=-log(0.001);
  
    neighCost = -log(neighCost);
    ribCost = -log(ribCost);
    
elseif strcmp(costMethod,'prob');
    
    maxCost=0;

    
    neighCost = -(neighCost);
    ribCost = -(ribCost);
    

    
    
end
   
neighCost(indxN)=maxCost;
ribCost(indx)=maxCost;

if strcmp(sumMethod,'average')
    
    totalNeighboursCost = ribCost +...
        1/sum(double(inRange)).*squeeze(sum(neighCost(:,inRange) ,2));
elseif strcmp(sumMethod,'Gaussian')
    
    if sum(settings.hw_s)==0
    	totalNeighboursCost =ribCost;
    else
        
        [g, h] =  makeGaussian(settings.hw_s(1),settings.hw_s(2),settings.hw_s(3),settings.hw_sigma);
        for p=1:size(ribCost,1)

            v = [neighCost(p,1:end/2) ribCost(p) neighCost(p,end/2+1:end)];
            ids = inRange;
            ids = [ids(p,1:end/2) 1 ids(p,end/2 +1:end)];
            totalNeighboursCost(p)  = v(logical(ids))*h(logical(ids))./sum(h(logical(ids))) ;

        end
    end

end
