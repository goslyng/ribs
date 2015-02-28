

%% rotate

for m = rightRibs

    for s = ctSubjects


            [rot_mat, proj] = findRotaionMatrixNew(ctSubject{s}.ribs{m}.sp_v);
            
            p0=mean(proj,1);%this is basically zero because pca centers and rotates
            
            proj0 = proj - repmat(p0,100,1);
            ctSubject{s}.ribs{m}.proj = proj0;
            
            ctSubject{s}.ribs{m}.len = sum(sqrt(sum((proj0(2:end,:)-proj0(1:end-1,:)).^2,2)));
            ctSubject{s}.ribs{m}.rot_mat = rot_mat;

           
    end
end
