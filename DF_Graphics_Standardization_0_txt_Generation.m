% DF Graphics Standardization - Creating standard files
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)
% fclose('all')
% clear
%
%
% %Asking user for DF bulild to base itself upon
% FolderR = uigetdir('','Select folder with reference DF build');

disp(' ')
disp('Creating Output folder for standard text files')
slsh_in = strfind(FolderR,'\');
FolderOtx = [FolderR(max(slsh_in)+1:max(slsh_in)+5) ' aa QS_STD_Text_Files'];   %Output Folder
mkdir(FolderOtx);
rmdir(FolderOtx ,'s')
mkdir(FolderOtx);
FolderOtx = [FolderOtx '\'];

disp(' ')
disp('Creature text files')
%% Doing Creatures
for ifR = 1:length(FlsR)
    
    cr_in = find(FlsR(ifR).snt==0);
    ncr = length(cr_in);
    %Creating output file for creatures
    if ncr>0
                
        %Creating output name
        slsh_in = strfind(FlsR(ifR).name,'\');
        fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'QS_STD_CRT');
        
        fl_name2 = ['QS_STD/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name2 = strrep(fl_name2, 'creature', 'QS_STD_CRT');
        
        
        FileO = [FolderOtx fl_name '.txt'];
        
        %Opening output file
        fidO = fopen(FileO,'w');
        
        %Creating Header
        Pname =  upper(FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4));
        undr_in = [0 strfind(Pname,'_')];
        
        %Creating short title page
        tmp = ['CRT'];
        for i = 2:length(undr_in)
            tmp = strcat(tmp,['_' Pname(undr_in(i)+1:undr_in(i)+3)]);
        end
        Pname = tmp;
        
        %Name
        fprintf(fidO,[fl_name '\n\n']);
        
        %Object
        fprintf(fidO,'[OBJECT:GRAPHICS]\n\n');
        
        %Title Page
        fprintf(fidO,['[TILE_PAGE:' Pname ']\n']);
        
        %File
        fprintf(fidO,['\t[FILE:' fl_name2 '_XxX.png]\n']);
        
        %Tile size
        fprintf(fidO,'\t[TILE_DIM:X:X]\n');
        
        %Page size
        fprintf(fidO,['\t[PAGE_DIM:' num2str(ncr) ':' num2str(length(catg_creatures)) ']\n\n']);
        
        %Going through creatures
        for icr = 1:ncr
            
            nameR = FlsR(ifR).creatures{cr_in(icr)};
            
            fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
            
            %Adding categories
            for ict = 1:length(catg_creatures)
                cln_in = strfind(catg_creatures(ict).name,':');
                fprintf(fidO,['\t[' catg_creatures(ict).name(1:cln_in(1)-1) ':' Pname ':' num2str(icr-1) ':'  num2str(ict-1) catg_creatures(ict).name(cln_in(1):length(catg_creatures(ict).name)) ']\n']);
            end
            fprintf(fidO,'\n');
            
        end
        
        fclose(fidO);
        
    end
    
end


disp(' ')
disp('Sentient creature text files')
%% Doing Sentient Beigns
for ifR = 1:length(FlsR)
    
    cr_in = find(FlsR(ifR).snt==1);
    ncr = length(cr_in);
    
    %Creating output file for sentient creatures
    if ncr>0
        
        npgs = 1;
        while ncr/npgs*length(catg_humanoids)>1023
            npgs = npgs+1;
        end
        ncrpp = floor(ncr/npgs); %Number of creatures per page
        ncthm = length(catg_humanoids); %Number of sentient categories
                
        %Creating output name
        slsh_in = strfind(FlsR(ifR).name,'\');
        fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'QS_STD_PRSN');
        
        fl_name2 = ['QS_STD/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)]
        fl_name2 = strrep(fl_name2, 'creature', 'QS_STD_PRSN');
        
        
        FileO = [FolderOtx fl_name '.txt'];
        
        %Opening output file
        fidO = fopen(FileO,'w');
        
        %Name
        fprintf(fidO,[fl_name '\n\n']);
        
        %Object
        fprintf(fidO,'[OBJECT:GRAPHICS]\n');
        
        
        for ipgs = 1:npgs
            
            fprintf(fidO,'\n');
            
            %Creating Header
            Pname =  upper(FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4));
            undr_in = [0 strfind(Pname,'_')];
            
            %Creating short title page
            tmp = ['PSN'];
            for i = 2:length(undr_in)
                tmp = strcat(tmp,['_' Pname(undr_in(i)+1:undr_in(i)+3)]);
            end
            tmp = strcat(tmp,num2str(ipgs));
            
            Pname = tmp;
            
            %Title Page
            fprintf(fidO,['[TILE_PAGE:' Pname ']\n']);
            
            %File
            if npgs==1
                fprintf(fidO,['\t[FILE:' fl_name2 '_XxX.png]\n']);
            else
                fprintf(fidO,['\t[FILE:' fl_name2 num2str(ipgs) '_XxX.png]\n']);
            end
            
            %Tile size
            fprintf(fidO,'\t[TILE_DIM:X:X]\n');
            
            %Page size
            if (npgs==1)||(ipgs~=npgs)
                fprintf(fidO,['\t[PAGE_DIM:' num2str(ncrpp) ':' num2str(ncthm) ']\n\n']);
            else
                fprintf(fidO,['\t[PAGE_DIM:' num2str(ncr-ncrpp*(npgs-1)) ':' num2str(ncthm) ']\n\n']);
            end
            
            
            %Going through Sentient beings
            ntl = 0;
            for icr = 1+(ipgs-1)*ncrpp:min([ipgs*ncrpp ncr])
                
                ntl = ntl+1;
                
                nameR = FlsR(ifR).creatures{cr_in(icr)};
                
                fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
                
                %Adding categories
                for ict = 1:length(catg_humanoids)
                    
                    for ipr=1:size(catg_humanoids(ict).name,2)
                        tmpnm = catg_humanoids(ict).name{ipr};
                        cln_in = strfind(tmpnm,':');
                        fprintf(fidO,['\t[' tmpnm(1:cln_in(1)-1) ':' Pname ':' num2str(ntl-1) ':'  num2str(ict-1) tmpnm(cln_in(1):length(tmpnm)) ']\n']);
                    end
                    fprintf(fidO,'\n');
                end
                
                fprintf(fidO,'\n');
                
            end
            
        end
        
        fclose(fidO);
        
    end
    
end

%% Doing Major Races

disp(' ')
disp('Major races text files')

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
            
            %Creating output name
            slsh_in = strfind(FlsR(ifR).name,'\');
            fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
            fl_name = strrep(fl_name, 'creature', ['QS_STD_MJR_' lower(nameR)]);
            
            fl_name2 = ['QS_STD/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
            fl_name2 = strrep(fl_name2, 'creature', ['QS_STD_MJR_' lower(nameR)]);
            
            
            
            FileO = [FolderOtx fl_name '.txt'];
            
            %Opening output file
            fidO = fopen(FileO,'w');
            
            %Creating Header
            Pname =  upper(FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4));
            undr_in = [0 strfind(Pname,'_')];
            
            %Creating short title page
            Pname = ['MJR_' nameR];
            
            %Name
            fprintf(fidO,[fl_name '\n\n']);
            
            %Object
            fprintf(fidO,'[OBJECT:GRAPHICS]\n\n');
            
            %Title Page
            fprintf(fidO,['[TILE_PAGE:' Pname ']\n']);
            
            %File
            fprintf(fidO,['\t[FILE:' fl_name2 '_XxX.png]\n']);
            
            %Tile size
            fprintf(fidO,'\t[TILE_DIM:X:X]\n');
            
            %Page size
            fprintf(fidO,['\t[PAGE_DIM:' num2str(npr) ':' num2str(ncthm) ']\n\n']);
            
            fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
            
            %Adding categories
            for ict = 1:length(catg_humanoids)
                
                for ipr=1:size(catg_humanoids(ict).name,2)
                    tmpnm = catg_humanoids(ict).name{ipr};
                    cln_in = strfind(tmpnm,':');
                    fprintf(fidO,['\t[' tmpnm(1:cln_in(1)-1) ':' Pname ':' num2str(ipr-1) ':'  num2str(ict-1) tmpnm(cln_in(1):length(tmpnm)) ']\n']);
                end
                fprintf(fidO,'\n');
            end
            
            fclose(fidO);
            
        end       
        
    end
    
end
