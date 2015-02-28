function [firstPtsPerturbed, pts] = findFirstPoints(rib_nos,ptsI,HypSettings,m)

mriSubject{m}.offset=0;

offsetRibs=[  ];%32   52

for r=offsetRibs
    mriSubject{r}.offset=-1;
end

offsetRibs=[ ];%25 

for r=offsetRibs
    
    mriSubject{r}.offset=1;
    
end


for i=rib_nos
    
	firstPts(:,i + mriSubject{m}.offset) = ptsI{i}(:,1);

end

if ~isfield('HypSettings','wFirstPoint')
    w_x = 0;
    w_y = 0;
    w_z = 0;
else
    w_x = HypSettings.wFirstPoint(1);
    w_y = HypSettings.wFirstPoint(2);
    w_z = HypSettings.wFirstPoint(3);
end

for r=rib_nos
    d = 0;
    for i= -w_x : w_x 
        for j= -w_y : w_y
            for k= -w_z : w_z 
                d = d + 1; 
                firstPtsPerturbed(:,r,d) = firstPts(:,r) + [i;j;k];
            end
        end
    end
end

pts=[];

for i = HypSettings.ribNumber
    
	pts = [pts ptsI{i- mriSubject{m}.offset}];
    
end
    
