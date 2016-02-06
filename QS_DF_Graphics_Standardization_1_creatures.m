% DF Graphics Standardization - Only Creatures
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)


%% Doing Creatures
disp(' ')
disp('Standardizing creatures')
for ifR = 1:length(FlsR)
    
    %Pregenerating template
    disp(' ')
    disp('Looking for tile size')
    tlsz_sw = 0;  %Switch that indicates that no tile size has been found
    for ifG = 1:length(FlsG)
        
        fidG = fopen(FlsG(ifG).name);
        
        %Reading all file line by line until finding the tile size
        %until finding target name
        while 1
            
            %Reading line
            tlineG = fgetl(fidG);
            if ~ischar(tlineG),   break,   end
            
            if ~isempty(strfind(tlineG,'[TILE_DIM:'))
                cln_in = strfind(tlineG,':');
                tlsz = [str2num(tlineG(cln_in(1)+1:cln_in(2)-1)) str2num(tlineG(cln_in(2)+1:length(tlineG)-1))];
                tlsz_sw = 1;
                break
            end
            
            if tlsz_sw,   break,   end
            
        end
        
        fclose(fidG);
        
    end
    
    
    cr_in = find(FlsR(ifR).snt==0);
    ncr = length(cr_in);
    
    if ncr>0
        
        if names_sw
            disp(' ')
            disp('Rasterizing creature names')
            
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
            
        end
        
        
        
        disp(' ')
        disp('Creating blank images')
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
        
        
        
        
        
        
        
        
        
        %% Adding existing tiles
        
        
        %Going through creatures
        for icr = 1:ncr
            
            %Switches indicating a texture/profession has been found
            for i = 1:length(catg_creatures)
                catg_creatures(i).sw = 0;
            end
            
            nameR = FlsR(ifR).creatures{cr_in(icr)};
            
            disp(['Looking for ' nameR])
            
            for ifG = 1:length(FlsG)
                
                %Copy file of interest into dummy
                copyfile(FlsG(ifG).name,'tmp.txt');
                
                fidG = fopen('tmp.txt');
                
                %Reading pages, files sizes and dimensions
                pages = [];  %Structure storing pages, files, sizes, and dimensions
                pgcnt = 0;   %Number of pages found
                while 1
                    
                    %Reading line
                    tlineG = fgetl(fidG);
                    
                    if ~ischar(tlineG),   break,   end
                    
                    %Reading pages, files sizes and dimensions
                    if ~isempty(strfind(tlineG,'[TILE_PAGE:'))
                        pgcnt = pgcnt+1;
                        pages(pgcnt).pname = tlineG(strfind(tlineG,':')+1:strfind(tlineG,']')-1);
                    end
                    if ~isempty(strfind(tlineG,'[FILE:'))
                        pages(pgcnt).file = tlineG(strfind(tlineG,':')+1:strfind(tlineG,']')-1);
                    end
                    if ~isempty(strfind(tlineG,'[TILE_DIM:'))
                        cln_in = strfind(tlineG,':');
                        pages(pgcnt).tdim = [str2num(tlineG(cln_in(1)+1:cln_in(2)-1)) str2num(tlineG(cln_in(2)+1:length(tlineG)-1))];
                    end
                    if ~isempty(strfind(tlineG,'[PAGE_DIM:'))
                        cln_in = strfind(tlineG,':');
                        pages(pgcnt).pdim = [str2num(tlineG(cln_in(1)+1:cln_in(2)-1)) str2num(tlineG(cln_in(2)+1:length(tlineG)-1))];
                    end
                    
                end
                
                fclose(fidG);
                
                fidG = fopen('tmp.txt');
                fidGo = fopen(FlsG(ifG).name,'w');
                
                %Reading all file line by line until finding the end or
                %until finding target name
                rdln_sw = 1;
                line_cnt = 0;
                while 1
                    
                    %Reading line
                    if  rdln_sw == 1
                        tlineG = fgetl(fidG);
                        line_cnt = line_cnt + 1;
                    else
                        rdln_sw = 1;
                    end
                    
                    if ~ischar(tlineG),   break,   end
                    
                    %If finding a creature name look for the respective tile
                    tmp = strtrim(tlineG);
                    if ~isempty(strfind(tlineG,nameR))&&(length(tlineG(strfind(tlineG,':')+1:strfind(tlineG,']')-1))==length(nameR))&&strcmp(tmp(1),'[')
                        disp(tlineG)
                        disp(FlsG(ifG).name)
                        rdln_sw = 0;
                        
                        tlineG = fgetl(fidG);
                        line_cnt = line_cnt + 1;
                        if ~ischar(tlineG),   break,   end
                        
                        
                        while isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&isempty(strfind(tlineG,'[TILE_PAGE:'))
                            
                            for ict = 1:length(catg_creatures)
                                
                                cln_in = strfind(catg_creatures(ict).name,':');
                                cattxt = ['[' catg_creatures(ict).name(1:cln_in(1)-1) ':'];
                                %Vertical Offset
                                Voff = ict-1;
                                
                                tmp = strtrim(tlineG);
                                if ~isempty(strfind(tlineG,cattxt))&&strcmp(tmp(1),'[')
                                    
                                    cln_in = strfind(tlineG,':');
                                    %Finding file to open
                                    pfin = find(strcmp({pages.pname},tlineG(cln_in(1)+1:cln_in(2)-1)));
                                    
                                    if ~isempty(pfin)
                                        
                                        %Finding tile to store
                                        ty = str2double(tlineG(cln_in(2)+1:cln_in(3)-1));
                                        tx = str2double(tlineG(cln_in(3)+1:cln_in(4)-1));
                                        
                                        [Img,map,Trns] = imread([FolderI '\raw\graphics\' pages(pfin).file]);
                                        
                                        if(size(Img,3)~=3)
                                            Img = ind2rgb(Img,map);
                                        end
                                        
                                        disp('Storing Tile')
                                        
                                        ImgO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(icr-1)*pages(pfin).tdim(2)+1:icr*pages(pfin).tdim(2),:) = Img(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2),:);
                                        if ~isempty(Trns)
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(icr-1)*pages(pfin).tdim(2)+1:icr*pages(pfin).tdim(2)) = Trns(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2));
                                        else
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(icr-1)*pages(pfin).tdim(2)+1:icr*pages(pfin).tdim(2)) = 255;
                                        end
                                        
                                        if names_sw
                                            
                                            ImgOT(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(icr-1)*pages(pfin).tdim(2)+1:icr*pages(pfin).tdim(2),:) = Img(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2),:);
                                            if ~isempty(Trns)
                                                TrnsOT(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(icr-1)*pages(pfin).tdim(2)+1:icr*pages(pfin).tdim(2)) = Trns(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2));
                                            else
                                                TrnsOT(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(icr-1)*pages(pfin).tdim(2)+1:icr*pages(pfin).tdim(2)) = 255;
                                            end
                                            
                                        end
                                        
                                        %Marking category as found
                                        catg_creatures(ict).sw = 1;
                                        
                                    else
                                        
                                        slsh_in = strfind(FlsG(ifG).name,'\');
                                        fprintf(fidMss,['Line ' num2str(line_cnt) ' of ' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) ' - ' tlineG '\n']);
                                        
                                        
                                    end
                                    
                                    
                                end
                                
                            end
                            
                            tlineG = fgetl(fidG);
                            line_cnt = line_cnt + 1;
                            if ~ischar(tlineG),   break,   end
                            
                        end
                        
                    else
                        
                        fprintf(fidGo,[tlineG '\n']);
                        
                    end
                    
                    if ~ischar(tlineG),   break,   end
                    
                end
                
                fclose(fidG);
                fclose(fidGo);
                
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

