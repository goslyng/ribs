
for s=mriSubjects

  figure(s);hold on;
    for m = mriSubject{s}.ribNumbers% rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
        
%             rmfield(mriSubject{s}.ribs{m},'spc');
            i= mriSubject{s}.ribs{m}.anglePoint;
            j= mriSubject{s}.ribs{m}.cartgPoint;numKnots;%

            mriSubject{s}.ribs{m}.spc=[]
%             [mriSubject{s}.ribs{m}.spc(1:numKnotAngle,:), ~]= smooth_and_fit_splineMRI(mriSubject{s}.ribs{m}.sp(1:i,:),numKnotAngle,0.4);
            [mriSubject{s}.ribs{m}.spc(1:numKnotAngle,:), ~]= smooth_and_fit_spline(mriSubject{s}.ribs{m}.sp(1:i,:),numKnotAngle,0.5);

%             [mriSubject{s}.ribs{m}.spc(numKnotAngle:numKnots,:), ~]= smooth_and_fit_splineMRI(mriSubject{s}.ribs{m}.sp(i:j,:),numKnots-numKnotAngle+1,0.3);
%             mriSubject{s}.ribs{m}.spc(numKnotAngle,:)= mriSubject{s}.ribs{m}.sp(i,:);
            [mriSubject{s}.ribs{m}.spc(numKnotAngle:numKnots,:), ~]= smooth_and_fit_spline(mriSubject{s}.ribs{m}.sp(i:j,:),numKnots-numKnotAngle+1,0.2);
%             if j==100
%                 mriSubject{s}.ribs{m}.spc(numKnots:numKnots+20,:)= repmat(mriSubject{s}.ribs{m}.sp(j,:),21,1);
%             else
%             	[mriSubject{s}.ribs{m}.spc(numKnots:numKnots+20,:), ~]= smooth_and_fit_spline(mriSubject{s}.ribs{m}.sp(j:end,:),21,0.2);
% 
%             end


    end
    
    
end
%%
close all


for s=mriSubjects

  figure(s);hold on;
    for m = 7:10
     
            plot333(mriSubject{s}.ribs{m}.sp,'b.',[1 3 2]);
        
        plot333(mriSubject{s}.ribs{m}.spc,'r.',[1 3 2]);
    end
    axis equal
end