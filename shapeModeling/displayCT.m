%% Display
nn=1;
if displayImages
    for s=ctSubjects
        figure(s);
        for m=rightRibs%  ribNumbersAngle
            
                j = ctSubject{s}.ribs{m}.anglePoint;
                subplot(length(rightRibs)/4,4,(m+1)/2);
                b = ctSubject{s}.ribs{m}.sp(:,nn);%proj(:,nn);
    
                plot(b,'k');


                hold on;
                plot(j,b(j),'r*');
                title(['Rib No ' num2str((m+1)/2) ]);
           
                axis([0 100 -200 100]);
               
            
%             pause(0.1)
        end
    end

    for s=ctSubjects


            figure(s*100);
            for m=rightRibs
                plot333(ctSubject{s}.ribs{m}.sp,'b.',[1 3 2]);
                hold on;
                plot333(ctSubject{s}.ribs{m}.sp(ctSubject{s}.ribs{m}.anglePoint,:),'r*',[1 3 2]);
            end
            axis equal
    end
end
