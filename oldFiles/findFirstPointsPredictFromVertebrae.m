function [firstPts, pts] = findFirstPointsPredictFromVertebrae(ptsI,m,vertebraPredictionMatrixPath,rootPath,settings)



        apMRIv = [1  0 0];
        isMRIv = [0  0 1];
        lrMRIv = [0 -1 0];

        if (ismember(m,[ 53 56 57 ]))
               ribOffset=5;
        else
               ribOffset=6;
        end
           ribNumbers_Coord=1:5;

        % [firstPts, ptsRibcage] = findFirstPoints(rib_nos,ptsRibs,settings,m);
        % [~, ptsRibcage] = findFirstPoints(rib_nos,ptsRibs,settings,m);

        load(vertebraPredictionMatrixPath,'predictR');

        numKnotsVertebra=100;
        % for s = mrSubjects

        mrSubjectDataPath =[rootPath 'Data/dataset' num2str(m) ];
        mrVertebPath =  [mrSubjectDataPath '/ribs/vertebra/'];
        mrFirstPointPath = [mrSubjectDataPath '/ribs/firstPoints/'];
        mriSubject.vertebra = readVertebrae(mrVertebPath,numKnotsVertebra,apMRIv,isMRIv,lrMRIv);
        firstPoints = readVertebrae(mrFirstPointPath,numKnotsVertebra,apMRIv,isMRIv,lrMRIv);
        %     predict = reshape(mean(vertebMat(setdiff(ctSubjects,[ 5 11 ]),:)),3,[]);
        mriSubject.vertebra.anterior(:,ribOffset+(ribNumbers_Coord)) = mriSubject.vertebra.pts(:,1:2:10);
        smooth_factor=4;

        mrVerteb= 0+(1:10);
        mriSubject.vertebra = findLocalCoordinates(mriSubject.vertebra,ribNumbers_Coord,mrVerteb,smooth_factor,numKnotsVertebra,ribOffset);


        for i=settings.ribNumber

        %     r=i+6;
            predict_mri(i,:) = mriSubject.vertebra.coord(:,:,i)* predictR(:,i) + mriSubject.vertebra.anterior(:,i);
        %         transCoord(squeeze(predict_mri(s,7:10,:)),settings.ap,settings.is,settings.lr)

        end
        firstPts(:,settings.ribNumber) = predict_mri(settings.ribNumber,:)';
        firstPts(:,settings.ribNumber) = firstPoints.pts(:,2*(settings.ribNumber - ribOffset)-1);



        pts=[];

        for i = settings.ribNumber

            pts = [pts ptsI{i}];

        end

