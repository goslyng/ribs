

nsamps(18)=13394;
nsamps(19)=40586;

nsamps(23) = 9839;
nsamps(24) = 
nsamps(28) = 



nsamps(50) = 2107;
nsamps(51) = 3711;%30708
% nsamps(52)=
nsamps(53)=2749;%4335
nsamps(54)=763;%3073
nsamps(56)=49235;
nsamps(57)=14245%14138
nsamps(58)=5727;
nsamps(59)=24776;%17506;

for m=mriSubjects

    % dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/ribCage_' num2str(m) '*'])

    dataFiles=dir(['/usr/biwinas01/scratch-g/sameig/Ribs/Hypo' num2str(m) '*'])
    for i=1:length(dataFiles)
    %     if strfind(dataFiles(1).date,'30-Sep-2013') || strfind(dataFiles(1).date,'01-Oct-2013')
            token = strfind(dataFiles(i).name,'nHyps');
            nHyps{m}(i) = str2num(dataFiles(i).name(token+5:end-4));
            fileDate{m}(i)=dataFiles(i).datenum;

    %         [p_best{m}{i} res{m}{i} ]= printResults(m,nHyps(i));
    %     end
    end
    
    [~,b]=max(fileDate{m});
    [~, resMM{m},errorsM{m} ]= printResults(m,nHyps{m}(b),'Hypo');

end



for r=7:10
    
    errorRib{r}=[]

    for m=mriSubjects
        errorRib{r} =[errorRib{r} errorsM{m}{r}];
    end
end

for m=mriSubjects
    X = cell2mat(errorsM{m});
    fprintf(1,'Subj %d & %.2f & %.2f & %.2f \\\\ \n',m,mean(X) ,std(X) ,prctile(X,90))
    
end
Subj 18 & 6.90 & 3.96 & 11.46 \\ 
Subj 19 & 10.31 & 8.14 & 22.15 \\ 
Subj 23 & 7.06 & 5.83 & 14.63 \\ 
Subj 24 & 5.55 & 3.51 & 10.54 \\ 
Subj 25 & 7.10 & 4.51 & 14.31 \\ 
Subj 26 & 5.92 & 6.09 & 12.91 \\ 
Subj 27 & 9.20 & 7.10 & 18.48 \\ 
Subj 28 & 6.91 & 6.48 & 12.28 \\ 
Subj 31 & 16.67 & 12.68 & 37.18 \\ 
Subj 32 & 11.24 & 9.03 & 25.38 \\ 
Subj 33 & 8.81 & 8.25 & 25.64 \\ 
Subj 34 & 15.73 & 8.44 & 24.88 \\ 
Subj 50 & 3.54 & 2.67 & 8.69 \\ 
Subj 51 & 3.86 & 2.31 & 7.49 \\ 
Subj 52 & 9.41 & 6.58 & 19.51 \\ 
Subj 53 & 4.52 & 3.36 & 8.57 \\ 
Subj 54 & 6.88 & 4.03 & 12.05 \\ 
Subj 56 & 5.14 & 3.36 & 9.07 \\ 
Subj 57 & 9.30 & 6.76 & 19.51 \\ 
Subj 58 & 7.08 & 5.23 & 13.06 \\ 
Subj 59 & 9.18 & 5.81 & 17.06 \\ 

for r=7:10
    fprintf(1,'Rib %d & %.2f & %.2f & %.2f \\\\ \n',r,mean(errorRib{r}) ,std(errorRib{r}) ,prctile(errorRib{r},90))
    
end

Rib 7 & 7.87 & 6.87 & 16.23 \\ 
Rib 8 & 8.17 & 6.82 & 17.61 \\ 
Rib 9 & 7.21 & 6.13 & 15.91 \\ 
Rib 10 & 9.19 & 8.63 & 23.16 \\

 8.1095

stdn(cell2mat(errorRib))
Undefined function 'stdn' for input arguments of type 'double'.


ans =

    7.2055

prctile(cell2mat(errorRib),90)

ans =

   17.9584
   
   

7.870654 & 6.868844 & 16.225878 \ 
8.168860 & 6.818919 & 17.611665 \ 
7.209645 & 6.125897 & 15.907198 \ 
9.188797 & 8.632042 & 23.164575 \ errorsM

    7.8707    6.8688   16.2259




    8.1689    6.8189   17.6117



    7.2096    6.1259   15.9072



    9.1888    8.6320   23.1646
    
    

8
9
9
6
Y=[]
for m=1:length(mriSubjects)
      X = cell2mat(res{mriSubjects(m)}');
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


