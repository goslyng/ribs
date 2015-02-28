%% Find the start of the cartilage 
close all;
nn=2;
for s= mriSubjects
    for m=mriSubject{s}.ribNumbers%rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
           
%         if ( m>9 || ismember(s,[50 51 52 54 56 57 59 ]))
%             mriSubject{s}.ribs{m}.cartgPoint=100;
%             mriSubject{s}.ribs{m}.boneRibs =  mriSubject{s}.ribs{m}.sp(1: mriSubject{s}.ribs{m}.cartgPoint,:)';
% 
%         else
%             proj = mriSubject{s}.ribs{m}.sp_v' *mriSubject{s}.ribs{m}.rot_mat';
            proj = mriSubject{s}.ribs{m}.sp *mriSubject{s}.ribs{m}.rot_mat;

            b = proj(:,nn);
            [~, j]= min(b(70:end));
            mriSubject{s}.ribs{m}.cartgPoint = j+69;
            mriSubject{s}.ribs{m}.boneRibs =  mriSubject{s}.ribs{m}.sp(1: mriSubject{s}.ribs{m}.cartgPoint,:)';


%             mriSubject{s}.ribs{m}.boneRibs =  mriSubject{s}.ribs{m}.sp_v(:,1:j+49);
%         end

    end
end
%%
% for s= mriSubjects
%     for m=mriSubject{s}.ribNumbers%rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
%             
% %         
%             j=mriSubject{s}.ribs{m}.cartgPoint ;
% %             mriSubject{s}.ribs{m}.boneRibs =  mriSubject{s}.ribs{m}.sp_v(:,1:j+49);
%             mriSubject{s}.ribs{m}.boneRibs =  mriSubject{s}.ribs{m}.sp(1:j,:);
%             i=mriSubject{s}.ribs{m}.anglePoint;
%             [mriSubject{s}.ribs{m}.rot_mat, proj] = findRotaionMatrixNew( mriSubject{s}.ribs{m}.boneRibs(i:j,:) ,'Right');            
% 
% 
%     end
% end
%%
% nn=2;
% for s= mriSubjects
%     for m=mriSubject{s}.ribNumbers%rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
%            
%         if ( m>9 || ismember(s,[50 51 52 54 56 57 59 ]))
%             mriSubject{s}.ribs{m}.cartgPoint=100;
%         else
% %             proj = mriSubject{s}.ribs{m}.sp_v' *mriSubject{s}.ribs{m}.rot_mat';
%             proj = mriSubject{s}.ribs{m}.sp *mriSubject{s}.ribs{m}.rot_mat;
% 
%             b = proj(:,nn);
%             [~, j]= min(b(70:end));
%             mriSubject{s}.ribs{m}.cartgPoint = j+69;
% %             mriSubject{s}.ribs{m}.boneRibs =  mriSubject{s}.ribs{m}.sp_v(:,1:j+49);
%         end
% 
%     end
% end

%% Display
close all;
nn=2;
if displayImages
    for s= mriSubjects
        figure(s);
        for m=mriSubject{s}.ribNumbers%rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
                     subplot(6,2,m);
%             proj = mriSubject{s}.ribs{m}.sp_v' *mriSubject{s}.ribs{m}.rot_mat';
            proj = mriSubject{s}.ribs{m}.sp *mriSubject{s}.ribs{m}.rot_mat;

            b = proj(:,nn);

            plot(b);
            hold on;
            j=mriSubject{s}.ribs{m}.cartgPoint ;
            plot(j,b(j),'r*')
            j=mriSubject{s}.ribs{m}.anglePoint ;
            plot(j,b(j),'r*')
           axis equal;
            title(['Rib No ' num2str(m) ]);
           
               
            
            
        end
    end
end
%%
if displayImages
    for s=mriSubjects

            figure(s*100);
            for m=mriSubject{s}.ribNumbers%rib_nos{s}%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
%                 plot333(mriSubject{s}.ribs{m}.sp_v,'b.',[1 3 2]);
                plot333(mriSubject{s}.ribs{m}.sp,'b.',[1 3 2]);

                hold on;
                plot333(mriSubject{s}.ribs{m}.sp(mriSubject{s}.ribs{m}.cartgPoint,:),'r*',[1 3 2]);
                plot333(mriSubject{s}.ribs{m}.sp(mriSubject{s}.ribs{m}.anglePoint	,:),'r*',[1 3 2]);

%                 plot333(mriSubject{s}.ribs{m}.sp_v(:,mriSubject{s}.ribs{m}.cartgPoint),'r*',[1 3 2]);
            end
            axis equal
    end
end
%%
% 
% if displayImages
%     for s=mriSubjects
% 
% 
%             figure(s*100);hold on;
%             for m=mriSubject{s}.ribNumbers%mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
% %                 plot333(mriSubject{s}.ribs{m}.boneRibs,'b.',[1 3 2]);
%                 
% %                 plot333(mriSubject{s}.ribs{m}.sp(mriSubject{s}.ribs{m}.cartgPoint,:),'r*',[1 3 2]);
%             end
%             axis equal
%     end
% end