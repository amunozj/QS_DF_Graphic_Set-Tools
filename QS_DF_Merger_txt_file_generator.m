% DF Graphics Standardization - Creating standard text files, commenting
% out missing tiles, and cleaning folders
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)


clear
fclose('all');

txtsize = 8;

disp('Matlab Script for merging standardized DF graphics sets v. 0.5')
disp('Made by Andrés Muñoz-Jaramillo aka Quiet-Sun')

disp(' ')
disp('Please select folder with DF creature objects')

%Asking user for DF bulild to base itself upon
FolderR = uigetdir('','Select folder with reference DF build');


disp(' ')
disp('Please input tile size')

%Asking user for initial and final pixel size
prompt = {'Enter set pixel size:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'16'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);


pxI = str2num(answer{1});  %Initial pixel size
tlsz = [pxI pxI];


disp(' ')
disp('Please select if you want a separate folder with image templates')
button = questdlg('Do you want a separate folder with image templates?','Image template choice','Yes','No','No');

if strcmp(button,'Yes')
    names_sw = true;
else
    names_sw = false;
end


disp(' ')
disp('Please select if you want to create supporting txt files')
button = questdlg('Do you want to create supporting text files?','Image template choice','Yes','No','No');

if strcmp(button,'Yes')
    txtfl_sw = true;
else
    txtfl_sw = false;
end



disp(' ')
disp('Creating Output folders')
FolderO = ['Merged_Set'];   %Output Folder
mkdir(FolderO);
rmdir(FolderO ,'s')
mkdir(FolderO);

FolderO = [FolderO '\'];
FdisL = fopen([FolderO '\Log_4_Merger_txt_Generator.txt'],'w');



%Finding all .txt files in reference folder
FlsR = rdir([FolderR '\**\*.txt']);

%Reading major races
fprintf(FdisL,'Reading Major Races...');
nct = 0;
fidC = fopen('MAJOR_RACES.txt');
while 1
    
    %Reading line
    tlineC = fgetl(fidC);
    if ~ischar(tlineC),   break,   end
    nct = nct + 1;
    mjr_races(nct).name = tlineC;
    
end
fclose(fidC);


disp(' ')
disp('Reading creature Raws')
fprintf(FdisL,'Reading creature Raws...');
%Going through all the creature raws

for ifR = 1:length(FlsR)
    fidR = fopen(FlsR(ifR).name);
    
    ncr = 0;
    %Going throuhg all lines on each creature raw
    while 1
        
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end
        
        %If a creature line is found
        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&strcmp(tmp(1),'[')
            
            ncr = ncr+1;
            cln_in = strfind(tlineR,':');
            brkt_in = strfind(tlineR,']');
            FlsR(ifR).creatures{ncr} = tlineR(cln_in+1:brkt_in-1);
            FlsR(ifR).snt(ncr) = 0;            
        end
        
        if ~isempty(strfind(tlineR,'ANIMAL_PERSON'))&&strcmp(tmp(1),'[')&&(FlsR(ifR).snt(ncr)~=2)
            FlsR(ifR).snt(ncr) = 1;
        end
        
        if ~isempty(strfind(tlineR,'LOCAL_POPS'))&&strcmp(tmp(1),'[')&&(FlsR(ifR).snt(ncr)~=2)
            FlsR(ifR).snt(ncr) = 1;
        end
        
        for imjr = 1:length(mjr_races)
            
            if ~isempty(strfind(tlineR,['[CREATURE:' mjr_races(imjr).name ']']))&&strcmp(tmp(1),'[')
                FlsR(ifR).snt(ncr) = 2;
            end
            
        end
        
        
    end
    
    fclose(fidR);
end

fprintf(FdisL,'done!\n\n');

%Reading creature categories
fprintf(FdisL,'Reading creature Categories...');
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

fprintf(FdisL,'done!\n\n');

fprintf(FdisL,'Reading sentient creature Categories...');
%Reading sentient being categories
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

fprintf(FdisL,'done!\n\n');


%Image folder
mkdir([FolderO 'raw\graphics\QS_ST'])

if names_sw
    mkdir([FolderO 'raw\graphics\QS_ST_TMP'])
end



%Creating categories text
if names_sw
    
    disp(' ')
    disp('Rasterizing categories text')
    fprintf(FdisL,'Rasterizing categories text...');
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
            catg_humanoids(itx).text2{jin} = imcomplement(tmptxt);
            
        end
        
    end
    
    fprintf(FdisL,'done!\n\n');
    
end



%Reading creature categories
fprintf(FdisL,'Reading list of folders to merge...');
nfl = 0;
fidC = fopen('MERGING_FOLDERS.txt');
while 1
    
    %Reading line
    tlineC = fgetl(fidC);
    if ~ischar(tlineC)
        nfl = nfl + 1;
        fldr_list(nfl).name = '-><-';
        break
    end
    nfl = nfl + 1;
    fldr_list(nfl).name = tlineC;
    
end
fclose(fidC);

fprintf(FdisL,'done!\n\n');

QS_DF_Merger_txt_file_generator_1_creatures

QS_DF_Merger_txt_file_generator_2_sentient

QS_DF_Merger_txt_file_generator_3_major

if txtfl_sw

    QS_DF_Merger_txt_file_generator_4_txt_files_and_clean

end


fprintf(FdisL,'Done with all!');
fclose(FdisL);

load('gong','Fs','y')
sound(y, Fs);

disp(' ')
disp('Done!  Look inside your updated folder for report files.')