

firstPts = firstPts/scale;
settings.tol=settings.tol/scale;
settings.tolX=settings.tolX/scale;

testPoints = 1:scale2:settings.nPoints;

ang0(:,5) = floor((ang0(:,5)-1)/scale2)+1;

settings.nPoints        = floor(    (settings.nPoints       -1   )/scale2  +1) ;
settings.anglePoint     = floor(    (settings.anglePoint    -1   )/scale2  +1) ;
settings.startPEval     = floor(    (settings.startPEval    -1.5 )/scale2  +1.5);
settings.middlePoint    = settings.anglePoint + 1;


options{5} = floor(    (options{5}(1)      -1   )/scale2  +1) :floor(    (options{5}(end)      -1   )/scale2  +1);