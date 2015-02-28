
mriSubjects = [18 19 23:28 31 33:34 50:54 56:59];

%%
for m=mriSubjects%     dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/ribCage_' num2str(m) '*']);
%     dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/Hypo' num2str(m) '*'])
    try
        [~, b]=displayResults(m,4,1,0);
        err(m,:) = b{1};
    catch
        m
    end
end

for m=mriSubjects

        [~, resMM{m},errorsM{m} ]= displayResults(m,6,1,0);
  
end

for m=mriSubjects

    fprintf(1,[num2str(resMM{m}{1}) '\n'])
end

%%

er=[];
succesfful=[];

for m=mriSubjects
    try
        er = [er mean(cell2mat(errorsM{m}(7:10)))];
        succesfful = [succesfful m];
        
    catch
    end
end

%%


for r=7:10
    
    errorRib{r}=[]

    for m=mriSubjects
        errorRib{r} =[errorRib{r} errorsM{m}{r}];
    end
end

for m=mriSubjects
    X = cell2mat(errorsM{m});
    X=X;
    fprintf(1,'Subj %d & %.5f & %.2f & %.2f \\\\ \n',m,mean(X) ,std(X) ,prctile(X,90))
    
end
Subj 18 & 3.95798 & 4.35 & 6.58 \\ 
Subj 19 & 4.37292 & 2.47 & 7.76 \\ 
Subj 23 & 4.29677 & 2.57 & 7.71 \\ 
Subj 24 & 4.31453 & 3.84 & 9.39 \\ 
Subj 25 & 6.14498 & 2.21 & 8.56 \\ 
Subj 26 & 2.89893 & 1.91 & 5.22 \\ 
Subj 27 & 4.22038 & 4.82 & 7.15 \\ 
Subj 28 & 9.80433 & 15.79 & 29.78 \\ 
Subj 31 & 3.37016 & 2.40 & 5.36 \\ 
Subj 33 & 5.25812 & 4.53 & 7.41 \\ 
Subj 34 & 6.28501 & 4.16 & 11.99 \\ 
Subj 50 & 7.59041 & 5.84 & 16.75 \\ 
Subj 51 & 3.05735 & 2.02 & 5.08 \\ 
Subj 52 & 4.69515 & 3.26 & 8.45 \\ 
Subj 53 & 8.87618 & 7.85 & 20.78 \\ 
Subj 54 & 5.84014 & 5.32 & 14.84 \\ 
Subj 56 & 5.40912 & 5.11 & 11.97 \\ 
Subj 57 & 7.87711 & 5.40 & 16.20 \\ 
Subj 58 & 7.00676 & 6.16 & 13.93 \\ 


for r=7:10
    fprintf(1,'Rib %d & %.2f & %.2f & %.2f \\\\ \n',r,mean(errorRib{r}) ,std(errorRib{r}) ,prctile(errorRib{r},90))
    
end

Rib 7 & 6.27 & 5.00 & 12.57 \\ 
Rib 8 & 4.75 & 4.58 & 8.44 \\ 
Rib 9 & 5.01 & 4.99 & 9.96 \\ 
Rib 10 & 6.13 & 8.28 & 11.79 \\ 


