
%% Local coordinate system
smooth_factor=4;
ribNumbers_Coord=1:12;

verteb{1}= 0+(1:24);
verteb{2}= 0+(1:24);
verteb{3}= 2+(1:24);%2+(1:24);
verteb{4}= 4+(1:24);%4+(1:24);
verteb{5}= 5+(1:24);%5+(1:24);
verteb{6}= 0+(1:24);
verteb{7}= 2+(1:24);%2+(1:24);
verteb{8}= 0+(1:24);
verteb{9}= 0+(1:24);
verteb{10}= 0+(1:24);
verteb{11}= 0+(1:24);
verteb{12}= 0+(1:24);
verteb{13}= 0+(1:24);
verteb{14}= 0+(1:24);
verteb{15}= 0+(1:24);
verteb{16}= 0+(1:24);
verteb{17}= 0+(1:24);
verteb{18}= 0+(1:24);
verteb{19}= 0+(1:24);
verteb{20}= 0+(1:24);
%%

for s=ctSubjects
    
    ctSubject{s}.vertebra = findLocalCoordinates(ctSubject{s}.vertebra,ribNumbers_Coord,verteb{s},smooth_factor,numKnotsVertebra);
    
    
end




   