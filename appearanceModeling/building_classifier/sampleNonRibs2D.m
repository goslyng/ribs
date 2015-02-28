
function ptsn = sampleNonRibs2D(im_z4,pts,patch_size)


x_hw = patch_size(1);
y_hw = patch_size(2);
% z_hw = patch_size(3);

Npts = size(pts,2);
[x y z ] = size(im_z4);

ptsn(1,:) = x_hw -1 + randi(x - 2* x_hw,1,10*Npts);
ptsn(2,:) = y_hw -1 + randi(y - 2* y_hw,1,10*Npts);
ptsn(3,:) = randi(z,1,10*Npts);

too_close=[];

for i=1:10*Npts
    d = sum((repmat(ptsn(:,i),1,Npts) - pts).^2,1)<100;
    if sum(d)>0
        too_close =[too_close i];
    end
end

ptsn(:,too_close)=[];

if size(ptsn,2)>Npts
    ptsn=ptsn(:,1:Npts);
end

