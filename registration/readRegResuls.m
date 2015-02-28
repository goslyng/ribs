


function readRegResuls(outputFile)


    failure = 0;

    fid = fopen(outputFile);
    
    
    try
        tline = fgets(fid);
    catch
        
        tline=[];
        failure=1;
        
        
    end

    while ischar(tline)

    pointerState = (strfind(tline , 'State '));


        if (~isempty(pointerState))


            state = str2num(tline(pointerStete+length('State '):end));
            tline = fgets(fid);

            pointerX = strfind(tline , angXToken);
            aX = str2double(tline(pointerX+length(angXToken):end));
            tline = fgets(fid);
            
            pointerY = (strfind(tline , angYToken));
            aY = str2double(tline(pointerY+length(angYToken):end));
            tline = fgets(fid);

            pointerZ = (strfind(tline , angZToken));
            aZ = str2double(tline(pointerZ+length(angZToken):end));

            tline = fgets(fid);
            pointerX = (strfind(tline ,cntrXToken));
            cX = str2double(tline(pointerX+length(cntrXToken):end));

            tline = fgets(fid);
            pointerY = (strfind(tline ,cntrYToken));
            cY = str2double(tline(pointerY+length(cntrYToken):end));

            tline = fgets(fid);
            pointerZ = (strfind(tline ,cntrZToken));
            cZ = str2double(tline(pointerZ+length(cntrZToken):end));


            tline = fgets(fid);
            pointerX = (strfind(tline ,tranXToken ));
            tX = str2double(tline(pointerX+length(tranXToken):end));


            tline = fgets(fid);
            pointerY = (strfind(tline , tranYToken));
            tY = str2double(tline(pointerY+length(tranYToken):end));


            tline = fgets(fid);
            pointerZ = (strfind(tline , tranZToken));
            tZ = str2double(tline(pointerZ+length(tranZToken):end));                
            
            
            angles(:,state)= [aX; aY; aZ] ;
            trans(:,state)= [tX; tY; tZ];
            cntr(:,state) = [cX; cY; cZ];
            

        end  
        tline = fgets(fid);

    end
    
    
    
    
    
    angles_{r}=[angles_{r}  angles{r}{cyc}];
    trans_{r}=[trans_{r}  trans{r}{cyc}];
    cntr_{r}=[ cntr_{r} cntr{r}{cyc}];
    if ~failure
    fclose(fid);
    end
