

for s = mriSubjects

    dataPath = ['/home/sameig/M/dataset' num2str(s) '/rib_registration/']

    mkdir([dataPath 'results'])
    mkdir([dataPath 'scripts'])
    cd( dataPath)
    unix(['mv *.txt ./results/'])
    unix(['mv *.sh ./scripts/'])
end
