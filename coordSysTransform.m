

function pOut = coordSysTransform(pIn, coordIn , coordOut )

[s_1, s_2 ]= size(pIn);

if s_1~=3
    error('The input matrix should be 3XN')
end

for coord_ =[{coordIn} , {coordOut} ]
    
    coord=coord_{1};
    if length(coordIn)~=3
        error('The coord type is invalid');
    elseif any( ~(ismember(coordIn,['L' 'R' 'P' 'A' 'S' 'I'])) )

        error('The coord type is invalid');
    end

    xyz=repmat(coordIn',1, 2)==repmat('PA', 3 ,1)|...
        repmat(coordIn',1, 2)==repmat('SI', 3 ,1)|...
    	repmat(coordIn',1, 2)==repmat('LR', 3 ,1);

   
    % make sure no two positions have the same orientation
    if any (~xor(xyz(:,1),xyz(:,2)))
        error('The coord type is invalid');
    end

end



% intermediate coordinate systemis PSL
    
    coordInt ='PSL';
    x=repmat(coordInt',1, 2)==repmat('PA', 3 ,1);
    y=repmat(coordInt',1, 2)==repmat('SI', 3 ,1);
    z=repmat(coordInt',1, 2)==repmat('LR', 3 ,1);

    xOr = x(:,1)|x(:,2);
    yOr = y(:,1)|y(:,2);
    zOr = z(:,1)|z(:,2);
  
    xDir = sum( [x(1,:)|x(2,:)|x(3,:)] .* [1 -1] );
    yDir = sum( [y(1,:)|y(2,:)|y(3,:)] .* [1 -1] );
    zDir = sum( [z(1,:)|z(2,:)|z(3,:)] .* [1 -1] );
    
    RInt = [xDir*xOr yDir*yOr zDir*zOr];
    
    
% input coordinate system rotation matrix calculations
    x=repmat(coordIn',1, 2)==repmat('PA', 3 ,1);
    y=repmat(coordIn',1, 2)==repmat('SI', 3 ,1);
    z=repmat(coordIn',1, 2)==repmat('LR', 3 ,1);

    xOr = x(:,1)|x(:,2);
    yOr = y(:,1)|y(:,2);
    zOr = z(:,1)|z(:,2);
  
    xDir = sum( [x(1,:)|x(2,:)|x(3,:)] .* [1 -1] );
    yDir = sum( [y(1,:)|y(2,:)|y(3,:)] .* [1 -1] );
    zDir = sum( [z(1,:)|z(2,:)|z(3,:)] .* [1 -1] );
    
    RIn = [xDir*xOr yDir*yOr zDir*zOr];
    

% output coordinate system rotation matrix calculations

    x=repmat(coordOut',1, 2)==repmat('PA', 3 ,1);
    y=repmat(coordOut',1, 2)==repmat('SI', 3 ,1);
    z=repmat(coordOut',1, 2)==repmat('LR', 3 ,1);

    xOr = x(:,1)|x(:,2);
    yOr = y(:,1)|y(:,2);
    zOr = z(:,1)|z(:,2);
  
    xDir = sum( [x(1,:)|x(2,:)|x(3,:)] .* [1 -1] );
    yDir = sum( [y(1,:)|y(2,:)|y(3,:)] .* [1 -1] );
    zDir = sum( [z(1,:)|z(2,:)|z(3,:)] .* [1 -1] );
    
    ROut = [xDir*xOr yDir*yOr zDir*zOr];
    
    
    pOut =  ROut * RIn'* pIn;













