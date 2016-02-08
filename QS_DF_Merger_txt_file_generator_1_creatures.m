% DF Graphics Standardization - Only Creatures
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)


%% Doing Creatures
disp(' ')
disp('Processing creatures')
fprintf(FdisL,'Processing creatures:\n');
for ifR = 1:length(FlsR)
    
    cr_in = find(FlsR(ifR).snt==0);
    ncr = length(cr_in);
    
    if ncr>0
        
        if names_sw
            disp(' ')
            disp('Rasterizing creature names')
            
            fprintf(FdisL,'Rasterizing creature names...');
            
            %Going through creatures
            names = [];
            for icr = 1:ncr
                
                nameR = FlsR(ifR).creatures{cr_in(icr)};
                
                %Saving name
                names(icr).name = nameR;
                
                %Creating rendering of the name
                tmpfnts = BitmapFont('Arial',32,nameR);
                
                %Cleaning and padding letters
                for i = 1:length(tmpfnts.Bitmaps)
                    
                    tmp = tmpfnts.Bitmaps{i};
                    tmp = tmp(sum(tmp,2)~=0,sum(tmp,1)~=0);
                    
                    %Padding
                    tmp(size(tmp,1)+2,size(tmp,2)+2) = 0;
                    tmp = [zeros(2,size(tmp,2));tmp];
                    tmp = [zeros(size(tmp,1),2) tmp];
                    
                    tmpfnts.Bitmaps{i} = tmp;
                end
                
                [hght,lngth] = cellfun(@size,tmpfnts.Bitmaps);
                
                %Fixing Underscores and spaces
                
                for i = 1:length(tmpfnts.Bitmaps)
                    if strcmp(nameR(i),'_')||strcmp(nameR(i),' ')
                        tmpfnts.Bitmaps{i} = logical(zeros(max(hght),max(lngth)));
                        hght(i) = max(hght);
                        lngth(i) = max(lngth);
                    end
                end
                
                %joined image
                tmptxt = uint8(zeros(sum(hght),max(lngth)));
                txt_os = 0;
                
                for i = 1:length(hght)
                    
                    pd = round((max(lngth)-lngth(i))/2);
                    tmptxt(1+txt_os:+txt_os+hght(i),1+pd:lngth(i)+pd) = tmpfnts.Bitmaps{i};
                    txt_os = txt_os + hght(i);
                    
                end
                
                %             tmptxt = tmptxt(sum(tmptxt,2)~=0,sum(tmptxt,1)~=0);
                tmptxt = (1-cat(3,tmptxt,tmptxt,tmptxt))*255;
                tmptxt = imresize(tmptxt,txtsize/size(tmptxt,2),'lanczos3');
                
                %Saving initial
                names(icr).init = tmpfnts.Bitmaps{1};
                
                %Saving renderized text
                names(icr).text = tmptxt;
                
            end
            
            fprintf(FdisL,'done!\n');
            
        end
        
        
        
        disp(' ')
        disp('Creating blank images')
        fprintf(FdisL,'Creating blank images...');
        if names_sw
            
            [szn1,szn2,szn3] = cellfun(@size,{names.text});
            [szc1,szc2,szc3] = cellfun(@size,{catg_creatures.text});
            
            ImgOT = uint8(zeros(length(catg_creatures)*tlsz(1)+2+max(szn1),ncr*tlsz(2)+2+max(szc2),3));
            %             ImgOT(:,:,1) = 255;
            TrnsOT = uint8(ones(length(catg_creatures)*tlsz(1)+2+max(szn1),ncr*tlsz(2)+2+max(szc2),1)*255);
            
            %Coloring the ending parts
            %Vertical
            ImgOT(length(catg_creatures)*tlsz(1)+1,:,1) = 255;
            ImgOT(length(catg_creatures)*tlsz(1)+2,:,:) = 255;
            ImgOT(length(catg_creatures)*tlsz(1)+3:size(ImgOT,1),:,:) = 255;
            TrnsOT(length(catg_creatures)*tlsz(1)+1:size(ImgOT,1),:) = 255;
            
            %Horizontal
            ImgOT(:,ncr*tlsz(1)+1,1) = 255;
            ImgOT(:,ncr*tlsz(1)+2,:,:) = 255;
            ImgOT(:,ncr*tlsz(1)+3:size(ImgOT,2),:,:) = 255;
            TrnsOT(:,ncr*tlsz(1)+1:size(ImgOT,2),:) = 255;
            
            
            %Adding Vertical creature names and grid
            dtx = tlsz(2)-txtsize;
            for i = 1:ncr
                if mod(i,2)==1
                    %Red
                    ImgOT(:,(i-1)*tlsz(2)+1,1) = 66;
                    ImgOT(:,i*tlsz(2),1) = 66;
                    %Green
                    ImgOT(:,(i-1)*tlsz(2)+1,2) = 158;
                    ImgOT(:,i*tlsz(2),2) = 158;
                    %Blue
                    ImgOT(:,(i-1)*tlsz(2)+1,3) = 205;
                    ImgOT(:,i*tlsz(2),3) = 205;
                else
                    %Red
                    ImgOT(:,(i-1)*tlsz(2)+1,1) = 228;
                    ImgOT(:,i*tlsz(2),1) = 228;
                    %Green
                    ImgOT(:,(i-1)*tlsz(2)+1,2) = 229;
                    ImgOT(:,i*tlsz(2),2) = 229;
                    %Blue
                    ImgOT(:,(i-1)*tlsz(2)+1,3) = 153;
                    ImgOT(:,i*tlsz(2),3) = 153;
                end
                TrnsOT(:,(i-1)*tlsz(2)+1) = 255;
                TrnsOT(:,i*tlsz(2)) = 255;
                
                ImgOT(length(catg_creatures)*tlsz(1)+3:length(catg_creatures)*tlsz(1)+2+szn1(i),(i-1)*tlsz(2)+1+round(dtx/2):i*tlsz(2)-(dtx-round(dtx/2)),:) = names(i).text;
            end
            
            %Adding Horizontal categories names and grid
            dtx = tlsz(1)-txtsize;
            for i = 1:length(catg_creatures)
                if mod(i,2)==1
                    %Red
                    ImgOT((i-1)*tlsz(1)+1,:,1) = 145;
                    ImgOT(i*tlsz(1),:,1) = 145;
                    %Green
                    ImgOT((i-1)*tlsz(1)+1,:,2) = 75;
                    ImgOT(i*tlsz(1),:,2) = 75;
                    %Blue
                    ImgOT((i-1)*tlsz(1)+1,:,3) = 143;
                    ImgOT(i*tlsz(1),:,3) = 143;
                else
                    %Red
                    ImgOT((i-1)*tlsz(1)+1,:,1) = 245;
                    ImgOT(i*tlsz(1),:,1) = 245;
                    %Green
                    ImgOT((i-1)*tlsz(1)+1,:,2) = 129;
                    ImgOT(i*tlsz(1),:,2) = 129;
                    %Blue
                    ImgOT((i-1)*tlsz(1)+1,:,3) =114;
                    ImgOT(i*tlsz(1),:,3) = 114;
                end
                TrnsOT((i-1)*tlsz(1)+1,:) = 255;
                TrnsOT(i*tlsz(1),:) = 255;
                
                ImgOT((i-1)*tlsz(1)+1+round(dtx/2):i*tlsz(1)-(dtx-round(dtx/2)), ncr*tlsz(2)+3:ncr*tlsz(2)+2+szc2(i),:) = catg_creatures(i).text;
            end
            
            
        end
        
        %Creating Images without names
        ImgO = uint8(zeros(length(catg_creatures)*tlsz(1),ncr*tlsz(2),3));
        %         ImgO(:,:,1) = 255;
        TrnsO = uint8(ones(length(catg_creatures)*tlsz(1),ncr*tlsz(2),1)*255);
        
        %Adding Vertical grid
        for i = 1:ncr
            if mod(i,2)==1
                %Red
                ImgO(:,(i-1)*tlsz(2)+1,1) = 66;
                ImgO(:,i*tlsz(2),1) = 66;
                %Green
                ImgO(:,(i-1)*tlsz(2)+1,2) = 158;
                ImgO(:,i*tlsz(2),2) = 158;
                %Blue
                ImgO(:,(i-1)*tlsz(2)+1,3) = 205;
                ImgO(:,i*tlsz(2),3) = 205;
            else
                %Red
                ImgO(:,(i-1)*tlsz(2)+1,1) = 228;
                ImgO(:,i*tlsz(2),1) = 228;
                %Green
                ImgO(:,(i-1)*tlsz(2)+1,2) = 229;
                ImgO(:,i*tlsz(2),2) = 229;
                %Blue
                ImgO(:,(i-1)*tlsz(2)+1,3) = 153;
                ImgO(:,i*tlsz(2),3) = 153;
            end
            TrnsO(:,(i-1)*tlsz(2)+1) = 255;
            TrnsO(:,i*tlsz(2)) = 255;
            
        end
        
        %Adding Horizontal grid
        for i = 1:length(catg_creatures)
            if mod(i,2)==1
                %Red
                ImgO((i-1)*tlsz(1)+1,:,1) = 145;
                ImgO(i*tlsz(1),:,1) = 145;
                %Green
                ImgO((i-1)*tlsz(1)+1,:,2) = 75;
                ImgO(i*tlsz(1),:,2) = 75;
                %Blue
                ImgO((i-1)*tlsz(1)+1,:,3) = 143;
                ImgO(i*tlsz(1),:,3) = 143;
            else
                %Red
                ImgO((i-1)*tlsz(1)+1,:,1) = 245;
                ImgO(i*tlsz(1),:,1) = 245;
                %Green
                ImgO((i-1)*tlsz(1)+1,:,2) = 129;
                ImgO(i*tlsz(1),:,2) = 129;
                %Blue
                ImgO((i-1)*tlsz(1)+1,:,3) =114;
                ImgO(i*tlsz(1),:,3) = 114;
            end
            TrnsO((i-1)*tlsz(1)+1,:) = 255;
            TrnsO(i*tlsz(1),:) = 255;
            
        end
        
        fprintf(FdisL,'done!\n');
        
        %% Adding existing tiles
        disp(' ')
        disp('Adding existing tiles')
        fprintf(FdisL,'Adding existing tiles:\n');
        
        %Going through creatures
        for icr = 1:ncr
                        
            nameR = FlsR(ifR).creatures{cr_in(icr)};
            
            disp(['Looking for ' nameR])
            fprintf(FdisL,['Looking for ' nameR '...']);
            tlfnd_sw = false; %Switch indicating a viable tile was found
            
            for ifld = 1:length(fldr_list)
                
               if ~strcmp(fldr_list(ifld).name,'-><-')&&~tlfnd_sw
                  
                   FilesI = rdir(['MERGE\' fldr_list(ifld).name '\**\*.png']);
                   %Ignoring templates
                   FilesI = FilesI(cellfun(@isempty,strfind({FilesI.name}, 'QS_ST_TMP')));
                   
                   %Looking  for exact file
                   slsh_in = strfind(FlsR(ifR).name,'\');                   
                   fl_name = [FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
                   fl_name = strrep(fl_name, 'creature', 'QS_ST_CRT');
                   FilesI = FilesI(~cellfun(@isempty,strfind({FilesI.name},fl_name)));
                   
                   
                   if ~isempty(FilesI)
                       
                       [Img,map,Trns] = imread(FilesI(1).name);
                       
                       %Looking for default tile
                       for itl = 1:1
                          
                            Voff = itl-1;
                            tmpI = Img(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,(icr-1)*tlsz(2)+2:icr*tlsz(2)-1,:);
                            tmpT = Trns(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,(icr-1)*tlsz(2)+2:icr*tlsz(2)-1);
                            
                            R = tmpI(:,:,1);
                            G = tmpI(:,:,2);
                            B = tmpI(:,:,3);
                            
                            %If tile is not transparent mark it as found
                            if (sum(tmpT(:))~=0)&&((sum(R(:)~=min(R(:)))~=0)||(sum(G(:)~=min(G(:)))~=0)||(sum(B(:)~=min(B(:)))~=0))
                                tlfnd_sw = true;                                
                            end                           
                           
                       end
                       
                       %If default found, then copy entire column
                       if tlfnd_sw
                           
                           disp(['found in' fldr_list(ifld).name])
                           fprintf(FdisL,['found in' fldr_list(ifld).name '\n']);
                           
                           ImgO(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2),:) = Img(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2),:);
                           if ~isempty(Trns)
                               TrnsO(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2)) = Trns(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2));
                           end
                           
                           if names_sw
                               ImgOT(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2),:) = Img(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2),:);
                               if ~isempty(Trns)
                                   TrnsOT(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2)) = Trns(1:length(catg_creatures)*tlsz(1),(icr-1)*tlsz(2)+1:icr*tlsz(2));
                               end                               
                           end              
                               
                       end
                          
                   end
  
               end 
                
            end
            
        end
        
        %Writing Image
        slsh_in = strfind(FlsR(ifR).name,'\');
        
        fl_name = [FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'QS_ST_CRT');
        
        FileO = [FolderO 'raw\graphics\QS_ST\' fl_name '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png'];
        
        if (size(ImgO,1)==size(TrnsO,1))&&(size(ImgO,2)==size(TrnsO,2))
            imwrite(ImgO,FileO,'png','Alpha',double(TrnsO)/255);
        else
            imwrite(ImgO,FileO,'png');
        end
        
        if names_sw
            
            FileO = [FolderO 'raw\graphics\QS_ST_TMP\' fl_name '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png'];
            
            if (size(ImgOT,1)==size(TrnsOT,1))&&(size(ImgOT,2)==size(TrnsOT,2))
                imwrite(ImgOT,FileO,'png','Alpha',double(TrnsOT)/255);
            else
                imwrite(ImgOT,FileO,'png');
            end
            
        end
        
        
    end
    
end

fprintf(FdisL,'Done processing creatures!\n\n\n');
