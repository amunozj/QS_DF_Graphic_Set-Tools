% DF Graphics Standardization - Only major races
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)




%% Doing Major Races

disp('Counting number of major professions')
npr = 0;
totpr = 0;
for i = 1:length(catg_humanoids)
    npr = max([npr size(catg_humanoids(i).name,2)]);
    totpr = totpr + size(catg_humanoids(i).name,2);
end

for ifR = 1:length(FlsR)
    
    %Pregenerating template
    disp('looking for tile size')
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
    
    disp('Looking for major races')
    ncr = 0;
    fidR = fopen(FlsR(ifR).name);
    
    while 1
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end
        
        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&(~isempty(strfind(tlineR,'DWARF]'))||~isempty(strfind(tlineR,'ELF]'))||~isempty(strfind(tlineR,'GOBLIN]'))||~isempty(strfind(tlineR,'KOBOLD]'))||~isempty(strfind(tlineR,'HUMAN]')))&&strcmp(tmp(1),'[')
            ncr = ncr+1;
            
            %Creating Images with names
            if names_sw
                
                [szc1,szc2,szc3] = cellfun(@size,{catg_humanoids.text});
                
                ImgO = uint8(zeros(length(catg_humanoids)*tlsz(1),npr*tlsz(2)+2+max(szc2),3));
                ImgO(:,:,:) = 255;
                TrnsO = uint8(ones(length(catg_humanoids)*tlsz(1),npr*tlsz(2)+2+max(szc2),1)*255);
                
                %Coloring the ending parts
                %Horizontal
                ImgO(:,npr*tlsz(1)+1,1) = 255;
                ImgO(:,npr*tlsz(1)+2,2) = 255;
                ImgO(:,npr*tlsz(1)+3:size(ImgO,2),:,:) = 255;
                TrnsO(:,npr*tlsz(1)+1:size(ImgO,2),:) = 255;
                
                
                %Adding Category initials to each square
                
                for i = 1:length(catg_humanoids)
                    
                    for j = 1:size(catg_humanoids(i).name,2)
                        
                        txs = size(catg_humanoids(i).text2{j});
                        dtx = tlsz(1)-txs(1:2);
                        ImgO((i-1)*tlsz(1)+1+round(dtx(1)/2):i*tlsz(1)-(dtx(1)-round(dtx(1)/2)), (j-1)*tlsz(2)+1+round(dtx(2)/2):j*tlsz(2)-(dtx(2)-round(dtx(2)/2)),:) = catg_humanoids(i).text2{j};
                        
                    end
                    
                end
                
                
                %Adding Horizontal categories names and grid
                dtx = tlsz(1)-txtsize;
                for i = 1:length(catg_humanoids)
                    if mod(i,2)==1
                        ImgO((i-1)*tlsz(1)+1,:,:) = 0;
                        ImgO(i*tlsz(1),:,:) = 0;
                    else
                        ImgO((i-1)*tlsz(1)+1,:,:) = 127;
                        ImgO(i*tlsz(1),:,:) = 127;
                    end
                    TrnsO((i-1)*tlsz(1)+1,:) = 255;
                    TrnsO(i*tlsz(1),:) = 255;
                    
                    ImgO((i-1)*tlsz(1)+1+round(dtx/2):i*tlsz(1)-(dtx-round(dtx/2)), npr*tlsz(2)+3:npr*tlsz(2)+2+szc2(i),:) = catg_humanoids(i).text;
                    
                end
                
                %Adding Vertical grid
                %             dtx = tlsz(2)-txtsize;
                for i = 1:npr
                    if mod(i,2)==1
                        ImgO(:,(i-1)*tlsz(2)+1,:) = 0;
                        ImgO(:,i*tlsz(2),:) = 0;
                    else
                        ImgO(:,(i-1)*tlsz(2)+1,:) = 127;
                        ImgO(:,i*tlsz(2),:) = 127;
                    end
                    TrnsO(:,(i-1)*tlsz(2)+1) = 255;
                    TrnsO(:,i*tlsz(2)) = 255;
                end
                
                %Creating Images without names
            else
                
                ImgO = uint8(zeros(length(catg_humanoids)*tlsz(1),npr*tlsz(2),3));
                ImgO(:,:,1) = 255;
                TrnsO = uint8(ones(length(catg_humanoids)*tlsz(1),npr*tlsz(2),1)*255);
                
            end
            
            %Switches indicating a texture/profession has been found
            for i = 1:length(catg_humanoids)
                for j = 1:size(catg_humanoids(i).name,2)
                    catg_humanoids(i).sw{j} = 0;
                end
            end
            
            nameR = tlineR(strfind(tlineR,':')+1:strfind(tlineR,']')-1);
            
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
                while 1
                    
                    %Reading line
                    if  rdln_sw == 1
                        tlineG = fgetl(fidG);
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
                        if ~ischar(tlineG),   break,   end
                        
                        
                        while isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&isempty(strfind(tlineG,'[TILE_PAGE:'))
                            
                            for icr = 1:length(catg_humanoids)
                                
                                for jin = 1:size(catg_humanoids(icr).name,2)
                                    
                                    cln_in = strfind(catg_humanoids(icr).name{jin},':');
                                    cattxt = ['[' catg_humanoids(icr).name{jin}(1:cln_in(1)-1) ':'];
                                    cattxt2 = [catg_humanoids(icr).name{jin}(max(cln_in):length(catg_humanoids(icr).name{jin})) ']'];
                                    %Vertical Offset
                                    Voff = icr-1;
                                    
                                    tmp = strtrim(tlineG);
                                    if ~isempty(strfind(tlineG,cattxt))&&~isempty(strfind(tlineG,cattxt2))&&strcmp(tmp(1),'[')
                                        
                                        cln_in = strfind(tlineG,':');
                                        %Finding file to open
                                        pfin = find(strcmp({pages.pname},tlineG(cln_in(1)+1:cln_in(2)-1)));
                                        %Finding tile to store
                                        ty = str2double(tlineG(cln_in(2)+1:cln_in(3)-1));
                                        tx = str2double(tlineG(cln_in(3)+1:cln_in(4)-1));
                                        
                                        [Img,map,Trns] = imread([FolderI '\raw\graphics\' pages(pfin).file]);
                                        
                                        if(size(Img,3)~=3)
                                            Img = ind2rgb(Img,map);
                                        end
                                        
                                        disp('Storing Tile')
                                        ImgO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2),:) = Img(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2),:);
                                        if ~isempty(Trns)
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2)) = Trns(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2));
                                        else
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(jin-1)*pages(pfin).tdim(2)+1:jin*pages(pfin).tdim(2)) = 255;
                                        end
                                        
                                        %Marking category as found
                                        catg_humanoids(icr).sw{jin} = 1;
                                        
                                    end
                                    
                                end
                                
                            end
                            
                            tlineG = fgetl(fidG);
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
            fl_name = strrep(fl_name, 'creature', ['QS_STD_MJR_' lower(nameR)]);
            
            FileO = [FolderO 'raw\graphics\QS_STD\' fl_name '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png'];
            
            if (size(ImgO,1)==size(TrnsO,1))&&(size(ImgO,2)==size(TrnsO,2))
                imwrite(ImgO,FileO,'png','Alpha',double(TrnsO)/255);
            else
                imwrite(ImgO,FileO,'png');
            end
            
            
        end
        
    end
    
    fclose(fidR);
    
end

