% DF Graphics Standardization
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)

clear
fclose('all')

names_sw = false;


%
txtsize = 8;

%Asking user for DF bulild to base itself upon
FolderR = uigetdir('','Select folder with reference DF build');

%Asking user for folder with graphics set
FolderI = uigetdir('','Select folder with graphics set');

disp('Creating Output folders')

FolderO = [pwd '\zzOut'];   %Output Folder
mkdir(FolderO);
rmdir(FolderO ,'s')

mkdir(FolderO);



%Create target folder
copyfile(FolderI,FolderO)
FolderO = [FolderO '\'];


%Finding all .txt files in reference folder
FlsR = rdir([FolderR '\**\*.txt']);

%Finding all .txt files in the raw/graphics folder of the graphics set
FlsG = rdir([FolderO 'raw\graphics\**\*.txt']);

%% Definition of categories
nct = 0;
fidC = fopen('CATEGORIES_CREATURES_42.05.txt');
while 1
    
    %Reading line
    tlineC = fgetl(fidC);
    if ~ischar(tlineC),   break,   end
    nct = nct + 1;
    catg_creatures(nct).name = tlineC;
    
end
fclose(fidC);

%Creating categories text
if names_sw
    
    for itx = 1:length(catg_creatures)
        
        cln_in = strfind(catg_creatures(itx).name,':');
        %Creating rendering of the name
        tmpfnts = BitmapFont('Arial',32,catg_creatures(itx).name(1:cln_in(1)-1));
        
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
            if strcmp(catg_creatures(itx).name(i),'_')||strcmp(catg_creatures(itx).name(i),' ')
                tmpfnts.Bitmaps{i} = logical(zeros(max(hght),max(lngth)));
                hght(i) = max(hght);
                lngth(i) = max(lngth);
            end
        end
        
        %joined image
        tmptxt = uint8(zeros(max(hght),sum(lngth)));
        txt_os = 0;
        
        for i = 1:length(hght)
            
            tmptxt(1:hght(i),1+txt_os:+txt_os+lngth(i)) = tmpfnts.Bitmaps{i};
            txt_os = txt_os + lngth(i);
            
        end
        
        %         tmptxt = tmptxt(sum(tmptxt,2)~=0,sum(tmptxt,1)~=0);
        tmptxt = (1-cat(3,tmptxt,tmptxt,tmptxt))*255;
        tmptxt = imresize(tmptxt,txtsize/size(tmptxt,1),'lanczos3');
        
        %Saving initial
        catg_creatures(itx).init = tmpfnts.Bitmaps{1};
        
        %Saving renderized text
        catg_creatures(itx).text = tmptxt;
        
    end
    
end


fidC = fopen('CATEGORIES_HUMANOIDS_42.05.txt');
Sb_cat_sw = false;
nct = 0;
while 1
    
    %Reading line
    tlineC = fgetl(fidC);
    if ~ischar(tlineC),   break,   end
    
    if ~strcmp(tlineC(1),' ')&&~strcmp(tlineC(1),'-')
        nct = nct + 1;
        Sb_cat_sw = true;
        nsct = 1;
        catg_humanoids(nct).name{nsct} = tlineC;
    elseif strcmp(tlineC(1),' ')&&~strcmp(tlineC(1),'-')&&Sb_cat_sw
        nsct = nsct + 1;
        catg_humanoids(nct).name{nsct} = strtrim(tlineC);
    elseif strcmp(tlineC(1),'-')
        Sb_cat_sw = false;
    end
    
end
fclose(fidC);

%Creating categories text
if names_sw
    
    for itx = 1:length(catg_humanoids)
        
        cln_in = strfind(catg_humanoids(itx).name{1},':');
        %Creating rendering of the name
        tmpnm = catg_humanoids(itx).name{1}(1:cln_in(1)-1);
        if ~isempty(strfind(catg_humanoids(itx).name{1},'ADVENTURER'))
            tmpnm = [tmpnm '_AV'];
        end
        
        tmpfnts = BitmapFont('Arial',32,tmpnm);
        
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
            if strcmp(catg_humanoids(itx).name{1}(i),'_')||strcmp(catg_humanoids(itx).name{1}(i),' ')
                tmpfnts.Bitmaps{i} = logical(zeros(max(hght),max(lngth)));
                hght(i) = max(hght);
                lngth(i) = max(lngth);
            end
        end
        
        %joined image
        tmptxt = uint8(zeros(max(hght),sum(lngth)));
        txt_os = 0;
        
        for i = 1:length(hght)
            
            tmptxt(1:hght(i),1+txt_os:+txt_os+lngth(i)) = tmpfnts.Bitmaps{i};
            txt_os = txt_os + lngth(i);
            
        end
        
        %         tmptxt = tmptxt(sum(tmptxt,2)~=0,sum(tmptxt,1)~=0);
        tmptxt = (1-cat(3,tmptxt,tmptxt,tmptxt))*255;
        tmptxt = imresize(tmptxt,txtsize/size(tmptxt,1),'lanczos3');
        
        %Saving initial
        catg_humanoids(itx).init = tmpfnts.Bitmaps{1};
        
        %Saving renderized text
        catg_humanoids(itx).text = tmptxt;
        
    end
    
    txtsize2 = 12;
    %Adding Category initials to each square
    for itx = 1:length(catg_humanoids)
        
        for jin = 1:size(catg_humanoids(itx).name,2)
            
            cln_in = strfind(catg_humanoids(itx).name{jin},':');
            %Creating rendering of the name
            tmpnm = catg_humanoids(itx).name{jin}(1:cln_in(1)-1);
            init_in = [1 (strfind(tmpnm,'_')+1)];
            init_tx = tmpnm(init_in);
            
            %Creating rendering of the name
            tmpfnts = BitmapFont('Arial',32,init_tx);
            
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
            
            %joined image
            tmptxt = uint8(zeros(max(hght),sum(lngth)));
            txt_os = 0;
            
            for i = 1:length(hght)
                
                tmptxt(1:hght(i),1+txt_os:+txt_os+lngth(i)) = tmpfnts.Bitmaps{i};
                txt_os = txt_os + lngth(i);
                
            end
            
            %         tmptxt = tmptxt(sum(tmptxt,2)~=0,sum(tmptxt,1)~=0);
            tmptxt = (1-cat(3,tmptxt,tmptxt,tmptxt))*255;
            tmptxt = imresize(tmptxt,txtsize2/max(size(tmptxt)),'lanczos3');
            
            %Saving renderized text
            catg_humanoids(itx).text2{jin} = tmptxt;
            
        end
        
    end
    
    
    
end



%% Doing Creatures
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



    disp('Counting number of creatures')
    ncr = 0;
    fidR = fopen(FlsR(ifR).name);

    while 1

        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end

        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&isempty(strfind(tlineR,'MAN]'))&&isempty(strfind(tlineR,'ELEMENTMAN'))&&isempty(strfind(tlineR,'GORLAK]'))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&strcmp(tmp(1),'[')
            ncr = ncr+1;

            if names_sw

                nameR = tlineR(strfind(tlineR,':')+1:strfind(tlineR,']')-1);

                %Saving name
                names(ncr).name = nameR;

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
                names(ncr).init = tmpfnts.Bitmaps{1};

                %Saving renderized text
                names(ncr).text = tmptxt;

            end

        end

    end

    fclose(fidR);

    if ncr>0

        %Creating Images with names
        if names_sw

            [szn1,szn2,szn3] = cellfun(@size,{names.text});
            [szc1,szc2,szc3] = cellfun(@size,{catg_creatures.text});

            ImgO = uint8(zeros(length(catg_creatures)*tlsz(1)+2+max(szn1),ncr*tlsz(2)+2+max(szc2),3));
            ImgO(:,:,1) = 255;
            TrnsO = uint8(ones(length(catg_creatures)*tlsz(1)+2+max(szn1),ncr*tlsz(2)+2+max(szc2),1)*255);

            %Coloring the ending parts
            %Vertical
            ImgO(length(catg_creatures)*tlsz(1)+1,:,1) = 255;
            ImgO(length(catg_creatures)*tlsz(1)+2,:,:) = 255;
            ImgO(length(catg_creatures)*tlsz(1)+3:size(ImgO,1),:,:) = 255;
            TrnsO(length(catg_creatures)*tlsz(1)+1:size(ImgO,1),:) = 255;

            %Horizontal
            ImgO(:,ncr*tlsz(1)+1,1) = 255;
            ImgO(:,ncr*tlsz(1)+2,:,:) = 255;
            ImgO(:,ncr*tlsz(1)+3:size(ImgO,2),:,:) = 255;
            TrnsO(:,ncr*tlsz(1)+1:size(ImgO,2),:) = 255;


            %Adding Vertical creature names and grid
            dtx = tlsz(2)-txtsize;
            for i = 1:ncr
                if mod(i,2)==1
                    ImgO(:,(i-1)*tlsz(2)+1,:) = 0;
                    ImgO(:,i*tlsz(2),:) = 0;
                else
                    ImgO(:,(i-1)*tlsz(2)+1,:) = 127;
                    ImgO(:,i*tlsz(2),:) = 127;
                end
                TrnsO(:,(i-1)*tlsz(2)+1) = 255;
                TrnsO(:,i*tlsz(2)) = 255;

                ImgO(length(catg_creatures)*tlsz(1)+3:length(catg_creatures)*tlsz(1)+2+szn1(i),(i-1)*tlsz(2)+1+round(dtx/2):i*tlsz(2)-(dtx-round(dtx/2)),:) = names(i).text;
            end

            %Adding Horizontal categories names and grid
            dtx = tlsz(1)-txtsize;
            for i = 1:length(catg_creatures)
                if mod(i,2)==1
                    ImgO((i-1)*tlsz(1)+1,:,:) = 0;
                    ImgO(i*tlsz(1),:,:) = 0;
                else
                    ImgO((i-1)*tlsz(1)+1,:,:) = 127;
                    ImgO(i*tlsz(1),:,:) = 127;
                end
                TrnsO((i-1)*tlsz(1)+1,:) = 255;
                TrnsO(i*tlsz(1),:) = 255;

                ImgO((i-1)*tlsz(1)+1+round(dtx/2):i*tlsz(1)-(dtx-round(dtx/2)), ncr*tlsz(2)+3:ncr*tlsz(2)+2+szc2(i),:) = catg_creatures(i).text;
            end

            %Creating Images without names
        else

            ImgO = uint8(zeros(length(catg_creatures)*tlsz(1),ncr*tlsz(2),3));
            ImgO(:,:,1) = 255;
            TrnsO = uint8(ones(length(catg_creatures)*tlsz(1),ncr*tlsz(2),1)*255);

        end


        %% Adding existing tiles

        fidR = fopen(FlsR(ifR).name);

        ntl = 1;

        %Reading all file line by line until finding the end
        while 1

            %Reading line
            tlineR = fgetl(fidR);

            if ~ischar(tlineR),   break,   end

            tmp = strtrim(tlineR);

            %If finding a creature name look for the respective tile
            if ~isempty(strfind(tlineR,'[CREATURE:'))&&isempty(strfind(tlineR,'MAN]'))&&isempty(strfind(tlineR,'ELEMENTMAN'))&&isempty(strfind(tlineR,'GORLAK]'))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&strcmp(tmp(1),'[')

                %Switches indicating a texture/profession has been found
                for i = 1:length(catg_creatures)
                    catg_creatures(i).sw = 0;
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
                        if ~isempty(strfind(tlineG,nameR))&(length(tlineG(strfind(tlineG,':')+1:strfind(tlineG,']')-1))==length(nameR))&&strcmp(tmp(1),'[')
                            disp(tlineG)
                            disp(FlsG(ifG).name)
                            rdln_sw = 0;

                            tlineG = fgetl(fidG);
                            if ~ischar(tlineG),   break,   end


                            while isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&isempty(strfind(tlineG,'[TILE_PAGE:'))

                                for icr = 1:length(catg_creatures)

                                    cln_in = strfind(catg_creatures(icr).name,':');
                                    cattxt = ['[' catg_creatures(icr).name(1:cln_in(1)-1) ':'];
                                    %Vertical Offset
                                    Voff = icr-1;

                                    tmp = strtrim(tlineG);
                                    if ~isempty(strfind(tlineG,cattxt))&&strcmp(tmp(1),'[')

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
                                        ImgO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(ntl-1)*pages(pfin).tdim(2)+1:ntl*pages(pfin).tdim(2),:) = Img(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2),:);
                                        if ~isempty(Trns)
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(ntl-1)*pages(pfin).tdim(2)+1:ntl*pages(pfin).tdim(2)) = Trns(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2));
                                        else
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(ntl-1)*pages(pfin).tdim(2)+1:ntl*pages(pfin).tdim(2)) = 255;
                                        end

                                        %Marking category as found
                                        catg_creatures(icr).sw = 1;

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

                ntl = ntl+1;
            end


        end

        fclose(fidR);

        %Writing Image
        slsh_in = strfind(FlsR(ifR).name,'\');
        FileO = [FolderO 'raw\graphics\' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4) '.png'];

        if (size(ImgO,1)==size(TrnsO,1))&&(size(ImgO,2)==size(TrnsO,2))
            imwrite(ImgO,FileO,'png','Alpha',double(TrnsO)/255);
        else
            imwrite(ImgO,FileO,'png');
        end

    end

end



%% Doing Humanoids
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

    disp('Counting number of humanoids')
    ncr = 0;
    fidR = fopen(FlsR(ifR).name);

    while 1
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end

        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&(~isempty(strfind(tlineR,'MAN]'))||~isempty(strfind(tlineR,'ELEMENTMAN'))||~isempty(strfind(tlineR,'GORLAK]')))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&isempty(strfind(tlineR,'HUMAN]'))&&strcmp(tmp(1),'[')
            ncr = ncr+1;

            if names_sw

                nameR = tlineR(strfind(tlineR,':')+1:strfind(tlineR,']')-1);

                %Saving name
                names(ncr).name = nameR;

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
                names(ncr).init = tmpfnts.Bitmaps{1};

                %Saving renderized text
                names(ncr).text = tmptxt;

            end

        end

    end

    fclose(fidR);

    if ncr>0

        %Creating Images with names
        if names_sw

            [szn1,szn2,szn3] = cellfun(@size,{names.text});
            [szc1,szc2,szc3] = cellfun(@size,{catg_humanoids.text});

            ImgO = uint8(zeros(length(catg_humanoids)*tlsz(1)+2+max(szn1),ncr*tlsz(2)+2+max(szc2),3));
            %         ImgO(:,:,:) = 255;
            TrnsO = uint8(ones(length(catg_humanoids)*tlsz(1)+2+max(szn1),ncr*tlsz(2)+2+max(szc2),1)*0);

            %Coloring the ending parts
            %Vertical
            ImgO(length(catg_humanoids)*tlsz(1)+1,:,1) = 255;
            ImgO(length(catg_humanoids)*tlsz(1)+2,:,2) = 255;
            ImgO(length(catg_humanoids)*tlsz(1)+3:size(ImgO,1),:,:) = 255;
            TrnsO(length(catg_humanoids)*tlsz(1)+1:size(ImgO,1),:) = 255;

            %Horizontal
            ImgO(:,ncr*tlsz(1)+1,1) = 255;
            ImgO(:,ncr*tlsz(1)+2,2) = 255;
            ImgO(:,ncr*tlsz(1)+3:size(ImgO,2),:,:) = 255;
            TrnsO(:,ncr*tlsz(1)+1:size(ImgO,2),:) = 255;


            %Adding Vertical creature names and grid
            dtx = tlsz(2)-txtsize;
            for i = 1:ncr
                if mod(i,2)==1
                    ImgO(:,(i-1)*tlsz(2)+1,:) = 0;
                    ImgO(:,i*tlsz(2),:) = 0;
                else
                    ImgO(:,(i-1)*tlsz(2)+1,:) = 127;
                    ImgO(:,i*tlsz(2),:) = 127;
                end
                TrnsO(:,(i-1)*tlsz(2)+1) = 255;
                TrnsO(:,i*tlsz(2)) = 255;

                ImgO(length(catg_humanoids)*tlsz(1)+3:length(catg_humanoids)*tlsz(1)+2+szn1(i),(i-1)*tlsz(2)+1+round(dtx/2):i*tlsz(2)-(dtx-round(dtx/2)),:) = names(i).text;
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

                ImgO((i-1)*tlsz(1)+1+round(dtx/2):i*tlsz(1)-(dtx-round(dtx/2)), ncr*tlsz(2)+3:ncr*tlsz(2)+2+szc2(i),:) = catg_humanoids(i).text;
            end

            %Creating Images without names
        else

            ImgO = uint8(zeros(length(catg_humanoids)*tlsz(1),ncr*tlsz(2),3));
            ImgO(:,:,1) = 255;
            TrnsO = uint8(ones(length(catg_humanoids)*tlsz(1),ncr*tlsz(2),1)*255);

        end


        %% Adding existing tiles

        fidR = fopen(FlsR(ifR).name);

        ntl = 1;

        %Reading all file line by line until finding the end
        while 1

            %Reading line
            tlineR = fgetl(fidR);

            if ~ischar(tlineR),   break,   end

            %If finding a creature name look for the respective tile
            tmp = strtrim(tlineR);
            if ~isempty(strfind(tlineR,'[CREATURE:'))&&(~isempty(strfind(tlineR,'MAN]'))||~isempty(strfind(tlineR,'ELEMENTMAN'))||~isempty(strfind(tlineR,'GORLAK]')))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&isempty(strfind(tlineR,'HUMAN]'))&&strcmp(tmp(1),'[')

                %Switches indicating a texture/profession has been found
                for i = 1:length(catg_humanoids)
                    catg_humanoids(i).sw{1} = 0;
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

                                    cln_in = strfind(catg_humanoids(icr).name{1},':');
                                    cattxt = ['[' catg_humanoids(icr).name{1}(1:cln_in(1)-1) ':'];
                                    %Vertical Offset
                                    Voff = icr-1;

                                    tmp = strtrim(tlineG);
                                    if ~isempty(strfind(tlineG,cattxt))&&strcmp(tmp(1),'[')

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
                                        ImgO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(ntl-1)*pages(pfin).tdim(2)+1:ntl*pages(pfin).tdim(2),:) = Img(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2),:);
                                        if ~isempty(Trns)
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(ntl-1)*pages(pfin).tdim(2)+1:ntl*pages(pfin).tdim(2)) = Trns(tx*pages(pfin).tdim(1)+1:(tx+1)*pages(pfin).tdim(1),ty*pages(pfin).tdim(2)+1:(ty+1)*pages(pfin).tdim(2));
                                        else
                                            TrnsO(Voff*pages(pfin).tdim(1)+1:(Voff+1)*pages(pfin).tdim(1),(ntl-1)*pages(pfin).tdim(2)+1:ntl*pages(pfin).tdim(2)) = 255;
                                        end

                                        %Marking category as found
                                        catg_humanoids(icr).sw{1} = 1;

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

                ntl = ntl+1;
            end


        end

        fclose(fidR);

        %Writing Image
        slsh_in = strfind(FlsR(ifR).name,'\');

        fl_name = [FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'humanoid');

        FileO = [FolderO 'raw\graphics\' fl_name '.png'];

        if (size(ImgO,1)==size(TrnsO,1))&&(size(ImgO,2)==size(TrnsO,2))
            imwrite(ImgO,FileO,'png','Alpha',double(TrnsO)/255);
        else
            imwrite(ImgO,FileO,'png');
        end

    end

end


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
            fl_name = strrep(fl_name, 'creature', ['major_' lower(nameR)]);
            
            FileO = [FolderO 'raw\graphics\' fl_name '.png'];
            
            if (size(ImgO,1)==size(TrnsO,1))&&(size(ImgO,2)==size(TrnsO,2))
                imwrite(ImgO,FileO,'png','Alpha',double(TrnsO)/255);
            else
                imwrite(ImgO,FileO,'png');
            end
            
            
        end
        
    end
    
    fclose(fidR);
    
end


load('gong','Fs','y')
sound(y, Fs);

