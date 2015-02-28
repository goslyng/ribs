%% rotate
% close all
for s = mriSubjects
    % figure(s);hold on;
    for m = mriSubject{s}.ribNumbers%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
        mriSubject{s}.ribs{m}.rot_mat=[];

    try

    %             [mriSubject{s}.ribs{m}.rot_mat, proj] = findRotaionMatrix(mriSubject{s}.ribs{m}.boneRibs );
            j=mriSubject{s}.ribs{m}.anglePoint;    
                [mriSubject{s}.ribs{m}.rot_mat, proj] = findRotaionMatrixNew(mriSubject{s}.ribs{m}.sp ,'Right');            
%     [mriSubject{s}.ribs{m}.rot_mat, proj] = findRotaionMatrixNew(mriSubject{s}.ribs{m}.pts ,'Right');

%     [mriSubject{s}.ribs{m}.rot_mat, proj] = findRotaionMatrixNew(mriSubject{s}.ribs{m}.sp_v ,'Right');


    catch
    m
    s
    end
        
end
%     axis equal
end
