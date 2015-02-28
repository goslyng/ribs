



function g = makeGaussian(s_1,s_2,s_3,sigma)
% [g, h] = makeGaussian(s_1,s_2,s_3,sigma)

g= zeros(2*s_1+1,2*s_2+1,2*s_3+1);
% h= zeros(prod([2*s_1+1,2*s_2+1,2*s_3+1]),1);
% c=1;

for x = -s_1:s_1
    for y=-s_2:s_2
        for z=-s_3:s_3
            
            g(x+s_1+1,y+s_2+1,z+s_3+1) = exp(- (x^2 +y^2+z^2)/(2*sigma^2));
%             if  any([x y z]~=0)
%                 h(c) =  g(x+s_1+1,y+s_2+1,z+s_3+1) ;
%                 c=c+1;
%             end
        end
    end
end

g = g/(sigma*sqrt((2*pi)^3));
% h=h/sum(h(:));
g=g/sum(g(:));