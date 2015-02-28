

function [err_cyc, err_cyc_states, err_initial] = computeP(s,params,midFix)


registrationPath = [params.dataPathUnix num2str(s) '/rib_registration/'];
outputTranslationFile=[ registrationPath 'results/translation_spine_' num2str(s)  ];
ribs=params.ribs;
%%
load(outputTranslationFile,'initialTranslation','initialRotation','t_','moved_center');                       


load([params.dataPathUnix num2str(s) '/motionfields/ribsMotion' midFix],'trans','trans_','angles','angles_','cntr','cntr_');
clear P;
o = [3 1 2];
err_cyc_states=[];
err_initial=[];
for r=ribs
    
    err_cyc{r}=[];
    ExhRibPath = [params.dataPathUnix num2str(s) '/ribs/RibRight' params.stateMiddleFix 'New' num2str(r)];
    ribsExh{r} = readVTKPolyDataPoints(ExhRibPath);
    ribsExh{r} = ribsExh{r}(:,end-99:end);
    firstPoint = ribsExh{r}(:,1);
    
    NCS = findRotaionMatrixNew(ribsExh{r});
    j=0;
    for cyc = params.okCycles%cycleinfo.nCycs
%         j= params.cycleinfo.cyclestarts(cyc);
%         firstPoint = moved_center{r}(:,cyc);
        
        
        for i=1: size(angles{r}{cyc},2)
            
            
            firstPoint = cntr{r}{cyc}(:,i); 
            if firstPoint(1)==-99
                firstPoint=ribsExh{r}(:,1);
            end
            firstPointOffset = repmat(firstPoint,1,100);

            ribPoints = ribsExh{r} -  firstPointOffset ;
            M = findEulerO(angles{r}{cyc}(:,i),params.o,0);
%             M = findEulerXfirst(angles{r}{cyc}(1,i),angles{r}{cyc}(2,i),angles{r}{cyc}(3,i)); % itk default order is ZXY
%             M = findEuler(angles_net{cyc}{r}(:,i));
             tmp= M * ribPoints +  repmat(firstPoint + trans{r}{cyc}(:,i),1,100) ;%;+trans{r}{cyc}(:,i) ,1,100);%+ 
            j=j+1;
            [a(r,j) b(r,j) c(r,j)]=findEulerO(NCS' * M * NCS,[2 1 3],1);

            P{r}(:,:,j)=tmp;% - ribsExh{r}(:,100);

        end
        if  (params.cycleinfo.nStates(cyc) ~= size(angles{r}{cyc},2) )
            display(['incomplete cycle ' num2str(cyc)]);
            err_cyc{r} = [ err_cyc{r} cyc];
            err_cyc_states{r}{cyc} =( size(angles{r}{cyc},2)+1):params.cycleinfo.nStates(cyc);
            if size(angles{r}{cyc},2) >0
            err_initial{r}{cyc} = [angles{r}{cyc}(:,end); trans{r}{cyc}(:,end)];
            else
            err_initial{r}{cyc} = zeros(6,1);
                
            end

        end
        if size(angles{r}{cyc},2) >0
        if ( any(angles{r}{cyc}(1,:)==-99) ||  all(angles{r}{cyc}(1,:)==0)) 
            display(['incomplete cycle ' num2str(cyc)]);
            ind= find(angles{r}{cyc}(1,:)==-99);
            err_cyc{r} = [ err_cyc{r} cyc];
            err_cyc_states{r}{cyc} =1:params.cycleinfo.nStates(cyc);
            err_initial{r}{cyc} = zeros(6,1);
        end
        end
        j = j + params.cycleinfo.nStates(cyc) - size(angles{r}{cyc},2);
        % 
    end

end

save([params.dataPathUnix num2str(s) '/motionfields/ribsMotion' midFix],'P','trans','trans_','angles','angles_','cntr','cntr_');

%%
figure;subplot(4,1,1);plot(a(7,:))
hold on;subplot(4,1,2);plot(a(8,:))
hold on;subplot(4,1,3);plot(a(9,:))
hold on;subplot(4,1,4);plot(a(10,:))

figure;subplot(4,1,1);plot(b(7,:))
hold on;subplot(4,1,2);plot(b(8,:))
hold on;subplot(4,1,3);plot(b(9,:))
hold on;subplot(4,1,4);plot(b(10,:))


figure;subplot(4,1,1);plot(c(7,:))
hold on;subplot(4,1,2);plot(c(8,:))
hold on;subplot(4,1,3);plot(c(9,:))
hold on;subplot(4,1,4);plot(c(10,:))

