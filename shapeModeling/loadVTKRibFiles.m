

function pts = loadVTKRibFiles(subjects,dataPath,displayImage)

if ~exist('displayImage','var')
    displayImage=0;
end

for i=1:length(subjects)
    
        subject = subjects(i);
        display(['Subject : ' num2str(subject)]);

        
        
        clear fileName;
        subjectDataPath = [dataPath num2str(subject) '/'];

        ribDir =[subjectDataPath 'ribs/' ];
        ribFiles = dir(ribDir);

        x= struct2cell(ribFiles);
        y= regexpi(x(1,:),'RibRight\d*regularSmoothed.vtk','match');

        
        clear fileName
        for k=1:length(y)
           if ~isempty(y{k})
               numRibs = sscanf( y{k}{1},'RibRight%dregularSmoothed.vtk');
               fileName{numRibs} =  y{k}{1};
           end
        end
        if displayImage
            figure(102);
            hold off;
        end
        for rib=1:numRibs
            display(['Rib number: ' num2str(rib)]);
            ribPath =[subjectDataPath 'ribs/' fileName{rib}(1:end-4)];
            pts{i}{rib} = readVTKPolyDataPoints(ribPath);
            pt = pts{i}{rib};
            if displayImage

                plot3(pt(1,:),pt(2,:),pt(3,:),'b.');
                hold on;
                input(num2str(rib));
                
            end
        end
        
        
end