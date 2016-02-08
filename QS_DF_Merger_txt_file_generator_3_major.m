% DF Graphics Standardization - Only major races
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)




%% Doing Major Races

disp(' ')
disp('Processing major races')
fprintf(FdisL,'Processing sentient creatures:\n');

disp(' ')
disp('Counting number of major professions')

npr = 0;
totpr = 0;
for i = 1:length(catg_humanoids)
    npr = max([npr size(catg_humanoids(i).name,2)]);
    totpr = totpr + size(catg_humanoids(i).name,2);
end


for ifR = 1:length(FlsR)
    
    
    cr_in = find(FlsR(ifR).snt==2);
    ncr = length(cr_in);
    %Creating output file for creatures
    if ncr>0
        
        %Going through creatures
        for icr = 1:ncr
            
            nameR = FlsR(ifR).creatures{cr_in(icr)};
            
            disp(['Processing ' nameR])
            
            fprintf(FdisL,['Processing ' nameR ':\n']);
            
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
            
            tlfnd_sw = false; %Switch indicating a viable tile was found
            
            for ifld = 1:length(fldr_list)
                
                if ~strcmp(fldr_list(ifld).name,'-><-')&&~tlfnd_sw
                    
                    FilesI = rdir(['MERGE\' fldr_list(ifld).name '\**\*.png']);
                    %Ignoring templates
                    FilesI = FilesI(cellfun(@isempty,strfind({FilesI.name}, 'QS_ST_TMP')));
                    
                    %Looking  for exact file
                    slsh_in = strfind(FlsR(ifR).name,'\');
                    fl_name = FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4);
                    fl_name = strrep(fl_name, 'creature', ['QS_ST_MJR_' lower(nameR)]);
                    FilesI = FilesI(~cellfun(@isempty,strfind({FilesI.name},fl_name)));
                    
                    if ~isempty(FilesI)
                        
                        [Img,map,Trns] = imread(FilesI(1).name);
                        
                        %Looking for standard or default tile
                        for itl = 1:2
                            
                            Voff = itl-1;
                            tmpI = Img(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,2:tlsz(2)-1,:);
                            tmpT = Trns(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,2:tlsz(2)-1);
                            
                            R = tmpI(:,:,1);
                            G = tmpI(:,:,2);
                            B = tmpI(:,:,3);
                            
                            %If tile is not transparent mark it as found
                            if (sum(tmpT(:))~=0)&&((sum(R(:)~=min(R(:)))~=0)||(sum(G(:)~=min(G(:)))~=0)||(sum(B(:)~=min(B(:)))~=0))
                                tlfnd_sw = true;
                                break
                            end
                            
                        end
                        
                        %If default found, then copy entire column
                        if tlfnd_sw
                            
                            disp(['found in' fldr_list(ifld).name])
                            fprintf(FdisL,['found in' fldr_list(ifld).name '\n']);
                            
                            
                            for ict = 1:length(catg_humanoids)
                                
                                for jin = 1:size(catg_humanoids(ict).name,2)
                                    
                                    Voff = ict-1;
                                    
                                    tmpI = Img(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,(jin-1)*tlsz(2)+2:jin*tlsz(2)-1,:);
                                    tmpT = Trns(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,(jin-1)*tlsz(2)+2:jin*tlsz(2)-1);
                                    
                                    R = tmpI(:,:,1);
                                    G = tmpI(:,:,2);
                                    B = tmpI(:,:,3);
                                    
                                    %If tile is not transparent use it
                                    if (sum(tmpT(:))~=0)&&((sum(R(:)~=min(R(:)))~=0)||(sum(G(:)~=min(G(:)))~=0)||(sum(B(:)~=min(B(:)))~=0))
                                        
                                        
                                        ImgO(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2),:) = Img(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2),:);
                                        if ~isempty(Trns)
                                            TrnsO(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2)) = Trns(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2));
                                        else
                                            TrnsO(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2)) = 255;
                                        end
                                        
                                        if names_sw
                                            
                                            ImgOT(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2),:) = Img(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2),:);
                                            if ~isempty(Trns)
                                                TrnsOT(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2)) = Trns(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2));
                                            else
                                                TrnsOT(Voff*tlsz(1)+1:(Voff+1)*tlsz(1),(jin-1)*tlsz(2)+1:jin*tlsz(2)) = 255;
                                            end
                                            
                                        end
                                        
                                    end
                                    
                                end
                                
                            end
                            
                        end
                        
                    end
                    
                end
                
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


fprintf(FdisL,'Done Standardizing major races!\n\n\n');

