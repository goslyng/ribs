function heatMap = loadHeatMaps( heatMapTxtPath,s1,s2,s3,patch_size,maxCost,postFix,fullimage)

heatMap = maxCost * ones(s1,s2,s3);
p1=patch_size(1);
p2=patch_size(2);
% fullimage = 1;

if ~exist('fullimage','var')
    fullimage=0;
end


if fullimage
  
      fid = fopen([heatMapTxtPath ]);
      data = fscanf(fid,'%f');
      fclose(fid);
      heatMap(p1+1:s1-p1,p2+1:s2-p2,:) = reshape(data,[s1-(2*p1) s2-(2*p2) s3]);
    
else
    
    for slice = 1:s3
try
            

        fid = fopen([heatMapTxtPath '_' num2str(slice) postFix ]);
        data = fscanf(fid,'%f');
        fclose(fid);
        heatMap(p1+1:s1-p1,p2+1:s2-p2,slice) = reshape(data,[s1-(2*p1) s2-(2*p2)]);
catch
    slice
end
    end


end
