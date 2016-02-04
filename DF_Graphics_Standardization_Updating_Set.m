% DF Graphics Standardization - Script for updating names to current
% version
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)
clear
fclose('all');

names_sw = false;

%
txtsize = 8;

disp('Matlab Script for updating DF graphics sets')
disp('Made by Andrés Muñoz-Jaramillo aka Quiet-Sun')

disp(' ')

disp('Please select folder with DF creature objects')

%Asking user for DF bulild to base itself upon
FolderR = uigetdir('','Select folder with reference DF build');
slsh_in = strfind(FolderR,'\');

disp(' ')

disp('Please select folder with graphics set')

%Asking user for folder with graphics set
FolderI = uigetdir('','Select folder with graphics set');

disp(' ')
disp('Creating Output folders')
slsh_in = strfind(FolderI,'\');
FolderO = [pwd FolderI(max(slsh_in):length(FolderI)) '-Updated'];   %Output Folder
mkdir(FolderO);
rmdir(FolderO ,'s')
mkdir(FolderO);

%Create target folder
copyfile(FolderI,FolderO)
FolderO = [FolderO '\'];


%Finding all .txt files in reference folder
FlsR = rdir([FolderR '\**\*.txt']);

%Finding all .txt files in the raw/graphics folder of the graphics set
FlsG = rdir([FolderI '\raw\graphics\**\*.txt']);

%Reading all RAW names and checking for differences:

disp(' ')
disp('Reading creature Raws')
%Going through all the creature raws
ncr = 0;
for ifR = 1:length(FlsR)
    fidR = fopen(FlsR(ifR).name);
    
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
            crnameR{ncr} = tlineR(cln_in+1:brkt_in-1);
            
        end
    end
    
    fclose(fidR);
end






Fdiscr = fopen([FolderO 'Name_Changes.txt'],'w');
Fdis1 = fopen([FolderO 'Names_in_Set_not_in_Raws.txt'],'w');


%Going through all graphic set files and checking for scrambled name matches
disp(' ')
disp('Going through graphics set and looking for scrambled name matches')
for ifG = 1:length(FlsG)
    
    fidG = fopen(FlsG(ifG).name);
    
    %Opening mirror file
    slsh_in = strfind(FlsG(ifG).name,'\');
    tmpnm = [FolderO 'raw\graphics\' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name))];
    fidGo = fopen(tmpnm,'w');
    lncnt = 0;
    
    %Going through all lines in the graphic set txt
    while 1
        
        lncnt = lncnt + 1;
        %Reading line
        tlineG = fgetl(fidG);
        if ~ischar(tlineG),   break,   end
        
        %If a creature line is found
        tmp = strtrim(tlineG);
        if ~isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&strcmp(tmp(1),'[')
            
            cln_in = strfind(tlineG,':');
            brkt_in = strfind(tlineG,']');
            crnameG = tlineG(cln_in+1:brkt_in-1);
            
            disp(['Looking for ' crnameG])
            fnd_sw = false;
            %Going through all the creature raws
            for ifR = 1:length(crnameR)
                
                %If name of creatures different
                if ~strcmp(crnameG,crnameR{ifR})
                    
                    %Finding difference in letter sets
                    stdif1 = setdiff(crnameG,crnameR{ifR});
                    stdif2 = setdiff(crnameR{ifR},crnameG);
                    
                    %Looking for similar patterns
                    
                    %Braking the name into words separated by space or
                    %underscores
                    uscr_in1 = sort([0 strfind(crnameG,'_') strfind(crnameG,' ') (length(crnameG)+1)]);
                    uscr_in2 = sort([0 strfind(crnameR{ifR},'_') strfind(crnameR{ifR},' ') (length(crnameR{ifR})+1)]);
                    
                    %Looking for self-matches
                    slf_mtch1 = 0;  %Number of matches
                    for im1 = 1:length(uscr_in1)-1
                        
                        for im2 = 1:length(uscr_in1)-1
                            
                            if (~isempty(strfind(crnameG(uscr_in1(im1)+1:uscr_in1(im1+1)-1),crnameG(uscr_in1(im2)+1:uscr_in1(im2+1)-1))))&&(im1~=im2)
                                
                                slf_mtch1 = slf_mtch1+1;
                                
                            end
                        end
                        
                    end
                    
                    slf_mtch2 = 0;  %Number of matches
                    for im1 = 1:length(uscr_in2)-1
                        
                        for im2 = 1:length(uscr_in2)-1
                            
                            if ~isempty(strfind(crnameR{ifR}(uscr_in2(im1)+1:uscr_in2(im1+1)-1),crnameR{ifR}(uscr_in2(im2)+1:uscr_in2(im2+1)-1)))&&(im1~=im2)
                                
                                slf_mtch2 = slf_mtch2+1;
                                
                            end
                        end
                        
                    end
                    
                    
                    %Looking for matches
                    nmbr_mtch = 0;  %Number of matches
                    for im1 = 1:length(uscr_in1)-1
                        
                        for im2 = 1:length(uscr_in2)-1
                            
                            if ~isempty(strfind(crnameG(uscr_in1(im1)+1:uscr_in1(im1+1)-1),crnameR{ifR}(uscr_in2(im2)+1:uscr_in2(im2+1)-1)))||~isempty(strfind(crnameR{ifR}(uscr_in2(im2)+1:uscr_in2(im2+1)-1),crnameG(uscr_in1(im1)+1:uscr_in1(im1+1)-1)))
                                
                                nmbr_mtch = nmbr_mtch+1;
                                
                            end
                        end
                        
                    end
                    
                    if ~strcmp(crnameG,crnameR{ifR})&&(abs(length(crnameG)-length(crnameR{ifR}))<=1)&&(length(stdif2)<=1)&&(length(stdif1)<=1)&&(nmbr_mtch>=max([(length(uscr_in1)-1+slf_mtch1) (length(uscr_in2)-1+slf_mtch2)]))
                        
                        strrep(tlineG, crnameG, crnameR{ifR});
                        
                        slsh_in = strfind(FlsG(ifG).name,'\');
                        fprintf(Fdiscr,[crnameG '->' crnameR{ifR} ' in line ' num2str(lncnt) ' of ' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) '\n']);
                        fnd_sw = true;
                        
                    end
                    
                else
                    fnd_sw = true;
                end
                
            end
            
            if ~fnd_sw
                slsh_in = strfind(FlsG(ifG).name,'\');
                fprintf(Fdis1,[crnameG ' in line ' num2str(lncnt) ' of ' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) '\n']);
            end
            
        end
        
        fprintf(fidGo,[tlineG '\n']);
        
    end
    
    fclose(fidG);
    fclose(fidGo);
    
end

fclose(Fdiscr);
fclose(Fdis1);



Fdis1 = fopen([FolderO 'Names_in_Raws_not_in_Set.txt'],'w');

%Finding all .txt files in the raw/graphics folder of the corrected graphics set
FlsG = rdir([FolderO 'raw\graphics\**\*.txt']);

disp(' ')
disp('Looking for creatures in the raws that don''t exist in the graphics set')
%Going through all the creature raws
ncr = 0;
for ifR = 1:length(FlsR)
    fidR = fopen(FlsR(ifR).name);
    
    lncnt = 0;
    
    %Going throuhg all lines on each creature raw
    while 1
        
        lncnt = lncnt + 1;
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end
        
        %If a creature line is found
        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&strcmp(tmp(1),'[')
            
            ncr = ncr+1;
            cln_in = strfind(tlineR,':');
            brkt_in = strfind(tlineR,']');
            crnameR = tlineR(cln_in+1:brkt_in-1);
            
            disp(['Looking for ' crnameR])
            
            fnd_sw = false;
            for ifG = 1:length(FlsG)
                
                fidG = fopen(FlsG(ifG).name);
                

                %Going through all lines in the graphic set txt
                while 1
                    
                    %Reading line
                    tlineG = fgetl(fidG);
                    if ~ischar(tlineG),   break,   end
                    
                    %If a creature line is found
                    tmp = strtrim(tlineG);
                    if ~isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&strcmp(tmp(1),'[')
                        
                        cln_in = strfind(tlineG,':');
                        brkt_in = strfind(tlineG,']');
                        crnameG = tlineG(cln_in+1:brkt_in-1);
                        
                        if strcmp(crnameG,crnameR)
                            fnd_sw = true;
                        end
                        
                    end
                    
                end
                
                fclose(fidG);                
            end
            
            if ~fnd_sw
                slsh_in = strfind(FlsR(ifR).name,'\');
                fprintf(Fdis1,[crnameR ' in line ' num2str(lncnt) ' of ' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)) '\n']);
            end            
             
        end
    end
    
    fclose(fidR);
end

fclose(Fdis1);

disp(' ')
disp('Done!  Look inside your updated folder for report files.')

% load('gong','Fs','y')
% sound(y, Fs);