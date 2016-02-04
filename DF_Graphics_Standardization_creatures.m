% DF Graphics Standardization - Only Creatures
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)


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
        
        fl_name = [FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'QS_STD_CRT');

        FileO = [FolderO 'raw\graphics\QS_STD\' fl_name '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png'];

        if (size(ImgO,1)==size(TrnsO,1))&&(size(ImgO,2)==size(TrnsO,2))
            imwrite(ImgO,FileO,'png','Alpha',double(TrnsO)/255);
        else
            imwrite(ImgO,FileO,'png');
        end

    end

end

