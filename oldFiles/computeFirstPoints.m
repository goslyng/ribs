


function firstPts = computeFirstPoints(pts)


threshZ = min(pts(3,:)) + 5;
midX = (max(pts(1,:)) +min(pts(1,:)))/2;
indx = logical(pts(3,:)<threshZ  & pts(1,:) < midX );
p =pts(:, indx);

y= p(2,:);

d = (repmat(y(:), 1, length(y(:))) - repmat(y(:)', length(y(:)),1)).^2;

d=(d<25);

for i=1:size(p,2);
    set_{i} = i;
end

for i=1:length(set_)
    for j=i+1:length(set_)
        if ~isempty(set_{i}) && ~isempty(set_{j})
            if any(d(set_{i},set_{j})) 

                set_{i}=union(set_{i},set_{j});
                set_{j}=[];
            end
        end
    end
end

for i=1:length(set_)
    if isempty(set_{i})
        id(i)=true;
    else
        id(i) =false;
    end
end
set_(logical(id))=[];

for i=1:length(set_)
    firstPts(:,i) = mean(p(:,set_{i}),2);
end

[~, b] = sort(firstPts(2,:),'descend');
firstPts=firstPts(:,b);