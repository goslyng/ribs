
function vertebra = readVertebrae(vertebPath,numKnotsVertebra,ap,is,lr)


if nargin<3
    ap=[1 0 0];
    is=[0 1 0];
    lr=[0 0 1];
end


    dataFiles = dir(vertebPath);
    c=[];
    for i=1:length(dataFiles)

        if     (~isempty(strfind(dataFiles(i).name,'F')) && ~isempty(strfind(dataFiles(i).name,'.acsv')))
            c=[c i];
        end
    end

    file_num=[];
    nums=[];
    for i=c
        str = dataFiles(i).name;
        token1 = strfind(str,'_');
        token2 = strfind(str,'.acsv');
        if isempty(token1)
            k=0;
        else
            k=str2num(str(token1+1:token2-1));
        end
        fid=fopen([vertebPath '/' dataFiles(i).name]);
        x = fgetl(fid);
        while(strcmp(x(1),'#')==1)
            x = fgetl(fid);
        end
        fclose(fid);
        tmp = sscanf(x,'point|%f|%f|%f|1|1');
        vertebra.pts(:,k+1) = transCoord(tmp,ap,is,lr);

    end
    
    [vertebra.sp1,   vertebra.der1]= smooth_and_fit_spline(vertebra.pts(:,1:2:end)',numKnotsVertebra,0.3);
    [vertebra.sp2,   vertebra.der2]= smooth_and_fit_spline(vertebra.pts(:,2:2:end)',numKnotsVertebra,0.3);


end