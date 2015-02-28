function err = ncc(im1,im2,p,pn,patch_size)




    r1 = floor(p(1)+ [-patch_size(1):patch_size(1) ]);
    r2 = floor(p(2)+ [-patch_size(2):patch_size(2) ]);
    r3 = floor(p(3));%+ [-patch_size(3)/2:patch_size(3)/2 ];

    rn1 = floor(pn(1)+ [-patch_size(1):patch_size(1) ]);
    rn2 = floor(pn(2)+ [-patch_size(2):patch_size(2) ]);
    rn3 = floor(pn(3));%+ [-patch_size(3)/2:patch_size(3)/2 ];
    
    
    
    patch_size = reshape(patch_size([2 1 3]),3,1);

    s_m = size(im1)';

    if any(p-patch_size<1) || any (p+patch_size -s_m>0) || any(pn-patch_size<1) || any (pn+patch_size -s_m>0)
        err = 0;
    else


        patch1 = im1(r2,r1,r3);

        patch2 = im2(rn2,rn1,rn3);

        eps=0.000001;

        pp = (patch1 - mean(patch1(:))).*(patch2 - mean(patch2(:)));

        err = (sum(pp(:))+ eps)/((numel(patch1)*std(patch1(:))*std(patch2(:))) + eps);
    
    
    end