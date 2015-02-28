
    
    %% Load Images

    for s = mriSubjects

        if loadImages

%             tmp=load( [mriDataPath num2str(s)],'im');
            tmp = load(mriDataPath{s} );
            im{s}=tmp.im;
            [s_1(s), s_2(s), s_3(s)]=size(im{s});

            if writeImages
                rfWriteImages(s);
%                 im_normalized = uint8((im{s}- min (im{s}(:)))/(max(im{s}(:)) - min (im{s}(:)))*255);
% 
%                 for i=1:size(im_normalized,3)
%                     imwrite(floor(im_normalized(:,:,i)),sprintf('N:\\rfData\\ims\\im_s%d_%03d.png',s,i));
%                 end
            end
        end


    end

    if exist('s_1','var')

        save(im_size_path,'s_1','s_2','s_3');
    else
        load(im_size_path,'s_1','s_2','s_3');
    end



    %% Load VTK files of new database

    for s = mriSubjects 

        display(['Subject : ' num2str(s)]);

        for i = 1:length(sides)
            side = sides{i};
            subjectDataPath{s}=[ dataPath num2str(s) '/ribs/'];
            for r=1:12%settings.ribNumber
                if s>=60
                    groundTruthRibsPath = [subjectDataPath{s} 'Rib' side 'ExhNew' num2str(r)];
                else
                    groundTruthRibsPath = [subjectDataPath{s} 'Rib' side 'New' num2str(r)];
                end
                try
                newPtsRibs{s,r,i}=readVTKPolyDataPoints(groundTruthRibsPath);
                catch
                    s
                    i
                    r
                end

            end
        end


    end

    %%  Extract rib/nonrib points
    for s= mriSubjects 
        for rule=1:4
            
            selectedPoints{rule}{s} = [];
            for i = 1:length(sides)

                hold off;
                for r=settings.ribNumber
                    try
                       
                    if s<=60
%                         startP=1;
                        settings.sliceThickness=5;
                    else
%                         startP=5;
                        settings.sliceThickness=2.5;
                    end
                    tmpPoints = transCoord(newPtsRibs{s,r,i},settings.ap,settings.is,settings.lr);                  
%                     indxs=selectPointsR(tmpPoints,settings.rules{rule},settings,startP,sides{i});
                    indxs=selectPointsR5(tmpPoints,settings.rules{rule},settings);

                    pts = ceil(newPtsRibs{s,r,i}(:,indxs));
                    
                    
                    
                    validPts = pts(1,:) -x_hw  >= 1 & pts(1,:) + x_hw < size(im{s},2) ...
                    & pts(2,:) -y_hw  >= 1 & pts(2,:) + y_hw < size(im{s},1) ...
                    & pts(3,:)        >= 1 & pts(3,:) 	   < size(im{s},3) ;
                
               
                
                    pts = pts(:,validPts);


                    selectedPoints{rule}{s} = [selectedPoints{rule}{s} pts];
                    catch
                        s
                        rule
                        i
                    end

                    

                end
            end

        end
    end

    for s = mriSubjects 
        allPts=[];
        for r=1:12
            for i=1:2
                try
                allPts = [allPts  newPtsRibs{s,r,i}];
                catch
                end
            end
        end
        
        
        for rule=1:4

            selectedPointsN{rule}{s} =  sampleNonRibs2D(im{s},allPts,patch_size);
            selectedPointsN{rule}{s} = selectedPointsN{rule}{s}(:,1:size(selectedPoints{rule}{s},2));
        end
    end

    %% write test and train files
    
    for leftoutSet = leftoutSetS 

        for rule=1:4
            
            % Train file
            coords_pos = accumulate_points_rf( setdiff(mriSubjects ,leftoutSet),rule,selectedPoints,1,s_3,imPath_);
            coords_neg = accumulate_points_rf( setdiff(mriSubjects ,leftoutSet),rule,selectedPointsN,0,s_3,imPath_);
            coords_all=[coords_pos coords_neg];

            % Test file

            coords_pos = accumulate_points_rf(leftoutSet,rule,selectedPoints,1,s_3,imPath_);
            coords_neg = accumulate_points_rf(leftoutSet,rule,selectedPointsN,0,s_3,imPath_);
            coords_test=[coords_pos coords_neg];


            % write files


            fid      = fopen(train_index_path{leftoutSet,rule},'w');
            fid_test = fopen(test_index_path{leftoutSet,rule},'w');

            fprintf(fid,coords_all);
            fprintf(fid_test,coords_test);

            fclose(fid_test);
            fclose(fid);

        end
        
        % Train file

        coords_pos = accumulate_points_rf( setdiff(mriSubjects ,leftoutSet),1:4,selectedPoints,1,s_3,imPath_);
        coords_neg = accumulate_points_rf( setdiff(mriSubjects ,leftoutSet),1:4,selectedPointsN,0,s_3,imPath_);
        coords_all=[coords_pos coords_neg];

        % Test file

        coords_pos = accumulate_points_rf(leftoutSet,1:4,selectedPoints,1,s_3,imPath_);
        coords_neg = accumulate_points_rf(leftoutSet,1:4,selectedPointsN,0,s_3,imPath_);
        coords_test=[coords_pos coords_neg];


        % Write files
        fid      = fopen(train_index_path_allrules{leftoutSet},'w');
        fprintf(fid,coords_all);
        fclose(fid);
        
    end