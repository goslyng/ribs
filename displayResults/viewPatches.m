

for s=mriSubjects
    figure(s);
    for p=1:size(ribPatches{rule}{s},2)
    ps = reshape(ribPatches{rule}{s}(:,p),settings.y_hw*2+1,settings.x_hw*2+1);
    subplot(8,10,p);
    imshow(ps,[]);
    end
end


for s=mriSubjects
    figure(s);
    for p=1:size(featuresRibs{rule}{s},2)
    ps = reshape(featuresRibs{rule}{s}(:,p),settings.y_hw*2+1,settings.x_hw*2+1);
    subplot(8,10,p);
    imshow(ps,[]);
    end
end

