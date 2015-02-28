

sourceDir = '~/M/dataset23/stacks_test/';

sourceFiles = dir([sourceDir '*.img']);

exeFile = '/home/tannerch/progs/itk/ImageReadWrite4D';
    spacing = [ 1.36719 1.36719 4 1];
for i=1:length(sourceFiles)
    
    
    sourceFile =['~/M/dataset23/stacks_test/' sourceFiles(i).name];
    targetFile =sourceFile;
    command = [exeFile '  ' sourceFile '  ' targetFile '  -spacing   ' num2str(spacing)] ;
    unix(command);
end

