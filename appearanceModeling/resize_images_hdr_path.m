function im = resize_images_hdr_path(s,imagePath,savePath)




 
        
        load(imagePath);
        img = stack.im;
        par = stack.par;
        if (par.thickness==2.5 && s==50)
            par.thickness=5;
        end
        for j=1:size(img,3)
            im_z(:,:,j) = imresize(squeeze(img(:,:,size(img,3)-j+1)),[ par.h* par.inplane  par.w* par.inplane]);
        end

        for j=1:size(im_z,2)
            im_z2(:,j,:) = imresize(squeeze(im_z(:,j,:)),[ par.h* par.inplane  par.nDats* par.thickness]);
        end
   
        for j=1:size(im_z2,1)
            im_z4(j,:,:) = im_z2(size(im_z2,1) - j +1 ,:,:);
        end   
        
        im=im_z4;
        
        if s>=60
            
            imTmp = permute(im_z4,[2 1 3]);
            im_ =flipdim(imTmp,2);
            im =flipdim(im_,1);
        end

        if exist('savePath','var')
            save(savePath,'im');
        end
       
        

