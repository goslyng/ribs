
mriSubjects = [18 19 23:28 31:34 50:54 56:59];

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
    5.7752   -0.7187         0
    4.2104   -0.5931         0
    7.4875   -0.6312         0
    3.2124   -0.7761         0
    4.2998   -0.7001         0
    5.8779   -0.7625         0
    7.8719   -0.6209         0
   18.9393   -0.7044         0
   11.0589   -0.6228         0
    8.8464   -0.6031         0
   10.5649   -0.6768         0
    4.7039   -0.7446         0
    6.0043   -0.6621         0
    5.3472   -0.7478         0
    6.1648   -0.5594         0
   13.7536   -0.5606         0
   12.3962   -0.6850         0
   13.2207   -0.4463         0
    8.3766   -0.6611         0

%%
%     c=0;
%     validFiles=[];
%     for i=1:length(dataFiles)
%     %     if strfind(dataFiles(1).date,'30-Sep-2013') || strfind(dataFiles(1).date,'01-Oct-2013')
%             token = strfind(dataFiles(i).name,'nHyps');
%             nHyps{m}(i) = str2num(dataFiles(i).name(token+5:end-4));
%             if strfind(dataFiles(i).date,'Nov')
%                 c=c+1;
%                 fileDate{m}(c)=dataFiles(i).datenum;
%                 validFiles=[validFiles i];
%             end
%     %         [p_best{m}{i} res{m}{i} ]= printResults(m,nHyps(i));
%     %     end
%     end
%     if c>0
%         [~,b]=max(fileDate{m});
%    
% %     [~, resMM{m},errorsM{m} ]= printResults(m,nHyps{m}(b),'Hypo');
%     if ~isempty(b)
%         [~, resMM{m},errorsM{m} ]= displayResults(m,nHyps{m}(validFiles(b)),1,0);
%     end
%     end
% displayResults(m,nHyps,nBest,fgNum)


for m=mriSubjects(8:end)


        [~, resMM{m},errorsM{m} ]= displayResults(m,5,1,0);
  
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
Subj 18 & 4.35764 & 3.59 & 8.07 \\ 
Subj 19 & 4.21044 & 2.28 & 7.75 \\ 
Subj 23 & 6.73714 & 3.74 & 11.00 \\ 
Subj 24 & 2.86807 & 1.82 & 4.96 \\ 
Subj 25 & 4.29978 & 2.15 & 7.48 \\ 
Subj 26 & 5.42837 & 4.73 & 9.16 \\ 
Subj 27 & 10.09860 & 11.15 & 23.25 \\ 
Subj 28 & 5.82143 & 9.94 & 13.02 \\ 
Subj 31 & 12.83038 & 8.31 & 24.07 \\ 
Subj 32 & 11.00705 & 10.16 & 22.26 \\ 
Subj 33 & 6.81362 & 6.90 & 19.28 \\ 
Subj 34 & 4.70394 & 3.15 & 9.35 \\ 
Subj 50 & NaN & NaN & NaN \\ 
Subj 51 & 4.31841 & 2.66 & 8.13 \\ 
Subj 52 & 5.72921 & 3.78 & 12.13 \\ 
Subj 53 & 9.16321 & 8.70 & 26.05 \\ 
Subj 54 & 6.20959 & 4.84 & 14.54 \\ 
Subj 56 & 10.76919 & 8.74 & 23.77 \\ 
Subj 57 & 11.00807 & 6.14 & 18.99 \\ 
Subj 58 & 7.79557 & 4.77 & 14.81 \\ 
%%


for r=7:10
    
    errorRib{r}=[]

    for m=mriSubjects([1 3:12 14:20])
        errorRib{r} =[errorRib{r} errorsM{m}{r}];
    end
end

for m=mriSubjects
    X = cell2mat(errorsM{m});
    X=X;
    fprintf(1,'Subj %d & %.5f & %.2f & %.2f \\\\ \n',m,mean(X) ,std(X) ,prctile(X,90))
    
