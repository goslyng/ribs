

function  extractTransCycRibs(s,params,okCycles,midFix)


registrationPath = [params.dataPathUnix num2str(s) '/rib_registration/'];
outputTranslationFile=[ registrationPath 'results/translation_spine_' num2str(s)  ];
ribs=params.ribs;
%%
load(outputTranslationFile,'initialTranslation','initialRotation','t_','moved_center');                       
 params.outputPrefix = [params.registrationPathLinux '/results/output_rib'];
 
 
for r=ribs
    angles_{r}=[];
    trans_{r}=[];
    state=0;

    for cyc = okCycles
        failure=0;
        outputFile=[params.outputPrefix num2str(s) '_' num2str(r) '_' num2str(cyc) '.txt'];

        fid = fopen(outputFile);
        try
            tline = fgets(fid);
        catch
            cyc
            tline=[];
            failure=1;
        end
        X=[];
        Y=[];
        Z=[];
        flag=-1;
        angles{r}{cyc}=[];
        angles_net{cyc}{r}=[];
        trans{r}{cyc}=[];
        trans_net{r}{cyc}=[];

        angXToken = 'angle X      = ';
        angYToken = 'angle Y      = ';
        angZToken = 'angle Z      = ';
        
        tranXToken='Translation X = ';
        tranYToken='Translation Y = ';
        tranZToken='Translation Z = ';
        
        while ischar(tline)

            pointerX = (strfind(tline , angXToken));

            if (~isempty(pointerX))

                aX = str2double(tline(pointerX+length(angXToken):end));
                tline = fgets(fid);
                pointerY = (strfind(tline , angYToken));
                aY = str2double(tline(pointerY+length(angYToken):end));
                tline = fgets(fid);

                pointerZ = (strfind(tline , angZToken));
                aZ = str2double(tline(pointerZ+length(angZToken):end));
                
                
                tline = fgets(fid);
                pointerX = (strfind(tline ,tranXToken ));
                tX = str2double(tline(pointerX+length(tranXToken):end));
                tline = fgets(fid);
                pointerY = (strfind(tline , tranYToken));
                tY = str2double(tline(pointerY+length(tranYToken):end));
                tline = fgets(fid);

                pointerZ = (strfind(tline , tranZToken));
                tZ = str2double(tline(pointerZ+length(tranZToken):end));                
                
                
                
                
               state=state+1;

                trans{r}{cyc}= [trans{r}{cyc} [tX; tY; tZ]];
                
            end  
            tline = fgets(fid);

        end
        trans_{r}=[trans_{r}  trans{r}{cyc}];
        
        if ~failure
        fclose(fid);
        end

        %     end

    end
end
%%
save([params.dataPathUnix num2str(s) '/motionfields/ribsMotion_rib' midFix],'trans','trans_');

%%

% displayRegistration;
%     figure;
% hold on;
% for r=7:10
%     [a,b,c]=princomp(P(:,:,r)')
% 
%     plot(b(35:end,1),colors{r-6})
% 
% end
% figure;plot(b(:,1))
%%
% figure;hold on;
% for i=1:size(b,1)
% plot(b(1:i,1),b(1:i,2))
% axis equal
% pause(0.1)
% 
% end
% figure;
%     plot(squeeze(P(2,:)))



