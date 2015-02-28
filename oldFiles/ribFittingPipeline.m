s=57;
saveRec2HDR
resize_images_hdr(s)
clear writeImages
writeImages(s)

rib_fittin_mri_individualRib
setAngeModulOpt_temp
shapeModelingPipeline;

writeRFConfig  
setAngeModulOpt_temp(m,1)

setAngeModulNcc(m,compute,fitted)
%%
clear er
clear cost
mriSubjects
mriSubjects_=mriSubjects([1:5 7:16])

for m=mriSubjects_

%     close all;
    ribNumbers = 7:10;

    if m==59 || m==60
        ribNumbers = 8:10;
    end  

    [er1(m,ribNumbers), er2(m,ribNumbers),cost(m,ribNumbers),ribError1,ribError2]=displayAngleIndividualScale(m,1,3);
    errs1{m} = cell2mat(ribError1(ribNumbers));
    errs2{m} = cell2mat(ribError2(ribNumbers));
  
  
%     input(num2str(m));
end

allErrors1 = cell2mat(errs1);
allErrors2 = cell2mat(errs2);

for m=mriSubjects_
    fprintf(1,'%d & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',m,mean(errs1{m}(:)), '$\',std(errs1{m}(:)) ,prctile(errs1{m}(:),95),mean(errs2{m}(:)), '$\',std(errs2{m}(:)) ,prctile(errs2{m}(:),95),'\','\')
end

fprintf(1,'mean & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',mean(allErrors1(:)), '$\',std(allErrors1(:)) ,prctile(allErrors1(:),95),mean(allErrors2(:)), '$\',std(allErrors2(:)) ,prctile(allErrors2(:),95),'\','\')

    %%
clear er
clear cost
mriSubjects
mriSubjects_=mriSubjects([1:5 7:16])

allErrors1=[];
allErrors2=[];
allLenError=[];
for m=mriSubjects_

%     close all;
    
    ribNumbers = 7:10;

    if m==59 || m==60
        ribNumbers = 8:10;
    end  

    [er1(m,ribNumbers), er2(m,ribNumbers),cost(m,ribNumbers),ribError1,ribError2,lenError{m},outOfPlaneError{m}]=displayAngleIndividualScale(m,1,3,0);
    errs1{m}=[];
    errs2{m}=[];
  
    for r=ribNumbers
        errs1{m} = [errs1{m} ;ribError1{r}];
        errs2{m} = [errs2{m} ;ribError2{r}];
    end
  
    allLenError =[allLenError abs(lenError{m}((ribNumbers)))]
    allErrors1=[allErrors1   ;errs1{m}];
    allErrors2=[allErrors2   ;errs2{m}];
  
%     input(num2str(m));
end

outOfPlaneErrorAll = cell2mat(outOfPlaneError);
for m=mriSubjects_
    fprintf(1,'%d & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',m,mean(errs1{m}(:)), '$\',std(errs1{m}(:)) ,prctile(errs1{m}(:),95),mean(errs2{m}(:)), '$\',std(errs2{m}(:)) ,prctile(errs2{m}(:),95),'\','\')
end
fprintf(1,'mean & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',mean(allErrors1(:)), '$\',std(allErrors1(:)) ,prctile(allErrors1(:),95),mean(allErrors2(:)), '$\',std(allErrors2(:)) ,prctile(allErrors2(:),95),'\','\')

for m=mriSubjects_
  
    ribNumbers = 7:10;

    if m==59 || m==60
        ribNumbers = 8:10;
    end  
    lenErrorM=abs(lenError{m}((ribNumbers)));
    fprintf(1,'%d ', m)
    fprintf(1,'&    %.2f %spm$ & %.2f & ( %.2f )',mean(outOfPlaneError{m}), '$\',std(outOfPlaneError{m}(:)),prctile(outOfPlaneError{m}(:),95))
    fprintf(1,'&    %.2f %spm$ & %.2f & ( %.2f )',mean(errs1{m}(:))       , '$\',std(errs1{m}(:))          ,prctile(errs1{m}(:),95))
    fprintf(1,'&    %.2f %spm$ & %.2f & ( %.2f )',mean(lenErrorM)         , '$\',std(lenErrorM)            ,prctile(lenErrorM,95))
    fprintf(1,' %s%s \n ','\','\');

end
fprintf(1,'%shline\n','\');

fprintf(1,'mean');
fprintf(1,'&    %.2f %spm$ & %.2f & ( %.2f )',mean(outOfPlaneErrorAll),'$\',std(outOfPlaneErrorAll) ,prctile(outOfPlaneErrorAll,95))
fprintf(1,'&    %.2f %spm$ & %.2f & ( %.2f )',mean(allErrors1(:)), '$\',std(allErrors1(:)) ,prctile(allErrors1(:),95))
fprintf(1,'&    %.2f %spm$ & %.2f & ( %.2f )',mean(allLenError(:)), '$\',std(allLenError(:)) ,prctile(allLenError(:),95))
fprintf(1,' %s%s \n ','\','\');



%% Registration Error with NCC
fitted=1
compute=1
mriSubjectsBH=[60 63 64 65 66]

for m=mriSubjectsBH
    setAngeModulNcc(m,compute,0,fitted)
    input(num2str(m))
end
compute=0;

allErrorsNCC1=[];
allErrorsNCC2=[];
allLenErrorNCC=[];

for m=mriSubjectsBH
    ribNumbers = 7:10;
    if m==59 || m==60
        ribNumbers = 8:10;
    end 
   [erNcc1(m,ribNumbers), erNcc2(m,ribNumbers),ribErrorNCC1,ribErrorNCC2,lenErrorNCC{m} ]= setAngeModulNcc(m,compute,fitted);
   
    errsNCC1{m}=[];
    errsNCC2{m}=[];
  
    for r=ribNumbers
        errsNCC1{m} = [errsNCC1{m} ;ribErrorNCC1{r}];
        errsNCC2{m} = [errsNCC2{m} ;ribErrorNCC2{r}];

    end
  
    allLenErrorNCC =[allLenErrorNCC abs(lenErrorNCC{m}(ribNumbers))]
    allErrorsNCC1=[allErrorsNCC1   ;errsNCC1{m}];
    allErrorsNCC2=[allErrorsNCC2  ;errsNCC2{m}];

%     errsNCC1{m} = cell2mat(ribErrorNCC1(ribNumbers));
%    errsNCC2{m} = cell2mat(ribErrorNCC2(ribNumbers));
%     input(num2str(m))

end
% allErrorsNCC1 = cell2mat(errsNCC1);
% allErrorsNCC2 = cell2mat(errsNCC2);

for m=mriSubjectsBH
    fprintf(1,'%d & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',m,mean(errsNCC1{m}(:)), '$\',std(errsNCC1{m}(:)) ,prctile(errsNCC1{m}(:),95),mean(abs(lenError{m}(ribNumbers))), '$\',std(abs(lenError{m}(ribNumbers))) ,prctile(abs(lenError{m}(ribNumbers)),95),'\','\')
end
fprintf(1,'mean & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',mean(allErrorsNCC1(:)), '$\',std(allErrorsNCC1(:)) ,prctile(allErrorsNCC1(:),95),mean(allLenErrorNCC(:)), '$\',std(allLenErrorNCC(:)) ,prctile(allLenErrorNCC(:),95),'\','\')

%% Registration Error with RF
mriSubjectsBH=[60 63 64 65 66]

allErrorsRF1=[];
allErrorsRF2=[];
allLenErrorRF=[];
    
  
for m=mriSubjectsBH

    ribNumbers = 7:10;

    if m==59 || m==60
        ribNumbers = 8:10;
    end  
    figure;
   [erRF1(m,ribNumbers), erRF2(m,ribNumbers),cost(m,ribNumbers),ribErrorRF1,ribErrorRF2,lenErrorRF{m}]=displayAngleIndividualScale(m,1,2,1,1);
    errsRF1{m}=[];
    errsRF2{m}=[];
  
    for r=ribNumbers
        errsRF1{m} = [errsRF1{m} ;ribErrorRF1{r}];
        errsRF2{m} = [errsRF2{m} ;ribErrorRF2{r}];
    end
  
    allLenErrorRF =[allLenErrorRF abs(lenError{m}(ribNumbers))]
    allErrorsRF1=[allErrorsRF1   ;errsRF1{m}];
    allErrorsRF2=[allErrorsRF2  ;errsRF2{m}];
 
end

for m=mriSubjectsBH
    fprintf(1,'%d & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',m,mean(errsRF1{m}(:)), '$\',std(errsRF1{m}(:)) ,prctile(errsRF1{m}(:),95),mean(abs(lenError{m}((ribNumbers)))), '$\',std(abs(lenError{m}((ribNumbers)))) ,prctile(abs(lenError{m}((ribNumbers))),95),'\','\')
end
fprintf(1,'mean & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',mean(allErrorsRF1(:)), '$\',std(allErrorsRF1(:)) ,prctile(allErrorsRF1(:),95),mean(allLenErrorRF(:)), '$\',std(allLenErrorRF(:)) ,prctile(allLenErrorRF(:),95),'\','\')
%% Amplitude of Motion

for m=mriSubjectsBH

motionAmps{m} = motionAmp(m);
end



%%

for m=mriSubjectsBH
    fprintf(1,'%d & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )   &',m,mean(errsNCC1{m}(:)), '$\',std(errsNCC1{m}(:)) ,prctile(errsNCC1{m}(:),95),mean(errsNCC2{m}(:)), '$\',std(errsNCC2{m}(:)) ,prctile(errsNCC2{m}(:),95))
    fprintf(1,' %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n',mean(errsRF1{m}(:)), '$\',std(errsRF1{m}(:)) ,prctile(errsRF1{m}(:),95),mean(errsRF2{m}(:)), '$\',std(errsRF2{m}(:)) ,prctile(errsRF2{m}(:),95),'\','\')
end
fprintf(1,'%shline \n','\')
fprintf(1,'mean & %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )   &',mean(allErrorsNCC1(:)), '$\',std(allErrorsNCC1(:)) ,prctile(allErrorsNCC1(:),95),mean(allErrorsNCC2(:)), '$\',std(allErrorsNCC2(:)) ,prctile(allErrorsNCC2(:),95))
fprintf(1,' %.2f %spm$ %.2f ( %.2f ) &  %.2f %spm$ %.2f ( %.2f )  %s%s \n', mean(allErrorsRF1(:)), '$\',std(allErrorsRF1(:)) ,prctile(allErrorsRF1(:),95),mean(allErrorsRF2(:)), '$\',std(allErrorsRF2(:)) ,prctile(allErrorsRF2(:),95),'\','\')

%%

motionAmpsAll = cell2mat(motionAmps');
for m=mriSubjectsBH
 ribNumbers = 7:10;

    if m==59 || m==60
        ribNumbers = 8:10;
    end 

    fprintf(1,'%d & ',m);
    fprintf(1,'%.2f %spm$ & %.2f & ( %.2f ) &',mean(errsNCC1{m}(:)), '$\',std(errsNCC1{m}(:)) ,prctile(errsNCC1{m}(:),95));
    %fprintf(1,'%.2f %spm$ & %.2f & ( %.2f ) &',mean(abs(lenErrorNCC{m}(ribNumbers))), '$\',std(abs(lenErrorNCC{m}(ribNumbers))) ,prctile(abs(lenErrorNCC{m}(ribNumbers)),95));
    fprintf(1,'%.2f %spm$ & %.2f & ( %.2f ) &',mean(errsRF1{m}(:)), '$\',std(errsRF1{m}(:)) ,prctile(errsRF1{m}(:),95));
    %fprintf(1,'%.2f %spm$ & %.2f & ( %.2f )  ',mean(abs(lenErrorRF{m}((ribNumbers)))), '$\',std(abs(lenErrorRF{m}((ribNumbers)))) ,prctile(abs(lenErrorRF{m}((ribNumbers))),95));
    fprintf(1,'%.2f %spm$ & %.2f & ( %.2f ) &',mean(motionAmps{m}(:)), '$\',std(motionAmps{m}(:)) ,prctile(motionAmps{m}(:),95));
    fprintf(1,' %s%s \n','\','\');
end
fprintf(1,'%shline \n','\');
fprintf(1,'mean & ');
fprintf(1,'%.2f %spm$ %.2f ( %.2f ) &',mean(allErrorsNCC1(:)), '$\',std(allErrorsNCC1(:)) ,prctile(allErrorsNCC1(:),95));
%fprintf(1,'%.2f %spm$ %.2f ( %.2f ) &',mean(allLenErrorNCC(:)), '$\',std(allLenErrorNCC(:)) ,prctile(allLenErrorNCC(:),95));
fprintf(1,'%.2f %spm$ %.2f ( %.2f ) &', mean(allErrorsRF1(:)), '$\',std(allErrorsRF1(:)) ,prctile(allErrorsRF1(:),95));
%fprintf(1,'%.2f %spm$ %.2f ( %.2f ) &',mean(allLenErrorRF(:)), '$\',std(allLenErrorRF(:)) ,prctile(allLenErrorRF(:),95));
fprintf(1,'%.2f %spm$ %.2f ( %.2f ) &', mean(motionAmpsAll), '$\',std(motionAmpsAll) ,prctile(motionAmpsAll,95));
fprintf(1,' %s%s \n','\','\');

