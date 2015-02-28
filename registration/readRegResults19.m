


function [angles, trans, cntr] = readRegResults19(fid)

invalidToken=-99;
angles=[];
trans = [];
cntr=[];
    angXToken = 'angle X      = ';
    angYToken = 'angle Y      = ';
    angZToken = 'angle Z      = ';

    tranXToken='Translation X = ';
    tranYToken='Translation Y = ';
    tranZToken='Translation Z = ';

    cntrXToken='Center X = ';
    cntrYToken='Center Y = ';
    cntrZToken='Center Z = ';
        
        %%
    tline = fgets(fid);
    state=0;
    while ischar(tline)

%     pointerState = (strfind(tline , 'State '));


%         if (~isempty(pointerState))


%             state = str2num(tline(pointerState+length('State '):end));
           
%             if state==0
%                 state=1;
%             end
%             tline = fgets(fid);
            pointerX = strfind(tline , angXToken);
%             pointerState = (strfind(tline , 'State '));

            while ( isempty(pointerX)  && ischar(tline))
                tline = fgets(fid);
                if ischar(tline)
                    pointerX = strfind(tline , angXToken);
%                     pointerState = (strfind(tline , 'State '));

                end
            end

            if ~isempty(pointerX)
            
            state=state+1;
            aX = str2double(tline(pointerX+length(angXToken):end));
            tline = fgets(fid);
            
            pointerY = (strfind(tline , angYToken));
            aY = str2double(tline(pointerY+length(angYToken):end));
            tline = fgets(fid);

            pointerZ = (strfind(tline , angZToken));
            aZ = str2double(tline(pointerZ+length(angZToken):end));

            tline = fgets(fid);
            pointerX = (strfind(tline ,cntrXToken));
            if (isempty(pointerX))
                cX = invalidToken;
                cY= invalidToken;
                cZ= invalidToken;
            else
                cX = str2double(tline(pointerX+length(cntrXToken):end));
                tline = fgets(fid);
                pointerY = (strfind(tline ,cntrYToken));
                cY = str2double(tline(pointerY+length(cntrYToken):end));

                tline = fgets(fid);
                pointerZ = (strfind(tline ,cntrZToken));
                cZ = str2double(tline(pointerZ+length(cntrZToken):end));


                tline = fgets(fid);
            end
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
            else
                angles(:,state)= [invalidToken; invalidToken; invalidToken] ;
                trans(:,state)= [invalidToken; invalidToken; invalidToken];
                cntr(:,state) = [invalidToken; invalidToken; invalidToken];
            end
%         end  
        tline = fgets(fid);
        tline = fgets(fid);

    end
    
    
    
    
    