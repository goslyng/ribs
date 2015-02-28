 
close all
y=[];
for i=1:145
x=imread(sprintf('/home/sameig/N/rfData/ims/s57/exh/%03d.png',i));
a=edge(x,'canny');
aa=cumsum(a,2);
aa2=cumsum(a(:,end:-1:1),2);
xx1=aa2(:,end:-1:1)<1;
xx2=aa<1;
imagesc(xx1+xx2);
y(:,:,i)=xx1+xx2;
end