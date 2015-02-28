function [n, inRange] = findNeighbours( p, w, p_min, p_max, patch_siz )
%findNeighbours finds the neighbours around a point p, with half width w
%   Detailed explanation goes here
if exist('patch_siz','var')
    p_x = patch_siz(1);
    p_y = patch_siz(2);
    p_z = patch_siz(3);
else
    p_x = 0;
    p_y = 0;
    p_z = 0;
end
sz=size(p);
if (sz(1)~=3 && sz(2)~=3)
    error('Matrix p should have in at least one dimention 3 elements');
elseif sz(2) == 3
    
    p=p';
    sz = size(p);
    
end % Make sure p is 3 X N

c=1;
n = zeros(sz(1), sz(2), prod(2*w+1) -1);

for x = -w(1):w(1)
    for y = -w(2):w(2)
        for z= -w(3):w(3)
            
            if  any([x y z]~=0)
                
                n(:,:,c) =   p + repmat([x;y;z], 1 ,sz(2));
                c=c+1;
                
            end
        end
    end
end

inRange = shiftdim( logical ( ...
     [n(1,:,:) >= p_min(1) + p_x] .* [n(1,:,:) <= p_max(1) - p_x] ... %  check if x is in range
  .* [n(2,:,:) >= p_min(2) + p_y] .* [n(2,:,:) <= p_max(2) - p_y] ... %  check if y is in range
  .* [n(3,:,:) >= p_min(3) + p_z] .* [n(3,:,:) <= p_max(3) - p_z]));  %  check if z is in range

if sz(2)==1
    inRange=inRange';
end

    




% if flag
%     res = res';
% end


end

