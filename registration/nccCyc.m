function err = nccCyc(imInh,im2,p,pn,patch_size)


    patch_sizeInh(1:2) = patch_size(1:2) /imInh.par.inplane;
    patch_sizeInh(3) = patch_size(3);
    patch_sizeInh = floor(reshape(patch_sizeInh([2 1 3]),3,1));
  
    p(1:2) = floor( p(1:2)/imInh.par.inplane);
    p(3) = floor(p(3)/imInh.par.thickness);
    im1 = imInh.im;
    r1 = floor(p(1)+ [-patch_sizeInh(1):patch_sizeInh(1) ]);
    r2 = floor(p(2)+ [-patch_sizeInh(2):patch_sizeInh(2) ]);
    r3 = floor(p(3));%+ [-patch_size(3)/2:patch_size(3)/2 ];

    rn1 = floor(pn(1)+ [-patch_size(1):patch_size(1) ]);
    rn2 = floor(pn(2)+ [-patch_size(2):patch_size(2) ]);
    rn3 = floor(pn(3));%+ [-patch_size(3)/2:patch_size(3)/2 ];
    patch_size = reshape(patch_size([2 1 3]),3,1);

    s_m1 = size(im1)';
    s_m2 = size(im2)';
    if any(p-patch_sizeInh<1) || any (p+patch_sizeInh -s_m1>0) || any(pn-patch_size<1) || any (pn+patch_size -s_m2>0)
        err = 0;
    else


        patch_small = im1(r2,r1,r3);
        patch1=imresize(patch_small,[2*patch_size(2)+1,2*patch_size(1)+1]);
        patch2 = im2(rn2,rn1,rn3);

        eps=0.000001;

        pp = (patch1 - mean(patch1(:))).*(patch2 - mean(patch2(:)));

        err = (sum(pp(:))+ eps)/((numel(patch1)*std(patch1(:))*std(patch2(:))) + eps);
    
    
    end