


function heatMap_conv_res = convolveHeatmap(heatMap,sigma_)



s= size(heatMap);

nsf = s;
ns = floor(nsf);

heatMap_conv_res=zeros(ceil(nsf));


%% Convolution

    w= ceil(sigma_*3);
    h = makeGaussian(w,w,w,sigma_);
    heatMap_conv_res = convn(heatMap,h,'same'); 

    
    
        
        
        
        
        
        
        