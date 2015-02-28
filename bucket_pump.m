for s=[18 19 23 24 25 26 27 28]


     load([params{s}.dataPathUnix num2str(s) '/motionfields/ribsMotion'])
for r=7:10
     clear rng
     for cyc = params{s}.okCycles
         clear n;
         clear M;
         for j=1:size(angles{r}{cyc},2)
             M{j} = findEulerO(angles{r}{cyc}(:,j),[1 3 2 ],0);
             n(j,:)=findEulerO(M{j},[2 1 3],1);
         end
         x = findEulerO(M{10}*M{4}',[2 1 3],1)
         rng(cyc,:) = range(n);

     end
     figure;plot(rng)
end

end