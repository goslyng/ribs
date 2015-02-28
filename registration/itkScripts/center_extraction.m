


    load(params{s}.outputTranslationFile,'initialTranslation','initialRotation','t_');
load([dataPathUnix num2str(s) '/motionfields/ribsMotion'],'angles','trans')
    
tt=[];
for i=1:20
    clear t_temp;
    t_temp(1,:) = (trans{r}{i}(1,:) - t_{r}(1,i));
    t_temp(2,:) = (trans{r}{i}(2,:) - t_{r}(2,i));
    t_temp(3,:) = (trans{r}{i}(3,:) - t_{r}(3,i));
    
    tt = [tt  t_temp];
    
end
figure;plot(tt')
trans_{r}

angles_{r}


%%
for i=1:30

    clear t_temp;
    t_temp(1,:) = trans{r}{i}(1,:) - trans{r}{i}(1,1);%t_{r}(1,i);%;
    t_temp(2,:) = trans{r}{i}(2,:) - trans{r}{i}(2,1);%t_{r}(2,i);%;
    t_temp(3,:) = trans{r}{i}(3,:) - trans{r}{i}(3,1);% t_{r}(3,i);%;
    
    
    clear R; clear I_R;clear t; 
    for j=1:size(angles{r}{i},2)
        R_= findEulerXfirst(angles{r}{i}(1,j),angles{r}{i}(2,j),angles{r}{i}(3,j),2);
        I_R ((j-1)*3 + (1:3),:)= eye(3) - R_';
    end
    
    t =t_temp(:);
  
   
    c_(:,i) = findCenter(I_R,t);
%     c_(:,i) =  I_R  \ t;
    I_R *  c_(:,i) - t
    
%     figure;plot(t_temp(1,:)')
     figure(1);plot(reshape(t,3,[])'); axis([0 length(t)/3 min(t)-1 max(t)+1])
     
     figure(2);plot(reshape(I_R * c_(:,i) ,3,[])');axis([0 length(t)/3 min(t)-1 max(t)+1])
%      input('hi')
     pause(0.1)
%     repmat(c_,size(angles{r}{i},2),1) - R *  c_;
end
%%
figure;plot(t_temp')


clear R; clear t; clear c_; clear I_R 
for i=1:300
    R ((i-1)*3 + (1:3),:)= (findEulerXfirst(angles_{r}(2,i),angles_{r}(1,i),angles_{r}(3,i),2));
    I_R ((i-1)*3 + (1:3),:)= eye(3) - R((i-1)*3 + (1:3),:)';
    % t((i-1)*3 + (1:3),1) =trans_{r}(:,i);
    t((i-1)*3 + (1:3),1) =tt(:,i);
%     c_(:,i) = (eye(3)- R ((i-1)*3 + (1:3),:)) \ trans_{r}(:,i);
end

 f = mean(sqrt(sum(reshape(t,3,[]).^2)))
    [ c, fval]=  findCenter(I_R,t)
dc = I_R\ t

dt = reshape(t- I_R*dc,3,[])';
figure;plot(dt)
figure;plot(tt(:,1:300)')

clear R; clear t; clear c_; clear I_R 
for i=1:300
    R ((i-1)*3 + (1:3),:)= findEulerXfirst(angles_{r}(2,i),angles_{r}(1,i),angles_{r}(3,i),2);
    I_R ((i-1)*3 + (1:3),:)= eye(3) - R ((i-1)*3 + (1:3),:);
    % t((i-1)*3 + (1:3),1) =trans_{r}(:,i);
    t((i-1)*3 + (1:3),1) =tt(:,i);
    c_(:,i) = (eye(3)- R ((i-1)*3 + (1:3),:)) \ trans_{r}(:,i);
end


dc = I_R\ t

dt = reshape(t- I_R*dc,3,[])';
figure;plot(dt)
figure;plot(tt(:,1:300)')

dc = R\t ;
dt = reshape(t- R*dc,3,[])'
figure;plot(dt)
figure;plot(trans_{r}(1,1:300))
figure;plot(initialTranslation(:,1:100)')
figure;plot(c_')

 c = pExh(:,1);
        state=0;
            for r=7:8
            for cyc = okCycles
                t_(:,cyc,r) = trans{cyc}{r}(:,1);
                a_(:,cyc,r) = angles{cyc}{r}(:,1);
            end
            end
