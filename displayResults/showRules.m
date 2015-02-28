



% loadNewRibs

%%

for s=mriSubjects
    
    for m = 7:10
     
        p=mriSubject{s}.ribs{m}.spc';
        if s>=60
            settings.sliceThickness=2.5;
        else
            settings.sliceThickness=5;
        end

        for i =1:length(settings.rules)
            selectedPoints = selectPointsR5(p,settings.rules{i},settings);
            pts_{s,m,i}=p(:,selectedPoints);
        end
    end
end
%%
close all
colors = {'b.','g.','r.','m.'};
    

for s=mriSubjects
    figure(s);
    hold on;
    for m = 7:10
        plot33(mriSubject{s}.ribs{m}.spc,'k.',[1 3 2]);
        for i =1:length(settings.rules)

            plot33(pts_{s,m,i},colors{i},[1 3 2]);
        end
        p=mriSubject{s}.ribs{m}.spc';

        plot33(p(:,20),'g*',[1 3 2]);

    end
    axis equal
end
