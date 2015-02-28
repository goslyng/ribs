

function patches = extractPatchesNonRibs2D(im_z4,pts,patch_size)

%%Settings

% dataPathUnix = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
%     dataPath = dataPathUnix;
else
    codePath = 'H:\codes\';
%     dataPath = 'N:/Data/dataset';
end

codePathRibs=[codePath 'ribFitting/'];

addpath(codePath);
addpath(genpath(codePathRibs));

% dataPath = 'N:/Data/dataset';

% 
% subjectDataPath = [dataPath num2str(subject) '/'];
% 
% imagePath = [subjectDataPath 'masterframes/exhMaster7_unmasked_uncropped'];
% ribDir =[subjectDataPath 'Ribs/' ];
% ribFiles = dir(ribDir);
% 
%    x= struct2cell(ribFiles);
%    y= regexpi(x(1,:),'Rib1-\d*.*Smoothed.vtk','match');
%    for i=1:length(y)
%        if ~isempty(y{i})
%             fileName =  y{i}{1};
%        end
%    end
% 
% ribPath =[subjectDataPath 'Ribs/' fileName(1:end-4)];

%%
% load(imagePath)
% img= stack.im;
% pts = readVTKPolyDataPoints(ribPath);

% 
% 
%     for j=1:size(img,3)
%         im_z(:,:,j) = imresize(squeeze(stack.im(:,:,size(img,3)-j+1)),[stack.par.h*stack.par.inplane stack.par.w*stack.par.inplane]);
%     end
% 
%     for j=1:size(im_z,2)
%         im_z2(:,j,:) = imresize(squeeze(im_z(:,j,:)),[stack.par.h*stack.par.inplane stack.par.nDats*stack.par.thickness]);
%     end
%  
%     for j=1:size(im_z2,2)
%         im_z3(:,j,:) = im_z2(:,size(im_z2,2) - j +1 ,:);
%     end
%     for j=1:size(im_z2,1)
%         im_z4(j,:,:) = im_z3(size(im_z2,1) - j +1 ,:,:);
%     end    

%%
x_hw = patch_size(1);
y_hw = patch_size(2);
% z_hw = patch_size(3);

Npts = size(pts,2);
[x y z ] = size(im_z4);

ptsn(1,:) = randi(x,1,2*Npts);
ptsn(2,:) = randi(y,1,2*Npts);
ptsn(3,:) = randi(z,1,2*Npts);

too_close=[];

for i=1:Npts
    d = sum((repmat(ptsn(:,i),1,Npts) - pts).^2,1)<100;
    if sum(d)>0
        too_close =[too_close i];
    end
end

ptsn(:,too_close)=[];

if size(ptsn,2)>Npts
    ptsn=ptsn(:,1:Npts);
end

patches = zeros((2*x_hw+1)*(2*y_hw+1),Npts);
out_of_range=[];


for i=1:Npts

    try
        x_range = floor(ptsn(1,i)) + (-x_hw:x_hw); 
        y_range = floor(ptsn(2,i)) + (-y_hw:y_hw); 
        z_range = floor(ptsn(3,i)) ;% + (-z_hw:z_hw); 
        patches(:,i) = reshape(im_z4(y_range,x_range,z_range),[],1);
    catch
        out_of_range =[out_of_range i];
    end
end

patches(:,out_of_range)=[];

