% DF Graphics Standardization - Only major races
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)




%% Doing Major Races

disp(' ')
disp('Standardizing major races')
fprintf(FdisL,'Standardizing sentient creatures:\n');

disp(' ')
disp('Counting number of major professions')

npr = 0;
totpr = 0;
for i = 1:length(catg_humanoids)
    npr = max([npr size(catg_humanoids(i).name,2)]);
    totpr = totpr + size(catg_humanoids(i).name,2);
end

Fdis1 = fopen([FolderO 'Professions_not_in_Standard.txt'],'w');

for ifR = 1:length(FlsR)
    
    
    %Pregenerating template
    disp('looking for tile size')
    fprintf(FdisL,'Looking for tile size...');
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
    fprintf(FdisL,'done!\n');
    
    cr_in = find(FlsR(ifR).snt==2);
    ncr = length(cr_in);
    %Creating output file for creatures
    if ncr>0
        
        %Going through creatures
        for icr = 1:ncr
            
            nameR = FlsR(ifR).creatures{cr_in(icr)};
            
            fprintf(Fdis1,['\n' nameR ':\n']);
            
            disp(['Standardizing ' nameR])         
            
            fprintf(FdisL,['Standardizing ' nameR ':\n']);
            
            fprintf(FdisL,'Creating blank images...');          
            %Creating Images with names
            if names_sw
                
                [szc1,szc2,szc3] = cellfun(@size,{catg_humanoids.text});
                
                ImgOT = uint8(zeros(length(catg_humanoids)*tlsz(1),npr*tlsz(2)+2+max(szc2),3));
                %                 ImgOT(:,:,:) = 255;
                TrnsOT = uint8(ones(length(catg_humanoids)*tlsz(1),npr*tlsz(2)+2+max(szc2),1)*255);
                
                %Coloring the ending parts
                %Horizontal
                ImgOT(:,npr*tlsz(1)+1,1) = 255;
                ImgOT(:,npr*tlsz(1)+2,2) = 255;
                ImgOT(:,npr*tlsz(1)+3:size(ImgOT,2),:,:) = 255;
                TrnsOT(:,npr*tlsz(1)+1:size(ImgOT,2),:) = 255;
                
                
                %Adding Category initials to each square
                
                for i = 1:length(catg_humanoids)
                    
                    for j = 1:size(catg_humanoids(i).name,2)
                        
                        txs = size(catg_humanoids(i).text2{j});
                        dtx = tlsz(1)-txs(1:2);
                        ImgOT((i-1)*tlsz(1)+1+round(dtx(1)/2):i*tlsz(1)-(dtx(1)-round(dtx(1)/2)), (j-1)*tlsz(2)+1+round(dtx(2)/2):j*tlsz(2)-(dtx(2)-round(dtx(2)/2)),:) = catg_humanoids(i).text2{j};
                        
                    end
                    
                end
                
                
                %Adding Horizontal categories names and grid
                dtx = tlsz(1)-txtsize;
                for i = 1:length(catg_humanoids)
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
                    
                    ImgOT((i-1)*tlsz(1)+1+round(dtx/2):i*tlsz(1)-(dtx-round(dtx/2)), npr*tlsz(2)+3:npr*tlsz(2)+2+szc2(i),:) = catg_humanoids(i).text;
                    
                end
                
                %Adding Vertical grid
                %             dtx = tlsz(2)-txtsize;
                for i = 1:npr
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
                end
                
                
            end
            
            %Creating Images without names
            ImgO = uint8(zeros(length(catg_humanoids)*tlsz(1),npr*tlsz(2),3));
            %             ImgO(:,:,1) = 255;
            TrnsO = uint8(ones(length(catg_humanoids)*tlsz(1),npr*tlsz(2),1)*255);
            
            %Adding Horizontal grid
            dtx = tlsz(1)-txtsize;
            for i = 1:length(catg_humanoids)
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
            
            %Adding Vertical grid
            %             dtx = tlsz(2)-txtsize;
            for i = 1:npr
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
            
            
            fprintf(FdisL,'done!\n');
            
            
            %Switches indicating a texture/profession has been found
            for i = 1:length(catg_humanoids)
                for j = 1:size(catg_humanoids(i).name,2)
                    catg_humanoids(i).sw{j} = 0;
                end
            end
            
            
            disp(['Looking for ' nameR])
            fprintf(FdisL,['Looking for ' nameR '\n']);
            
            
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
                        
                        disp(['Found in line ' num2str(line_cnt) ' of file ' FlsG(ifG).name '\n'])
                        slsh_in = strfind(FlsG(ifG).name,'\');
                        fprintf(FdisL,['Found in line ' num2str(line_cnt) ' of file ' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) '\n']);
                            
                        rdln_sw = 0;
                        
                        tlineG = fgetl(fidG);
                        line_cnt = line_cnt + 1;
                        if ~ischar(tlineG),   break,   end
                        
                        
                        while isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&isempty(strfind(tlineG,'[TILE_PAGE:'))
                            
                            fnd_sw = false;
                            for ict = 1:length(catg_humanoids)
                                
                                for jin = 1:size(catg_humanoids(ict).name,2)
                                    
                                    cln_in = strfind(catg_humanoids(ict).name{jin},':');
                                    cattxt = ['[' catg_humanoids(ict).name{jin}(1:cln_in(1)-1) ':'];
                                    cattxt2 = [catg_humanoids(ict).name{jin}(max(cln_in):length(catg_humanoids(ict).name{jin})) ']'];
                                    %Vertical Offset
                                    Voff = ict-1;
                                    
                                    cond1 = false;
                                    if ~isempty(strfind(tlineG,cattxt))
                                        cond1 = true;
                                    end
                                    
                                    if strcmp(cattxt,'[MONARCH:')&&~isempty(strfind(tlineG,'[KING:'))
                                        cond1 = true;
                                    end
                                    
                                    if strcmp(cattxt,'[MONARCH_CONSORT:')&&~isempty(strfind(tlineG,'[KING_CONSORT:'))
                                        cond1 = true;
                                    end
                                    
                                    %Conditions determining the ending part
                                    %of the definition
                                    cond2 = false;
                                    if ~isempty(strfind(tlineG,cattxt2))
                                        cond2 = true;
                                    end
                                    if strcmp(cattxt2,':GUARD]')&&(~isempty(strfind(tlineG,':GUARD]'))||~isempty(strfind(tlineG,':LAW_ENFORCE]')))
                                        cond2 = true;
                                    end
                                    if strcmp(cattxt2,':ROYALGUARD]')&&(~isempty(strfind(tlineG,':ROYALGUARD]'))||~isempty(strfind(tlineG,':TAX_ESCORT]')))
                                        cond2 = true;
                                    end
                                    if strcmp(cattxt2,':DEFAULT]')&&~isempty(strfind(tlineG,':ADD_COLOR]'))
                                        cond2 = true;
                                    end
                                    
                                    
                                    
                                    
                                    if strcmp(cattxt,'[ANIMATED:')&&~isempty(strfind(tlineG,':ANIMATED]'))&&(~isempty(strfind(tlineG,'[DEFAULT:'))||~isempty(strfind(tlineG,'[STANDARD:')))
                                        cond1 = true;
                                        cond2 = true;
                                    end
                                    
                                    if strcmp(cattxt,'[GHOST:')&&~isempty(strfind(tlineG,':GHOST]'))&&(~isempty(strfind(tlineG,'[DEFAULT:'))||~isempty(strfind(tlineG,'[STANDARD:')))
                                        cond1 = true;
                                        cond2 = true;
                                    end
                                    
                                    if strcmp(cattxt,'[GHOST:')&&~isempty(strfind(tlineG,'[GHOST:'))&&~isempty(strfind(tlineG,':GHOST]'))
                                        cond1 = true;
                                        cond2 = true;
                                    end
                                    
                                    
                                    
                                    tmp = strtrim(tlineG);
                                    if cond1&&cond2&&strcmp(tmp(1),'[')
                                        
                                        cln_in = strfind(tlineG,':');
                                        %Finding file to open
                                        pfin = find(strcmp({pages.pname},tlineG(cln_in(1)+1:cln_in(2)-1)));
                                        
                                        if ~isempty(pfin)
                                            
                                            %Finding tile to store
                                            ty = str2double(tlineG(cln_in(2)+1:cln_in(3)-1));
                                            tx = str2double(tlineG(cln_in(3)+1:cln_in(4)-1));
                                            
                                            [Img,map,Trns] = imread([FolderI '\raw\graphics\' pages(pfin).file]);
                                            
                                            if (size(Img,3)~=3)&&~isempty(map)
                                                Img = ind2rgb(Img,map);
                                            elseif (size(Img,3)~=3)
                                                Img = cat(3, Img, Img, Img);
                                            end
                                            
                                            if ((tx+1)*pages(pfin).tdim(1)>size(Img,1))||((ty+1)*pages(pfin).tdim(2)>size(Img,2))
                                                
                                                slsh_in = strfind(FlsG(ifG).name,'\');
                                                fprintf(fidMss,['Category pointing to tile outside of image: Line ' num2str(line_cnt) ' of ' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) ' - ' tlineG '\n']);
                                                
                                            else
                                                
                                                
                                                disp('Storing Tile')
                                                fprintf(FdisL,'Storing Tile\n');
                                                
                                                ImgO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2),:) = Img(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2),:);
                                                if ~isempty(Trns)
                                                    TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2)) = Trns(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2));
                                                else
                                                    TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2)) = 255;
                                                end
                                                
                                                if names_sw
                                                    
                                                    ImgOT(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2),:) = Img(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2),:);
                                                    if ~isempty(Trns)
                                                        TrnsOT(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2)) = Trns(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2));
                                                    else
                                                        TrnsOT(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2)) = 255;
                                                    end
                                                    
                                                end
                                                
                                                fnd_sw = true;
                                                %Marking category as found
                                                catg_humanoids(ict).sw{jin} = 1;
                                                
                                            end
                                            
                                        else
                                            
                                            slsh_in = strfind(FlsG(ifG).name,'\');
                                            fprintf(fidMss,['Missing page title reference: Line ' num2str(line_cnt) ' of ' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) ' - ' tlineG '\n']);
                                            
                                        end
                                        
                                    end
                                    
                                end
                                
                            end
                            
                            if ~isempty(tmp)
                                if ~fnd_sw&&strcmp(tmp(1),'[')
                                    fprintf(Fdis1,[tlineG '\n']);
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
            
            %Writing Image
            slsh_in = strfind(FlsR(ifR).name,'\');
            
            fl_name = FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4);
            fl_name = strrep(fl_name, 'creature', ['QS_ST_MJR_' lower(nameR)]);
            
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
    
end

fclose(Fdis1)

fprintf(FdisL,'Done Standardizing major races!\n\n\n');

