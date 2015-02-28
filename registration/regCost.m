    


function ribCost =  regCost( hypothesis,pExh,imInh,imExh,settings)


    p  = hypothesis;
    p_ = floor(transCoord(p,settings.ap,settings.is,settings.lr));   
    pExh_ = floor(transCoord(pExh,settings.ap,settings.is,settings.lr));  
    
    
    for n=1:settings.nPoints
%         if size(imInh,1)==1
%             ncc_(n) =  nccCyc(imInh,imExh,p_(:,n),pExh_(:,n),settings.nccPatch_size);
%         else
            ncc_(n) =  ncc(imInh,imExh,p_(:,n),pExh_(:,n),settings.nccPatch_size);

%         end
        
    end
    
    ribCost = -sum(ncc_)/settings.nPoints;
