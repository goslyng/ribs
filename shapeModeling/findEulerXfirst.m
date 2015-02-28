
 function varargout = findEulerXfirst(R,o,mat2vec)
% function varargout = findEuler(in1,in2,in3)
% http://en.wikipedia.org/wiki/Euler_angles
% This is desinged for a rotation matrix that applies to column vectors
% v'=Rv



if (all(o==[1 3 2]) || all(o==[2 1 3 ]) || all(o==[3 2 1]))
    signs=[ -1 1 1];
else
    signs=[1 -1 -1];
end
 
if mat2vec
    
      a = atan2(signs(1)* R(o(2),o(3)),R(o(3),o(3)));
      b = asin( signs(2)* R(o(1),o(3)));
      g = atan2(signs(3)* R(o(1),o(2)),R(o(1),o(1)));
        
      varargout={a b g};
else
  
    a = R(1);
    b = R(2);
    g = R(3);
    
    
    c1 = cos(a);
    c2 = cos(b);
    c3 = cos(g);
    s1 = sin(a);
    s2 = sin(b);
    s3 = sin(g);
    
    
    R{1} = [1 0  0
           0 c1 -s1
           0 s1  c1];
       
    R{2} = [ c2  0  s2
            0   1  0
           -s2  0  c2];
        
    R{3} = [c3 -s3 0
           s3  c3 0
           0   0  1];
     
    R_out = R{o(1)}*R{o(2)}*R{o(3)};
    
    varargout ={R_out};


end
