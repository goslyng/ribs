


function [ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,ap,is,lr,inh)



    if (m>=60 && m<550)
    	tag = 'RibRightExhNew';

    else
        tag = 'RibRightNew';

    end  
    if ~exist('inh','var')
        inh=0;
        
        
    end
    if inh
        tag = 'RibRightInhNew';
    end
[ptsI, rib_nos]=loadRibVTKFilesTag(dataPath,m,ap,is,lr,tag);