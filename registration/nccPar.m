function ncc = nccPar(im1,im2,p1,p2,patch_size)

% assumes the coordinates are PIR
    res_1(1,1) = im1.par.inplane;
    res_1(2,1) = im1.par.inplane;
    res_1(3,1) = im1.par.thickness;

    res_2(1,1) = im2.par.inplane;
    res_2(2,1) = im2.par.inplane;
    res_2(3,1) = im2.par.thickness;


    p1=p1./res_1;
%     p1(2) = size(im2.im,1)-p1(2);

    r1 = ceil(p1(1)) + [-patch_size(1):patch_size(1) ];
    r2 = ceil(p1(2)) + [-patch_size(2):patch_size(2) ];
    r3 = ceil(p1(3));%+ [-patch_size(3)/2:patch_size(3)/2 ];

    p2 =p2./res_2;
%     p2(2) = size(im2.im,1)-p2(2);

    rn1 = ceil(p2(1)) + [-patch_size(1):patch_size(1) ];
    rn2 = ceil(p2(2))  + [-patch_size(2):patch_size(2) ];
    rn3 = ceil(p2(3))  ;%+ [-patch_size(3)/2:patch_size(3)/2 ];

    
    
    patch_size = reshape(patch_size([2 1 3]),3,1);

    s_m1 = size(im1.im)';
    s_m2 = size(im2.im)';

    if any(p1-patch_size<1) || any (p1+patch_size -s_m1>0) || any(p2-patch_size<1) || any (p2+patch_size -s_m2>0)
        ncc = 0;
    else


        patch1 = im1.im(r2,r1,r3);

        patch2 = im2.im(rn2,rn1,rn3);

        eps=0.000001;

        pp = (patch1 - mean(patch1(:))).*(patch2 - mean(patch2(:)));

        ncc = (sum(pp(:))+ eps)/((numel(patch1)*std(patch1(:))*std(patch2(:))) + eps);
    
    
    end