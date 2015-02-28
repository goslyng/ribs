


function displayHeatMap (m)





for i=1:4
    
     load(['/home/sameig/N/rfData/heatMaps/heatMap_' num2str(m) '_' num2str(i) '_0_0_0_R_678910.mat'],'heatMap');
     heatMaps{i}= heatMap;
     
end

for i=1:165
    
    figure(103); 
    for j=1:4
        subplot(2,2,j);
        imagesc(-heatMaps{j}(:,:,i));
    end
    
	pause(0.5);

end
