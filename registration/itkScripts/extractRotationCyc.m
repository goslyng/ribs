

function  extractRotationCyc(s,params,midFix)


registrationPath = [params.dataPathUnix num2str(s) '/rib_registration/'];
ribs=params.ribs;

        
        
%%

for r=ribs
    
    
    angles_{r}=[];
    trans_{r}=[];
    cntr_{r}=[];
  

    for cyc = params.okCycles

        outputFile=[ registrationPath 'results/' midFix '/output' num2str(s) '_' num2str(r) '_' num2str(cyc) '.txt'];
        fid = fopen(outputFile);
        if fid<0
            cyc
        else
            if ismember(s,[26 ])
                [angles{r}{cyc}, trans{r}{cyc}, cntr{r}{cyc}] =readRegResults19(fid);% readRegResults19(fid);
            else
                [angles{r}{cyc}, trans{r}{cyc}, cntr{r}{cyc}] =readRegResults(fid);% readRegResults19(fid);

            end
            fclose(fid);
            angles_{r} = [angles_{r} angles{r}{cyc}];
            trans_{r}  = [trans_{r}  trans{r}{cyc}];
            cntr_{r}   = [cntr_{r}  cntr{r}{cyc}];
        end
    
        
    end
    
end

%%
save([params.dataPathUnix num2str(s) '/motionfields/ribsMotion' midFix],'trans','trans_','angles','angles_','cntr_','cntr');

