function [n, inRange] = neighbourhood( p, w, p_min, p_max, patch_siz )
%UNTITLED3 Summary of this function goes here
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
[s_1, s_2]=size(p);
if (s_1~=3 && s_2~=3)
    error('Matrix p should have in at least one dimention 3 elements');
elseif s_2==3
    flag=1;
    p=p';
    [s_1, s_2]=size(p);
end % Make sure p is 3 X N
c=1;
n = zeros(s_1,s_2, prod(2*w+1) -1);

for x = -w(1):w(1)
    for y = -w(2):w(2)
        for z= -w(3):w(3)
            if (x~=0 || y~= 0 || z~=0)
            n(:,:,c) =   p + repmat([x;y;z],1,s_2);
            c=c+1;
            end
        end
    end
end

inRange =squeeze( logical ( ...
    [n(1,:,:) >= p_min(1) + p_x] .* [n(2,:,:) >= p_min(2) + p_y] .* [n(3,:,:) >= p_min(3) + p_z]...
  .*[n(1,:,:) <= p_max(1) - p_x] .* [n(2,:,:) <= p_max(2) - p_y] .* [n(3,:,:) <= p_max(3) - p_z]));


    




% if flag
%     res = res';
% end


end

