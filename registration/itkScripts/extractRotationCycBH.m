

function  extractRotationCycBH(s,params,okCycles,midFix)


registrationPath = [params.dataPathUnix num2str(s) '/rib_registration/'];
outputTranslationFile=[ registrationPath 'results/translation_spine_' num2str(s)  ];
ribs=params.ribs;
%%
load(outputTranslationFile,'initialTranslation','initialRotation','t_','moved_center');                       
for r=ribs
    angles_{r}=[];
    trans_{r}=[];
    ExhRibPath = [params.dataPathUnix num2str(s) '/ribs/RibRight' params.stateMiddleFix 'New' num2str(r)];
    pExh = readVTKPolyDataPoints(ExhRibPath);
    c = pExh(:,1);
        state=0;

    for cyc = okCycles
        failure=0;
        outputFile=[ registrationPath 'results/' midFix '/output' num2str(s) '_' num2str(r) '_' num2str(cyc) '.txt'];

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
        while ischar(tline)

            pointerX = (strfind(tline , 'angle X      = '));

            if (~isempty(pointerX))

                aX = str2double(tline(pointerX+16:end));
                tline = fgets(fid);
                pointerY = (strfind(tline , 'angle Y      = '));
                aY = str2double(tline(pointerY+16:end));
                tline = fgets(fid);

                pointerZ = (strfind(tline , 'angle Z      = '));
                aZ = str2double(tline(pointerZ+16:end));
                
                
                tline = fgets(fid);
                pointerX = (strfind(tline , 'Translation X = '));
                tX = str2double(tline(pointerX+16:end));
                tline = fgets(fid);
                pointerY = (strfind(tline , 'Translation Y = '));
                tY = str2double(tline(pointerY+16:end));
                tline = fgets(fid);

                pointerZ = (strfind(tline , 'Translation Z = '));
                tZ = str2double(tline(pointerZ+16:end));                
                
                
                R = findEuler(initialRotation(:,cyc));
              
                R_combined = findEuler([aX; aY; aZ]);
                R_net = R_combined * R';
                [aX_net, aY_net, aZ_net]=findEuler(R_net);
                
                angles_net{cyc}{r}= [angles_net{cyc}{r} [aX_net; aY_net; aZ_net] ];%[aX; aY; aZ]];
                angles{r}{cyc}= [angles{r}{cyc} [aX; aY; aZ] ];%[aX; aY; aZ]];
                
                
               state=state+1;

%                 t_combined(:,state) = [tX; tY; tZ];
%                 t_net(:,state)= t_combined(:,state) - t_{r}(:,cyc) ;
%                 d_c(:,state) = R_net' * t_net(:,state);
                trans{r}{cyc}= [trans{r}{cyc} [tX; tY; tZ]];
                trans_net{r}{cyc}= [trans_net{r}{cyc} [tX; tY; tZ]-initialTranslation(:,cyc)];

            end  
            tline = fgets(fid);

        end
        angles_{r}=[angles_{r}  angles{r}{cyc}];
        trans_{r}=[trans_{r}  trans{r}{cyc}];
        
        if ~failure
        fclose(fid);
        end

        %     end

    end
end
% figure;plot(angles_{7}(1,20:end))
% figure;plot(angles_{7}(2,20:end))
% 
% figure; hold on;
% for r=7:10
%     figure
%     plot(angles_{r}(3,:),colors{r-6})
% end
%%
save([params.dataPathUnix num2str(s) '/motionfields/ribsMotion' midFix],'trans','trans_','angles','angles_','trans_net','angles_net');

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



