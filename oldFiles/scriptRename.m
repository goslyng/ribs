

pathName = '/usr/biwinas03/scratch-a/sameig/N/Data/dataset50/ribsNCC/'
b =dir([pathName '*.mat'])

for i=4:length(b)
a = findstr(b(i).name,'cycle');
a_ = findstr(b(i).name,'_');
cycle = (b(i).name(a+5:a_(3)-1));
    
newName = ['res_NCC_cycle' cycle '_50.mat'];
system(['mv ' pathName b(i).name ' ' pathName newName]);
end