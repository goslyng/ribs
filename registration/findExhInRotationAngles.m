





% findEuler([0.18277819528027692, 0.03834501558593549, -0.0316862763285694])
% findEuler(0.18277819528027692, 0.03834501558593549, -0.0316862763285694)
% edit findEuler



dataPathUnix = '/usr/biwinas03/scratch-c/sameig/Data/dataset';
if (isunix())
    
dataPath = dataPathUnix;
else
    dataPath = 'M:/dataset';
end


stateMiddleFix ='Exh';
s=64;
r=7;

for r=7:10
    ExhRibPath = [dataPath num2str(s) '/ribs/RibRightExhNew' num2str(r)];
    InhRibPath = [dataPath num2str(s) '/ribs/RibRightInhNew' num2str(r)];

    pExh = readVTKPolyDataPoints(ExhRibPath);
    pInh = readVTKPolyDataPoints(InhRibPath);


    MatInh = findRotaionMatrixNew(pInh,'Right');
    MatExh = findRotaionMatrixNew(pExh,'Right');

    R = MatInh*MatExh';
    [a, b, c ]=findEuler(R);
    [a b c ]
    [a b c ]*180/pi
end

 [-0.03 -0.08 -0.028, 0, 0, 0]*180/pi
 M = findEuler(0.05, -0.03, -0.08)
C=[ 204.9
 282.6 
147.5]

[-0.02748199496328199, -0.08226850271090097, -0.033036011577457614);
 M = findEuler(-0.030235439496886993, -0.0792977956783903, -0.028457710079720876)
 
 rotatedPoints = M*(pExh - repmat(C,1,100)) + repmat(C,1,100);
 
 rotatedPoints - pInh
 
 
 figure;plot33(pExh,'b.',[1 3 2])
 hold on;
 plot33(pInh,'r.',[1 3 2])
 plot33(rotatedPoints,'g.',[1 3 2])

 