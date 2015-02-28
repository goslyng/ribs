    


function [ribCost, ncc_]=  regCostPar( hypothesis,pExh,imInh,imExh,settings)


    p  = hypothesis;
    p_ = (transCoord(p,settings.ap,settings.is,settings.lr));   
    pExh_ = (transCoord(pExh,settings.ap,settings.is,settings.lr));  
    
    
    for n=1:settings.nPoints
%         if size(imInh,1)==1
%             ncc_(n) =  nccCyc(imInh,imExh,p_(:,n),pExh_(:,n),settings.nccPatch_size);
%         else

            ncc_(n) =  nccPar(imInh,imExh,p_(:,n),pExh_(:,n),settings.nccPatch_size);

%         end
        
    end
    regCost = 1 - ((ncc_+1)/2);
    ribCost = sum(regCost)/settings.nPoints;
