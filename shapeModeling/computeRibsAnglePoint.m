%% Find the angle point of the ribs


nn=1;
anglePointRange=1:40;

for s=ctSubjects
    
    for m=rightRibs

            b = ctSubject{s}.ribs{m}.sp(:,nn);%proj(:,nn);
            if b(end)<b(1)
                ctSubject{s}.ribs{m}.sp = ctSubject{s}.ribs{m}.sp(end:-1:1,:);
            end
            
            b = ctSubject{s}.ribs{m}.sp(:,nn);%proj(:,nn);
            [~, j]= min(b(anglePointRange));
            ctSubject{s}.ribs{m}.anglePoint = j;
        

        
    end
end


