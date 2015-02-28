
 function varargout = findEuler(varargin)
% function varargout = findEuler(in1,in2,in3)
% http://en.wikipedia.org/wiki/Euler_angles
% This is desinged for a rotation matrix that applies to column vectors
% v'=Rv
if nargin==1
    
    R=varargin{1};
    if ( size(R,1) ==1 || size(R,2) ==1)
        a =  R(1);
        b =  R(2);
        g =  R(3);

        R_x = [1 0       0
        0 cos(a) -sin(a)
        0 sin(a)  cos(a)];

        R_y = [ cos(b)  0  sin(b)
        0       1  0
        -sin(b)  0  cos(b)];

        R_z = [cos(g) -sin(g) 0
        sin(g)   cos(g) 0
        0        0      1];

        R = R_x*R_y*R_z;

        varargout ={R};
    
    else
        x = R(1,:);
        y = R(2,:);
        z = R(3,:);

        a = atan2(-y(3),z(3));

        g = atan2(-x(2),x(1));

        b = asin(x(3));

        varargout={a b g};
    end
elseif nargin==2
    
    R=varargin{1};
    
    x = R(1,:);
    y = R(2,:);
    z = R(3,:);

    a = atan2(z(2),y(2));

    b = atan2(x(3),x(1));

    g = asin(-x(2));
    
    varargout={a b g};
    
elseif nargin==3
    
    a = varargin{1};
    b = varargin{2};
    g = varargin{3};
    
    R_x = [1 0       0
           0 cos(a) -sin(a)
           0 sin(a)  cos(a)];
                                 
    R_y = [ cos(b)  0  sin(b)
            0       1  0
           -sin(b)  0  cos(b)];
        
    R_z = [cos(g) -sin(g) 0
          sin(g)   cos(g) 0
          0        0      1];
     
    R = R_x*R_y*R_z;
    
    varargout ={R};
elseif nargin==4
    a = varargin{1};
    b = varargin{2};
    g = varargin{3};
    
    R_x = [1 0       0
           0 cos(a) -sin(a)
           0 sin(a)  cos(a)];
       
    R_y = [ cos(b)  0  sin(b)
           0       1  0
          -sin(b)  0  cos(b)];
        
    R_z = [cos(g) -sin(g) 0
          sin(g)   cos(g) 0
          0        0      1];
     
    R = R_x*R_z*R_y; 
%  R= R_x*R_y*R_z; 
% c1=cos(a);
% c2=cos(g);
% c3=cos(b);
% 
% s1=sin(a);
% s2=sin(g);
% s3=sin(b);
% 
%  R=[c2*c3 -s2 c2*s3
%     s1*s3+c1*c3*s2  c1*c2  c1*s2*s3-c3*s1
%  c3*s1*s2-c1*s3  c2*s1 c1*c3+s1*s2*s3];

    varargout ={R};

end
