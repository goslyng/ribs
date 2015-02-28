function resize_image(imagePath)


 

    load(imagePath);
    img= stack.im;
    
    im =zeros(stack.par.h *stack.par.inplane,stack.par.w *stack.par.inplane,stack.par.nDats * stack.par.thickness);
    
    im_z = zeros(stack.par.h*stack.par.inplane ,stack.par.w*stack.par.inplane,size(img,3));

    for j=1:size(img,3)
        im_z(:,:,j) = imresize(squeeze(stack.im(:,:,j)),[stack.par.h*stack.par.inplane stack.par.w*stack.par.inplane]);

    end
    for j=1:size(im_z,2)
        im(:,j,:) = imresize(squeeze(im_z(:,j,:)),[stack.par.h*stack.par.inplane stack.par.nDats*stack.par.thickness]);
    end
  
    
    
    par = stack.par;
    par.inplane = 1;
    par.thickness=1;
    
    save( [imagePath '_resized' ],'im');
    saveAnlz(im,par,[imagePath '_resized' ],1,3);