end
Subj 18 & 4.82 & 4.20 & 9.15 \\ 
Subj 19 & NaN & NaN & NaN \\ 
Subj 23 & 4.04 & 2.12 & 6.73 \\ 
Subj 24 & 4.54 & 2.14 & 7.30 \\ 
Subj 25 & 4.83 & 3.03 & 9.55 \\ 
Subj 26 & 5.32 & 4.66 & 9.84 \\ 
Subj 27 & 8.93 & 6.97 & 18.85 \\ 
Subj 28 & 8.16 & 11.23 & 20.73 \\ 
Subj 31 & 20.59 & 18.61 & 49.97 \\ 
Subj 32 & 16.86 & 9.79 & 30.62 \\ 
Subj 33 & 13.62 & 10.08 & 29.70 \\ 
Subj 34 & 5.52 & 3.69 & 12.08 \\ 
Subj 50 & NaN & NaN & NaN \\ 
Subj 51 & 4.32 & 2.66 & 8.13 \\ 
Subj 52 & 5.73 & 3.78 & 12.13 \\ 
Subj 53 & 9.16 & 8.70 & 26.05 \\ 
Subj 54 & 6.21 & 4.84 & 14.54 \\ 
Subj 56 & 10.77 & 8.74 & 23.77 \\ 
Subj 57 & 11.01 & 6.14 & 18.99 \\ 
Subj 58 & 7.80 & 4.77 & 14.81 \\ 

for r=7:10
    fprintf(1,'Rib %d & %.2f & %.2f & %.2f \\\\ \n',r,mean(errorRib{r}) ,std(errorRib{r}) ,prctile(errorRib{r},90))
    
end
Rib 7 & 11.51 & 10.02 & 27.85 \\ 
Rib 8 & 8.21 & 8.48 & 17.93 \\ 
Rib 9 & 6.13 & 5.99 & 13.57 \\ 
Rib 10 & 7.97 & 9.52 & 15.30 \\ 

Rib 7 & 7.87 & 6.87 & 16.23 \\ 
Rib 8 & 8.17 & 6.82 & 17.61 \\ 
Rib 9 & 7.21 & 6.13 & 15.91 \\ 
Rib 10 & 9.19 & 8.63 & 23.16 \\

 %%
Y=[]
for m=1:length(mriSubjects)
      X = cell2mat(resMM{mriSubjects(m)}');
      [~,b]=max(fileDate{mriSubjects(m)}) 
Y=[Y;X(b,:)];
end

Y=[ mriSubjects' Y]


   10.7027   -0.7097   -0.7854
   10.1140   -0.4503   -0.7636
    6.9023   -0.5939   -0.8711
   10.3079   -0.6583   -0.6851
    6.1116   -0.6839   -0.8257
    6.8320   -0.7289   -0.7962
   11.6730   -0.6805   -0.6161
   14.0366   -0.6858   -0.9095
   12.8807   -0.6490   -0.7856
    6.9077   -0.7266   -0.8238
   16.6657   -0.5519   -0.8114
   11.2396   -0.5180   -0.7145
    8.1347   -0.6815   -0.7616
   14.1999   -0.6569   -0.8111
    3.5434   -0.7661   -0.8640
    3.8635   -0.7182   -0.8585
    9.4105   -0.6065   -0.8573
    5.7822   -0.5605   -0.5940
    6.8763   -0.5131   -0.6845
   10.7027   -0.7097   -0.7854
   10.1140   -0.4503   -0.7636
    7.0770   -0.6219   -0.6885
   20.7488   -0.6501   -0.7021


%%



for m=mriSubjects(3:end)

% dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/ribCage_' num2str(m) '*'])

dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/Hypo' num2str(m) '*'])
for i=1:length(dataFiles)
%      if ~isempty(strfind(dataFiles(i).date,'14-Oct-2013')) || ~isempty(strfind(dataFiles(i).date,'15-Oct-2013'))
        token = strfind(dataFiles(i).name,'nHyps');
        nHyps{m}(i) = str2num(dataFiles(i).name(token+5:end-4));
        fileDate{m}(i)=dataFiles(i).datenum;
%         [~,b]=max(fileDate{m});
%          [p_best{m}{i} res{m}{i} ]= printResults(m,nHyps{m}(b),'Hypo',1);
%      end
end
      [~,b]=max(fileDate{m});
      [~, resMM{m},errorsM{m} ]= printResults(m,nHyps{m}(b),'Hypo');

end


for r=7:10
    
    errorRib{r}=[]

    for m=mriSubjects(3:end)
        errorRib{r} =[errorRib{r} errorsM{m}{r}];
    end
end

for m=mriSubjects(3:end)
    X = cell2mat(errorsM{m});
    fprintf(1,'Subj %d & %.2f & %.2f & %.2f \\\\ \n',m,mean(X) ,std(X) ,prctile(X,90))
    
end


