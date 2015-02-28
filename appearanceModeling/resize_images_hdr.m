function resize_images_hdr(subjects)

% 
% dataPathUnix = '/usr/biwinas03/scratch-c/sameig/Data/dataset';
% 
% if isunix
%     codePath = '/home/sameig/codes/';
%     dataPath = dataPathUnix;
% else
%     codePath = 'H:\codes\';
%     dataPath = 'N:/Data/dataset';
% end
% 
pathSettings;

addpath(codePath);

%% Load Images


for s=subjects


    subjectDataPath = [dataPath num2str(s) '/'];

    savePaths{1} = [subjectDataPath 'masterframes/resized_exhMaster7_unmasked_uncropped'];
    imagePath{1} = [subjectDataPath 'masterframes/exhMaster7_unmasked_uncropped'];

    if s>=60
        
        imagePath{1} = [subjectDataPath 'masterframes/exhMaster'];

        savePaths{2} = [subjectDataPath 'masterframes/resized_inhMaster7_unmasked_uncropped'];
        imagePath{2} = [subjectDataPath 'masterframes/inhMaster'];
         
    end
    
    
    for k=1:length(savePaths)
    
        clear('im_z','im_z2','im_z3','im_z4');
        
        load(imagePath{k});
        img = stack.im;
        par = stack.par;
        for j=1:size(img,3)
            im_z(:,:,j) = imresize(squeeze(img(:,:,size(img,3)-j+1)),[ par.h* par.inplane  par.w* par.inplane]);
        end

        for j=1:size(im_z,2)
            im_z2(:,j,:) = imresize(squeeze(im_z(:,j,:)),[ par.h* par.inplane  size(img,3)* par.thickness]);
        end
   
        for j=1:size(im_z2,1)
            im_z4(j,:,:) = im_z2(size(im_z2,1) - j +1 ,:,:);
        end   
        
        im=im_z4;
        
        if (s>=60 && s<550)
            
            imTmp = permute(im_z4,[2 1 3]);
            im_ =flipdim(imTmp,2);
            im =flipdim(im_,1);
        end
        
%         figure(100);
%         for i=1:150
%             hold off; imshow(im(:,:,i),[]);
%             pause(0.2);
%         end   
     
        save(savePaths{k},'im');
       
        
    end
end

