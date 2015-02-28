

% s=51

load([params.dataPathUnix num2str(s) '/motionfields/ribsMotion'],'P');
% load([dataPathUnix num2str(s)  '/allcycles_nrig10_masked.mat'],'cycleinfo')

colors = {'b','r','g','m'};
colorsd = {'b.','r.','g.','m.'};
states = params.cycleinfo.cyclestarts(okCycles(1)): params.cycleinfo.cyclestarts(okCycles(end));
states=states(2:end);
% states=states(2:110);
% states = cycleinfo.cyclestarts(5): cycleinfo.cyclestarts(6)-1


% states = 100 : 900;
% states = 1 : 20;
%%
PP  = permute(P,[3 2 1]);
% close all
for dim=1:3
    figure(dim*s); hold on;
    title([num2str(s) 'rib motion'])

    for r=ribs

        cor = corrcoef([squeeze(PP(7,states,:)) squeeze(PP(r,states,:))]);
        cor(1:3,4:6)
        subplot(4,1,r-6)
        plot(squeeze(P(dim,states,r)),colors{r-6})
        hold on
        plot(squeeze(P(dim,states,r)),colorsd{r-6})
        title(num2str(cor(dim,3+dim)))
        axis tight
    end
      figure(s); hold on;
    title([num2str(s) 'rib motion'])
end
size(P)
%%
PP  = permute(P,[3 2 1]);
% close all

%     states = 30:90
    for r=ribs
        [aa{r}, bb{r}, cc{r}]=princomp(P(:,states,r)')
    end
    %%
      figure(10*s); hold on;
    title([num2str(s) 'rib motion'])

    for r=ribs

        cor = corrcoef([bb{r}(:,1) bb{8}(:,1)]);
%         cor(1:3,4:6)
        subplot(4,1,r-6)
        plot(bb{r}(:,1),colors{r-6})
        hold on
        plot(bb{r}(:,1),colorsd{r-6})
        title(num2str(cor(1,2)))
        axis tight
    end
  figure(10*s); hold on;
    title([num2str(s) 'rib motion'])

size(P)
%%
% figure; hold on;
% title([num2str(s) 'rib angle'])
% 
% 
% for r=7:10
%     subplot(4,1,r-6)
%     cor = corrcoef(angles_{7}(3,states),angles_{r}(3,states))
%     plot(squeeze( angles_{r}(3,states)),colors{r-6})
%  title(num2str(cor(1,2)))
% end

%%

% 
% 
% figure; hold on;
% title([num2str(s) 'rib angle'])
% 
% 
% for r=7:10
%     subplot(4,1,r-6)
%     cor = corrcoef(trans_{7}(3,states),trans_{r}(3,states))
%     plot(squeeze( trans_{r}(3,states)),colors{r-6})
%  title(num2str(cor(1,2)))
% end
% cyc=5
% figure; hold on;
% 
% for r=7:10
%     subplot(4,1,r-6)
%     cor = corrcoef(trans{cyc}{7}(3,:),trans{cyc}{r}(3,:))
%     plot(trans{cyc}{r}',colors{r-6})
%  title(num2str(cor(1,2)))
% end





