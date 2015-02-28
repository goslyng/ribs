function resize_images(subjects)


dataPathUnix = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
    dataPath = dataPathUnix;
else
    codePath = 'H:\codes\';
    dataPath = 'N:/Data/dataset';
end

% codePathRibs=[codePath 'ribFitting/'];

addpath(codePath);
% addpath(genpath(codePathRibs));

dataPath = 'N:/Data/dataset';

% ribDir =[subjectDataPath 'Ribs/' ];
% ribFiles = dir(ribDir);
% fileName=''
% x= struct2cell(ribFiles);
% y= regexpi(x(1,:),'Rib1-\d*.*Smoothed.vtk','match');
% for i=1:length(y)
%    if ~isempty(y{i})
%         fileName =  y{i}{1}
%    end
% end

% ribPath =[subjectDataPath 'Ribs/' fileName(1:end-4)];
%% Load Images


for s=subjects
    
    
    subjectDataPath = [dataPath num2str(s) '/'];
%     imagePath = [subjectDataPath 'masterframes/exhMaster7_unmasked_uncropped'];
    imagePath = [subjectDataPath 'masterframes/exhMaster'];

    load(imagePath);
    img= stack.im;
%     pts = readVTKPolyDataPoints(ribPath);
    
    clear('im_z','im_z2','im_z3','im_z4');
    for j=1:size(img,3)
        im_z(:,:,j) = imresize(squeeze(stack.im(:,:,size(img,3)-j+1)),[stack.par.h*stack.par.inplane stack.par.w*stack.par.inplane]);

    end

    for j=1:size(im_z,2)
        im_z2(:,j,:) = imresize(squeeze(im_z(:,j,:)),[stack.par.h*stack.par.inplane stack.par.nDats*stack.par.thickness]);
    end
 
%     for j=1:size(im_z2,2)
%         im_z3(:,j,:) = im_z2(:,size(im_z2,2) - j +1 ,:);
%     end
    for j=1:size(im_z2,1)
        im_z4(j,:,:) = im_z2(size(im_z2,1) - j +1 ,:,:);
    end    
%     im2{subject}=im_z4;
    im=im_z4;
    save( [subjectDataPath 'masterframes/resized_exhMaster7_unmasked_uncropped'],'im');
end
% 
% z=80;
% % z =  
% im_z4=im{1};
% pt=pts{1};
% for z=1:10:size(im_z4,3)
% hold off;
% % figure(1);imshow(im_z2(:,:,size(im_z2,3) - z),[])
% figure(1);imshow(im_z4(:,:, z),[])
% 
% a = logical(pt(3,:)<z+4);
% b = logical(pt(3,:)>z-4);
% c = logical(a.*b);
% % size(im_z2,1) -
% hold on;
% % plot3( pts(1,c),size(im_z2,2) - pts(2,c),pts(3,c),'r*')
% plot3( pt(1,c),pt(2,c),pt(3,c),'r*')
% 
% pause(3)
% end