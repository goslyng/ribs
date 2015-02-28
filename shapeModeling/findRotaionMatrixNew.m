
function [rot_mat, proj,alpha,betha, proj1,angle_] = findRotaionMatrixNew(points,side,nY)


    if ~exist('side','var')

        side = 'Right';
    end

    if ( size(points,1)==3 && size(points,2)~=3)
        points = points';
    end

    if ~exist('nY', 'var')
        nY= size(points,1);
    end

    [prinComps, proj] = princomp(points);
    normal = prinComps(:,3);

    if normal(2)<0
        normal = - normal;
    end

    r = vrrotvec(normal,[0 1 0]);
   
    rot_mat_y=   vrrotvec2mat(r) ;
    [angle_(1), angle_(2),  angle_(3)]=findEuler(rot_mat_y);

    proj = (points-repmat(mean(points),size(proj,1),1))*rot_mat_y';
    proj1=proj;
    xz{1}=proj(1:nY,[1 3]);
    xz{2}=proj(1:nY,[3 1]);
    for k=1
        prinCompsY = princomp(xz{k});
        normal = prinCompsY(:,1);

        if (normal(2)<0 && strcmp(side,'Right') )
            normal = - normal;
        end  

        r = vrrotvec([normal(1) 0 normal(2)],[0 0 1]);
        rot_mat_z=   vrrotvec2mat(r) ;


        rot_mat_yz{k} = transpose(rot_mat_z*rot_mat_y);
        [angle(k,1), angle(k,2),  angle(k,3)]=findEuler(rot_mat_yz{k});
    end
    
    [~,b]=min(sum(abs(angle(:,[1 2 3])),2));
    
    rot_mat=rot_mat_yz{b};
    proj = (points-repmat(mean(points),size(proj,1),1))*rot_mat;

    x_axis = rot_mat(:,1);
    r_x = vrrotvec(x_axis,[1 0 0]);
    alpha=r_x(4);
    z_axis = rot_mat(:,3);
    r_z = vrrotvec(z_axis,[0 0 1]);
    betha=r_z(4);



            
            
%             
%             if ( size(points,1)==3 && size(points,2)~=3)
%                 points = points';
%             end
%             
%             [rot_mat, proj] = princomp(points);
%             
%             % the third eigenvector has the least variation and it is the
%             % SI axis (y), therefore it has to remain the second coordinate
%             rot_mat=rot_mat(:,[1 3 2]);
%             
%             % Recalculate the projection
%             proj=proj(:,[1 3 2]);%(points-repmat(mean(points),size(proj,1),1))*rot_mat;
%             
%           
% %            [~, c]=min([proj(1,1) proj(end,1)]);
%            
%            % If the x (AP) coordinate of the first point isn't smaller than
%            % the last point, it means that the projection inverts the x axis
%            
%             if proj(1,1) > proj(end,1)
%                 rot_mat(:,1) = -rot_mat(:,1) ;
% %                 proj=proj(points-repmat(mean(points),size(proj,1),1))*rot_mat;
%                 proj(:,1) = -proj(:,1) ;
% 
%             end
%             
%             % Check if there is inversion of z axis for right ribs
%             % Find the middle point 
%             mid = floor((1+size(proj,1))/2);
%             [~, b]=sort([proj(1,3) proj(mid,3) proj(end,3)]);
%             
%             if b(1)==2
%                 rot_mat(:,3) = -rot_mat(:,3) ;
%                 proj(:,3) = -proj(:,3) ;                
% %                 proj=(points-repmat(mean(points),size(proj,1),1))*rot_mat;
%             end
%             
%             % Check if there is inversion of the y axis
%             if rot_mat(2,2) < 0
%                    rot_mat(:,2) = -rot_mat(:,2) ;
%                    proj(:,2) = -proj(:,2) ;                   
% %                    proj=(points-repmat(mean(points),size(proj,1),1))*rot_mat;
% 
%             end
%             if det(rot_mat) < 0
%                 error('No rotation with the desired properties was found');
%             end
%             
%             
%             % This is what happens in the end: 
%             % proj = (points-repmat(mean(points),size(proj,1),1))*rot_mat;
%             % , the
%             % rotation matrix from the projected points to the real world 
%             % coordinates would be rot_mat
%             % proj*rot_mat' = points; and So in the system of right hand
%             % rotation, Rx = x', we have rot_mat * proj' =points';
%             
%             
