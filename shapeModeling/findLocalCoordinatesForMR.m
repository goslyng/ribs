
%% Local coordinate system
smooth_factor=4;
ribNumbers_Coord=1:4;

mrVerteb{50}= 0+(1:8);
mrVerteb{51}= 0+(1:8);
mrVerteb{52}= 0+(1:8);%2+(1:8);
mrVerteb{53}= 0+(1:8);%4+(1:8);
mrVerteb{54}= 0+(1:8);%5+(1:8);
mrVerteb{55}= 0+(1:8);
mrVerteb{56}= 0+(1:8);%2+(1:8);
mrVerteb{57}= 0+(1:8);
mrVerteb{58}= 0+(1:8);
mrVerteb{59}= 0+(1:8);

%%

for s=mrSubjects
    
    mriSubject{s}.vertebra = findLocalCoordinates(mriSubject{s}.vertebra,ribNumbers_Coord,mrVerteb{s},smooth_factor,numKnotsVertebra);
    
    
end




   