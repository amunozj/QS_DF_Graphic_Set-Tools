% DF Graphics Standardization - Creating standard text files, commenting
% out missing tiles, and cleaning folders
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)



disp(' ')
disp('Processing Creature text files')

fprintf(FdisL,'Processing Creature text files:\n');

%% Doing Creatures
for ifR = 1:length(FlsR)
    
    cr_in = find(FlsR(ifR).snt==0);
    ncr = length(cr_in);
    %Creating output file for creatures
    if ncr>0
                
        %Creating output name
        slsh_in = strfind(FlsR(ifR).name,'\');
        fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'QS_ST_CRT');
        
        fl_name2 = ['QS_ST/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name2 = strrep(fl_name2, 'creature', 'QS_ST_CRT');
        
        fl_name3 = ['QS_ST\' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name3 = strrep(fl_name3, 'creature', 'QS_ST_CRT');
        
        FileO = [FolderO 'raw\graphics\' fl_name '.txt'];
        
        fprintf(FdisL,['Processing ' fl_name '.txt...']);
        
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
        fprintf(fidO,['\t[FILE:' fl_name2 '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png]\n']);
        
        %Tile size
        fprintf(fidO,['\t[TILE_DIM:' num2str(tlsz(1)) ':' num2str(tlsz(2)) ']\n']);
        
        %Page size
        fprintf(fidO,['\t[PAGE_DIM:' num2str(ncr) ':' num2str(length(catg_creatures)) ']\n\n']);
        
        
        [ImgO,map,TrnsO] = imread([FolderO 'raw\graphics\' fl_name2 '_' num2str(tlsz(1)) 'x' num2str(tlsz(1)) '.png']);
        
        %Going through creatures
        for icr = 1:ncr
            
            nameR = FlsR(ifR).creatures{cr_in(icr)};
            
            fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
            
            %Adding categories
            fnd_tl_sw = 1;  %Switch to mark for removal of creature if at least one tile is found it's turned off
            for ict = 1:length(catg_creatures)

                %Assembling line
                cln_in = strfind(catg_creatures(ict).name,':');
                lineprnt = ['\t[' catg_creatures(ict).name(1:cln_in(1)-1) ':' Pname ':' num2str(icr-1) ':'  num2str(ict-1) catg_creatures(ict).name(cln_in(1):length(catg_creatures(ict).name)) ']\n'];
                
                %Extracting tile
                Voff = ict-1;
                tmpIm = ImgO(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,(icr-1)*tlsz(2)+2:icr*tlsz(2)-1,:);
                
                if sum(tmpIm(:))==0
                    tmp = ['!' lineprnt];
                    tmp = strrep(tmp, '[', ' ');
                    lineprnt = tmp;
                else
                    fnd_tl_sw = 0;
                end                
                fprintf(fidO,lineprnt);
            end
            fprintf(fidO,'\n');
            
            FlsR(ifR).deletion(cr_in(icr)) = fnd_tl_sw;
            
        end
        
        fclose(fidO);
        
        fprintf(FdisL,'done!/n');
        
    end
    
end

%% Doing Sentient Beigns


disp(' ')
disp('Sentient creature text files')
fprintf(FdisL,'/n/nProcessing sentient reature text files:\n');

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
        fl_name = strrep(fl_name, 'creature', 'QS_ST_PRSN');
        
        fl_name2 = ['QS_ST/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name2 = strrep(fl_name2, 'creature', 'QS_ST_PRSN');
        
        fl_name3 = ['QS_ST\' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name3 = strrep(fl_name3, 'creature', 'QS_ST_PRSN');

        FileO = [FolderO 'raw\graphics\' fl_name '.txt'];
        
        fprintf(FdisL,['Processing ' fl_name '.txt...']);
        
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
                fprintf(fidO,['\t[FILE:' fl_name2 '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png]\n']);
                [ImgO,map,TrnsO] = imread([FolderO 'raw\graphics\' fl_name3 '_' num2str(tlsz(1)) 'x' num2str(tlsz(1)) '.png']);
            else
                fprintf(fidO,['\t[FILE:' fl_name2 num2str(ipgs) '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png]\n']);
                [ImgO,map,TrnsO] = imread([FolderO 'raw\graphics\' fl_name3 num2str(ipgs) '_' num2str(tlsz(1)) 'x' num2str(tlsz(1)) '.png']);
            end
            
            %Tile size
            fprintf(fidO,['\t[TILE_DIM:' num2str(tlsz(1)) ':' num2str(tlsz(2)) ']\n']);
            
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
                
                disp(['Setting up ' nameR])
                
                fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
                
                %Adding categories
                fnd_tl_sw = 1;  %Switch to mark for removal of creature if at least one tile is found it's turned off
                for ict = 1:length(catg_humanoids)
                    
                    %Extracting tile
                    Voff = ict-1;
                    tmpIm = ImgO(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,(ntl-1)*tlsz(2)+2:ntl*tlsz(2)-1,:);                    
                                        
                    for ipr=1:size(catg_humanoids(ict).name,2)
                        %Assembling line
                        tmpnm = catg_humanoids(ict).name{ipr};
                        cln_in = strfind(tmpnm,':');
                        lineprnt = ['\t[' tmpnm(1:cln_in(1)-1) ':' Pname ':' num2str(ntl-1) ':'  num2str(ict-1) tmpnm(cln_in(1):length(tmpnm)) ']\n'];
                        
                        if sum(tmpIm(:))==0
                            tmp = ['!' lineprnt];
                            tmp = strrep(tmp, '[', ' ');
                            lineprnt = tmp;
                        else
                            fnd_tl_sw = 0;
                        end
                        fprintf(fidO,lineprnt);
                    end
                    fprintf(fidO,'\n');
                end
                fprintf(fidO,'\n');
                
            FlsR(ifR).deletion(cr_in(icr)) = fnd_tl_sw;    
            end
            
            
        end
        
        fclose(fidO);
        
        fprintf(FdisL,'done!/n');
        
    end
    
end

%% Doing Major Races

disp(' ')
disp('Major races text files')

fprintf(FdisL,'Major race text files:\n');

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
            disp(['Setting up ' nameR])
            
            %Creating output name
            slsh_in = strfind(FlsR(ifR).name,'\');
            fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
            fl_name = strrep(fl_name, 'creature', ['QS_ST_MJR_' lower(nameR)]);
            
            fl_name2 = ['QS_ST/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
            fl_name2 = strrep(fl_name2, 'creature', ['QS_ST_MJR_' lower(nameR)]);
            
            fl_name3 = ['QS_ST\' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
            fl_name3 = strrep(fl_name3, 'creature', ['QS_ST_MJR_' lower(nameR)]);
            
            FileO = [FolderO 'raw\graphics\' fl_name '.txt'];
            
            fprintf(FdisL,['Processing ' fl_name '.txt...']);
            
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
            fprintf(fidO,['\t[FILE:' fl_name2 '_' num2str(tlsz(1)) 'x' num2str(tlsz(2)) '.png]\n']);
            
            %Tile size
            fprintf(fidO,['\t[TILE_DIM:' num2str(tlsz(1)) ':' num2str(tlsz(2)) ']\n']);
            
            %Page size
            fprintf(fidO,['\t[PAGE_DIM:' num2str(npr) ':' num2str(length(catg_humanoids)) ']\n\n']);
            
            fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
            
            [ImgO,map,TrnsO] = imread([FolderO 'raw\graphics\' fl_name2 '_' num2str(tlsz(1)) 'x' num2str(tlsz(1)) '.png']);
            
            %Adding categories
            fnd_tl_sw = 1;  %Switch to mark for removal of creature if at least one tile is found it's turned off
            for ict = 1:length(catg_humanoids)
                
                for ipr=1:size(catg_humanoids(ict).name,2)
                    %Assembling line
                    tmpnm = catg_humanoids(ict).name{ipr};
                    cln_in = strfind(tmpnm,':');
                    lineprnt = ['\t[' tmpnm(1:cln_in(1)-1) ':' Pname ':' num2str(ipr-1) ':'  num2str(ict-1) tmpnm(cln_in(1):length(tmpnm)) ']\n'];
                    
                    %Extracting tile
                    Voff = ict-1;
                    tmpIm = ImgO(Voff*tlsz(1)+2:(Voff+1)*tlsz(1)-1,(ipr-1)*tlsz(2)+2:ipr*tlsz(2)-1,:);
                    
                    if sum(tmpIm(:))==0
                        tmp = ['!' lineprnt];
                        tmp = strrep(tmp, '[', ' ');
                        lineprnt = tmp;
                    else
                        fnd_tl_sw = 0;
                    end
                    fprintf(fidO,lineprnt);
                
                end
                fprintf(fidO,'\n');
            end
            FlsR(ifR).deletion(cr_in(icr)) = fnd_tl_sw;
            
            fclose(fidO);
            
            fprintf(FdisL,'done!\n');
            
        end       
        
    end
    
end



%% Commenting out creatures without any tiles

disp(' ')
disp('Commenting out creatures without any tiles')

fprintf(FdisL,'Commenting out creatures without any tiles:\n');

%Finding all .txt standard files in the raw/graphics folder of the output set
FlsStd = rdir([FolderO 'raw\graphics\**\graphics_QS_ST*.txt']);

for ifR = 1:length(FlsR)
    
    cr_in = find(FlsR(ifR).deletion==1);
    ncr = length(cr_in);
    %Creating output file for creatures
    if ncr>0
        
        %Going through creatures
        for icr = 1:ncr
            
            nameR = FlsR(ifR).creatures{cr_in(icr)};
            disp(['Commenting out ' nameR])
            fprintf(FdisL,['Commenting out ' nameR '\n']);
            
            for ifG = 1:length(FlsStd)
                
                %Copy file of interest into dummy
                copyfile(FlsStd(ifG).name,'tmp.txt');
                
                fidG = fopen('tmp.txt');
                fidGo = fopen(FlsStd(ifG).name,'w');
                
                %Reading all file line by line until finding the end or
                %until finding target name
                rdln_sw = 1;
                while 1
                    
                    %Reading line
                    tlineG = fgetl(fidG);
                    if ~ischar(tlineG),   break,   end
                    
                    if ~isempty(strfind(tlineG, [':' nameR ']']))
                        tmp = ['!!' tlineG];
                        tmp = strrep(tmp, '[', ' ');
                        tlineG = tmp;
                    end
                    
                    fprintf(fidGo,[tlineG '\n']);
                    
                end
                
                fclose(fidG);
                fclose(fidGo);
               
            end
            
        end
        
    end
    
end


%% Cleaning empty originals
disp(' ')
disp('Cleaning empty originals')

fprintf(FdisL,'Cleaning empty originals...');

for ifG = 1:length(FlsG)
    
    
    fidG = fopen(FlsG(ifG).name);
        
    %Reading all file line by line to see if any creatures remain
    del_sw = true; %Switch indicating that file is marked for deletion

    while 1
        
        tlineG = fgetl(fidG);
        if ~ischar(tlineG),   break,   end
        
        tmp = strtrim(tlineG);
        if ~isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&strcmp(tmp(1),'[')
            del_sw = false;
            break
        end
        
    end
    
    fclose(fidG);
    
    if del_sw
        delete(FlsG(ifG).name)
    end
    
end
fprintf(FdisL,'done!\n');


fprintf(FdisL,'Changing Manifest.json...');
%Manifest
FlsStd = rdir([FolderO 'manifest.json']);
if ~isempty(FlsStd)
    
    %Copy file of interest into dummy
    copyfile(FlsStd(1).name,'tmp.txt');
    
    fidG = fopen('tmp.txt');
    fidGo = fopen(FlsStd(1).name,'w');
    
    %Reading all file line by line until finding the end and copying
    %file
    while 1
        
        %Reading line
        tlineG = fgetl(fidG);
        if ~ischar(tlineG),   break,   end
        
        
        if ~isempty(strfind(tlineG, '"title"'))

            qt_in = strfind(tlineG,'"');
            tlineG = [tlineG(1:max(qt_in)-1) ' Standard' tlineG(max(qt_in):length(tlineG))];
            
        end
        
        fprintf(fidGo,[tlineG '\n']);
        
    end
    
    fclose(fidG);
    fclose(fidGo);
    
end

fprintf(FdisL,'done!\n');
