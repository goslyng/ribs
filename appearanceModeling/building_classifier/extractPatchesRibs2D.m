            

function [patches, validPts]=  extractPatchesRibs2D(im,pts,patch_size,displayImages)
%im, pts (3x N), patch_size( a 3 element vec), displayImage ( The tree
%path)
x_hw = patch_size(1);
y_hw = patch_size(2);
z_hw = patch_size(3);
c = 0 ;
out_of_range=[];
patches=[];

pts = round(pts);

validPts = pts(1,:) -x_hw  >= 1 & pts(1,:) + x_hw <= size(im,2) ...
& pts(2,:) -y_hw  >= 1 & pts(2,:) + y_hw <= size(im,1) ...
& pts(3,:)        >= 1 & pts(3,:) 	   <= size(im,3) ;

for k=1:size(pts,2)

    if validPts(k)
        x_range = pts(1,k) + (-x_hw:x_hw); 
        y_range = pts(2,k) + (-y_hw:y_hw); 
        z_range = pts(3,k); 
        c=c+1;
        patches(:,k) = reshape(im(y_range,x_range,z_range),[],1);    
   
    end
end
patches = patches(:,validPts);

if exist('displayImages','var')
      treePath=displayImages;
      
    load(treePath)

    [~, vote] = classRF_predict(patches',treeModel);
    for k=1:size(patches,2)


    %             vote(k,2)/treeModel.ntree
            figure(100);
            hold off;
            x_range = floor(pts(1,k)) + (-x_hw:x_hw); 
            y_range = floor(pts(2,k)) + (-y_hw:y_hw); 
    %             z_range = floor(pts(3,i)) + (-z_hw:z_hw); 
            z_range = floor(pts(3,k)); 
            imshow(im(:,:,z_range),[]);
            hold on;
            rectangle('Position',[x_range(1) y_range(1) 2*x_hw+1 2*y_hw+1],...
                    'LineWidth',2,'EdgeColor','r');
            title(num2str(vote(k,2)/treeModel.ntree));
            pause(0.5)

    end
end