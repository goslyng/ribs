

%% rotate
nPoints=100;


    for s = ctSubjects
        figure(s);hold on;

        for m = rightRibs
   
            
            plot33(ctSubject{s}.ribs{m}.sp);
            plot33(ctSubject{s}.ribs{m}.sp(1,:),'r*');
            lastPoint(s,m,:) = ctSubject{s}.ribs{m}.sp(1,:);
           
        end
        axis equal;
    end

    for s = ctSubjects
        

        for m = rightRibs(2:end)
   
          dists3d = ctSubject{s}.ribs{m-2}.sp - repmat(reshape(lastPoint(s,m,:),1,[]),nPoints,1);
          [dists1(s,(m-1)/2) , ind1(s,(m-1)/2)] = min(sqrt(sum(dists3d.^2,2)));
           
        end
    end
 
    for s = ctSubjects
        

        for m = rightRibs(2:end)
   
          dists3d = ctSubject{s}.ribs{m}.sp - repmat(reshape(lastPoint(s,m-2,:),1,[]),nPoints,1);
          [dists2(s,(m-1)/2), ind2(s,(m-1)/2) ] = min(sqrt(sum(dists3d.^2,2)));
           
        end
    end
    
    
     for s = ctSubjects
        

        for m = rightRibs(2:end)
   
          dists3d = ctSubject{s}.ribs{m-2}.sp(ind1(s,(m-1)/2),:) - reshape(lastPoint(s,m,:),1,[]);
          [dists2(s,(m-1)/2), ind2(s,(m-1)/2) ] = min(sqrt(sum(dists3d.^2,2)));
           
        end
     end
    
     
    dists= min(dists1, dists2)
    ind = logical(dists1-dists2>0)
    ind2.*ind + ind1.*(1- ind)
    
    mean(dists,1) - 12
    std(dists,1)