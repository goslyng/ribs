function err = nccCycle2(im1,im2,p,pn,patch_size)

    r1 = floor(repmat(p(1,:),2*patch_size(1)+1,1)+ repmat([-patch_size(1):patch_size(1) ]',1,size(p,2)));
    r2 = floor(repmat(p(2,:),2*patch_size(2)+1,1)+ repmat([-patch_size(2):patch_size(2) ]',1,size(p,2)));
    r3 = floor(repmat(p(3,:),2*patch_size(3)+1,1)+ repmat([-patch_size(3):patch_size(3) ]',1,size(p,2)));

        
   
    rn1 = floor(repmat(pn(1,:),2*patch_size(1)+1,1)+ repmat([-patch_size(1):patch_size(1) ]',1,size(pn,2)));
    rn2 = floor(repmat(pn(2,:),2*patch_size(2)+1,1)+ repmat([-patch_size(2):patch_size(2) ]',1,size(pn,2)));
    rn3 = floor(repmat(pn(3,:),2*patch_size(3)+1,1)+ repmat([-patch_size(3):patch_size(3) ]',1,size(pn,2)));

    patch_size = reshape(patch_size([2 1 3]),3,1);

    s_m = size(im1)';
    ptc_numel = (2*patch_size(1)+1)*(2*patch_size(2)+1)*(2*patch_size(3) +1);
    ptch1 = zeros( ptc_numel,size(p,2));
    ptch2 = zeros( ptc_numel,size(p,2));
    set_i=[];
    for i=1:size(p,2)
        
        if any([r1(:,i) ;r2(:,i); r3(:,i)]<1) || any ([r1(:,i)-s_m(1) ;r2(:,i)-s_m(2) ;r3(:,i)-s_m(3)]> 0) || any([rn1(:,i) ;rn2(:,i) ;rn3(:,i)]<1) || any ([rn1(:,i)-s_m(1); rn2(:,i)-s_m(2) ;rn3(:,i)-s_m(3)]>0)
            set_i=[set_i i];
        else


            patch1 = im1(r2(:,i),r1(:,i),r3(:,i));
            ptch1(:,i) = patch1(:);
            patch2 = im2(rn2(:,i),rn1(:,i),rn3(:,i));
            ptch2(:,i) = patch2(:);

        end
        
    end
    
    ptch1(:,set_i)=[];
    ptch2(:,set_i)=[];
        eps=0.000001;

        pp = (ptch1 - repmat(mean(ptch1),size(ptch1,1),1) ).* (ptch2 - repmat(mean(ptch2),size(ptch2,1),1));
        err = ( sum(pp) + eps)./(size(ptch1,1)*std(ptch1).*std(ptch2) + eps);
        err= sum(err);
    
    
    end