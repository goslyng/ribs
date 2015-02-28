

%% rotate
nPoints=100;

for m = rightRibs

    for s = ctSubjects
        
            j = ctSubject{s}.ribs{m}.anglePoint;
            
            [~,b]=max(ctSubject{s}.ribs{m}.sp(:,3));
            
            ctSubject{s}.ribs{m}.lateralPoint = b;
            
            p=ctSubject{s}.vertebra.rib((m+1)/2);
%             vec = ctSubject{s}.ribs{m}.sp(ctSubject{s}.ribs{m}.anglePoint,:) - ctSubject{s}.vertebra.sp1(p,:);
%             vec=vec/norm(vec);
            
            rot_mat = findRotaionMatrixNew(ctSubject{s}.ribs{m}.sp_v,'Right');
    
            proj=[rot_mat'*(ctSubject{s}.ribs{m}.sp_v-repmat(mean(ctSubject{s}.ribs{m}.sp_v')',1,nPoints))]';
            
            p0=mean(proj,1);%this is basically zero because pca centers and rotates
            
            proj0 = proj - repmat(p0,nPoints,1);
            ctSubject{s}.ribs{m}.proj = proj0;

            ctSubject{s}.ribs{m}.len = sum(sqrt(sum((proj0(2:end,:)-proj0(1:end-1,:)).^2,2)));
            ctSubject{s}.ribs{m}.rot_mat = rot_mat;

           
    end
end
