function moveing_mask = createMask(points,moving,res_1,r_h2,r_w2)


% r_h2 = 30/2 ; 
% r_w2 = 20/2;

x_range = ceil(-2*r_w2/res_1(2)):floor(2*r_w2/res_1(2));
y_range = ceil(-2*r_h2/res_1(1)):floor(2*r_h2/res_1(1));
z_range = ceil(-2*r_w2/res_1(3)):floor(2*r_w2/res_1(3));

    moveing_mask = zeros(size(moving));
    NCS = findRotaionMatrixNew(points);
    x = findEulerO(NCS',[1 3 2],1);
% pt=[];
    for i=1:size(points,2)
      
        pnt = points(:,i)./res_1;
        pnt(2,1) = size(moveing_mask,1) -pnt(2);
        pnt(3,1) = size(moveing_mask,3) -pnt(3);
        pnt_= floor(pnt);
        for ii= y_range + pnt_(2)
            for jj=x_range + pnt_(1)
                for kk=z_range + pnt_(3)
                    if  all ((size(moving) - [ii jj kk] )>=0) &&  all( [ii jj kk] >0)
                        vec_in_mm  = ([ jj; ii; kk] - pnt ).*res_1 ;
                        if i>=40
                            vec_inNCS=NCS'*[vec_in_mm(1);-vec_in_mm(2);-vec_in_mm(3)];
                        elseif (i<=20)
                            vec_inNCS=vec_in_mm;
                        else
                            R = findEulerO([(-20+i)/20*x(1) (-20+i)/20*x(2) (-20+i)/20*x(3)],[1 3 2],0);
                            vec_inNCS=R*[vec_in_mm(1);-vec_in_mm(2);-vec_in_mm(3)];

                        end
                        vec_normalized = vec_inNCS./[r_w2 ;r_h2 ;r_w2];
                   
                        dist = sum(vec_normalized.^2);
                        if (dist<1)
%                             pt=[pt [jj;ii;kk]];
                            moveing_mask(ii,jj,kk) = 1;
                        end
                        
                    end
                end
            end
        end


    end