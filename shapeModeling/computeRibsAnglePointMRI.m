%% Find the angle point of the ribs
nn=1;
for s=mriSubjects
    
    for m=mriSubject{s}.ribNumbers
            proj = mriSubject{s}.ribs{m}.sp ;%*mriSubject{s}.ribs{m}.rot_mat;

            b = proj(:,nn);
            [~, j]= min(b(10:40));
            mriSubject{s}.ribs{m}.anglePoint = j+9;
        

        
    end
end


%% Display
nn=1;
if displayImages
    for s=mriSubjects
        figure(s);
        for m=mriSubject{s}.ribNumbers%  ribNumbersAngle
            
                j = mriSubject{s}.ribs{m}.anglePoint;
                subplot(3,4,m);
                proj = mriSubject{s}.ribs{m}.sp ;%*mriSubject{s}.ribs{m}.rot_mat;

                b =proj(:,nn);

                plot(b,'k');


                hold on;
                plot(j,b(j),'r*');
                title(['Rib No ' num2str(m) ]);
                
               
%                 axis([0 100 -100 100]);
               
            
            
        end
    end
end
%%
if displayImages
    for s=mriSubjects


            figure(s*100);
            for m=mriSubject{s}.ribNumbers
                plot333(mriSubject{s}.ribs{m}.sp,'b.',[1 3 2]);
                hold on;
                plot333(mriSubject{s}.ribs{m}.sp(mriSubject{s}.ribs{m}.anglePoint,:),'r*',[1 3 2]);
            end
            axis equal
    end
end
