
mriSubjects = [18 19 23:28 31 33:34 50:54 56:59];

%%
for m=mriSubjects%     dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/ribCage_' num2str(m) '*']);
%     dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/Hypo' num2str(m) '*'])
    try
        [~, b]=displayResults(m,7,1,0);
        err(m,:) = b{1};
    catch
        m
    end
end

for m=mriSubjects

        [~, resMM{m},errorsM{m} ]= displayResults(m,7,1,0);
  
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
Subj 18 & 6.57137 & 3.36 & 9.62 \\ 
Subj 19 & 5.38417 & 3.02 & 9.56 \\ 
Subj 23 & 3.78378 & 3.05 & 7.47 \\ 
Subj 24 & 7.15656 & 4.36 & 13.71 \\ 
Subj 25 & 4.76216 & 3.55 & 10.24 \\ 
Subj 26 & 3.55583 & 1.70 & 6.11 \\ 
Subj 27 & 4.07028 & 4.10 & 6.65 \\ 
Subj 28 & 8.29735 & 11.23 & 18.77 \\ 
Subj 31 & 4.56960 & 3.00 & 7.11 \\ 
Subj 33 & 6.08585 & 5.06 & 11.91 \\ 
Subj 34 & 3.13844 & 1.56 & 5.12 \\ 
Subj 50 & 7.16212 & 3.14 & 12.20 \\ 
Subj 51 & 4.19927 & 1.64 & 6.32 \\ 
Subj 52 & 3.74105 & 2.20 & 6.63 \\ 
Subj 53 & 5.03217 & 2.30 & 8.10 \\ 
Subj 54 & 10.29241 & 6.53 & 20.08 \\ 
Subj 56 & 8.06049 & 5.29 & 17.07 \\ 
Subj 57 & 9.39745 & 6.35 & 15.93 \\ 
Subj 58 & 9.48925 & 6.53 & 16.16 \\ 
Subj 59 & 7.14489 & 4.76 & 11.63 \\ 



for r=7:10
    fprintf(1,'Rib %d & %.2f & %.2f & %.2f \\\\ \n',r,mean(errorRib{r}) ,std(errorRib{r}) ,prctile(errorRib{r},90))
    
end

Rib 7 & 6.27 & 5.00 & 12.57 \\ 
Rib 8 & 4.75 & 4.58 & 8.44 \\ 
Rib 9 & 5.01 & 4.99 & 9.96 \\ 
Rib 10 & 6.13 & 8.28 & 11.79 \\ 


