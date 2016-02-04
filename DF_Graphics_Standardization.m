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
slsh_in = strfind(FolderI,'\');
FolderO = [pwd FolderI(max(slsh_in):length(FolderI)) '-Standard'];   %Output Folder
mkdir(FolderO);
rmdir(FolderO ,'s')
mkdir(FolderO);

%Create target folder
copyfile(FolderI,FolderO)
FolderO = [FolderO '\'];


% DF_Graphics_Standardization_Updating_Set


%Finding all .txt files in reference folder
FlsR = rdir([FolderR '\**\*.txt']);

%Finding all .txt files in the raw/graphics folder of the graphics set
FlsG = rdir([FolderO 'raw\graphics\**\*.txt']);




%% Creating standard text files
DF_Graphics_Standard_txt_Generation

%Image folder
mkdir([FolderO 'raw\graphics\QS_STD'])


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

DF_Graphics_Standardization_creatures

DF_Graphics_Standardization_humanoids

DF_Graphics_Standardization_major

DF_Graphics_Standardization_final_clean


load('gong','Fs','y')
sound(y, Fs);

