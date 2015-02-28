


function heatMap_conv_res = resizeHeatmap(heatMap,scale,doConv,settings,sigma_)


if ~exist('doConv','var')
    doConv = false;
end

s= size(heatMap);

nsf = s/scale;
ns = floor(nsf);

heatMap_conv_res=zeros(ceil(nsf));


%% Convolution

if doConv
    

    h = makeGaussian(settings.hw_s(1),settings.hw_s(2),settings.hw_s(3),sigma_);
    heatMap_conv = convn(heatMap,h,'same'); 
    
else
    
    heatMap_conv = heatMap;
end


if (scale==1)
    heatMap_conv_res = heatMap_conv;
    
else
%% Resize
    for i=1:ns(1)+1

        for j=1:ns(2)+1

            for k=1:ns(3)+1


                range_1 = scale*(i-1)+1:min(scale*i,s(1));
                range_2 = scale*(j-1)+1:min(scale*j,s(2));
                range_3 = scale*(k-1)+1:min(scale*k,s(3));

                subVol = heatMap_conv(range_1,range_2,range_3);
                heatMap_conv_res(i,j,k) = mean(subVol(:));
            end

         end


    end
end
    
        
        
        
        
        
        
        
        
        
        