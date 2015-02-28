for s= mriSubjects  
    
    for slice = 1:170
        
        fid = fopen([heatMapIndexPath{s}  num2str(slice) '.txt'],'w');
%         fid = fopen([heatMapInhIndexPath{s} num2str(slice) '.txt'],'w');

%         if s>=60
            fprintf(fid,'%s%d/exh/ %d %d %d %d\n',imPath_,s,s_1(s),s_2(s),slice,slice);
%         else
%         fprintf(fid,'%s%d %d %d %d %d\n',imPath_,s,s_1(s),s_2(s),slice,slice);
%         end
        fclose(fid);
    end
    
end

%%

for s= mriSubjectsBH
    
    for slice = 1:170
        
%         fid = fopen([heatMapIndexPath{s}  num2str(slice) '.txt'],'w');
        fid = fopen([heatMapInhIndexPath{s} num2str(slice) '.txt'],'w');

%         if s>=60
            fprintf(fid,'%s%d/inh/ %d %d %d %d\n',imPath_,s,s_1(s),s_2(s),slice,slice);
%         else
%         fprintf(fid,'%s%d %d %d %d %d\n',imPath_,s,s_1(s),s_2(s),slice,slice);
%         end
        fclose(fid);
    end
    
end