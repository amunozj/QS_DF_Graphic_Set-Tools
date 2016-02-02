% DF Graphics Standardization
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)
fclose('all')
clear

%
txtsize = 8;

%Asking user for DF bulild to base itself upon
FolderR = uigetdir('','Select folder with reference DF build');

disp('Creating Output folders')

FolderO = [pwd '\zzOut_txt'];   %Output Folder
mkdir(FolderO);
FolderO = [FolderO '\'];

%Finding all .txt files in reference folder
FlsR = rdir([FolderR '\**\*.txt']);

%Definition of categories
nct = 0;

fidC = fopen('CATEGORIES_CREATURES.txt');

while 1
    
    %Reading line
    tlineC = fgetl(fidC);
    if ~ischar(tlineC),   break,   end
    nct = nct + 1;
    categories(nct).name = tlineC;
    
    
end

fclose(fidC);



%Going through all found files

for ifR = 1:length(FlsR)
    
    
    disp('Counting number of creatures')
    ncr = 0;
    fidR = fopen(FlsR(ifR).name);
    
    while 1
        
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end
        
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&isempty(strfind(tlineR,'MAN'))
            ncr = ncr+1;
        end
        
    end
    
    fclose(fidR);
    
    %% Creating output file    
    if ncr>0
        
        fidR = fopen(FlsR(ifR).name);
        
        %Creating output name
        slsh_in = strfind(FlsR(ifR).name,'\');
        FileO = [FolderO 'graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4) '.txt'];
        
        %Opening output file
        fidO = fopen(FileO,'w');
        
        %Creating Header
        Pname =  upper(FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4));
        undr_in = [0 strfind(Pname,'_')];
        
        %Creating short title page
        tmp = ['GR'];
        for i = 1:length(undr_in)
            tmp = strcat(tmp,['_' Pname(undr_in(i)+1:undr_in(i)+3)])
        end
        tmp = strcat(tmp,num2str(ifR));
        
        Pname = tmp;
        
        %Name
        fprintf(fidO,['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4) '\n\n']);
        
        %Object
        fprintf(fidO,'[OBJECT:GRAPHICS]\n\n');
        
        %Title Page
        fprintf(fidO,['[TILE_PAGE:' Pname ']\n']);
        
        %File
        fprintf(fidO,['\t[FILE:' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4) '.png]\n']);
        
        %Tile size
        fprintf(fidO,'\t[TILE_DIM:X:X]\n');
        
        %Page size
        fprintf(fidO,['\t[PAGE_DIM:' num2str(ncr) ':' num2str(nct) ']\n\n']);
       
        ntl = 1;
        
        %Reading all file line by line until finding the end
        while 1
            
            %Reading line
            tlineR = fgetl(fidR);
            if ~ischar(tlineR),   break,   end
            
            tmp = strtrim(tlineR);
            %If finding a creature name look for the respective tile
            if ~isempty(strfind(tlineR,'[CREATURE:'))&&isempty(strfind(tlineR,'MAN]'))&&isempty(strfind(tlineR,'ELEMENTMAN'))&&isempty(strfind(tlineR,'GORLAK]'))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&strcmp(tmp(1),'[')
                
                nameR = tlineR(strfind(tlineR,':')+1:strfind(tlineR,']')-1);
                
%                 fidEx = fopen('NAME_EXEPTIONS.txt');
%                 
%                 while 1
%                    
%                     %Reading line
%                     tlineEx = fgetl(fidEx);
%                     if ~ischar(tlineEx),   break,   end
%                     
%                     cln_in = strfind(tlineEx,':');
%                     
%                     if strcmp(tlineEx(1:cln_in-1),nameR)
%                        nameR = tlineEx(cln_in+1:length(tlineEx));
%                        break                        
%                     end
%                     
%                 end
%                 
%                 fclose(fidEx);
    
                fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
                
                %Adding categories                
                for ict = 1:nct
                    fprintf(fidO,['\t[' categories(ict).name ':' Pname ':' num2str(ntl-1) ':'  num2str(ict-1) ':AS_IS:DEFAULT]\n']);
%                     fprintf(fidO,['\t[' categories(ict).name ':' Pname ':' num2str(ntl-1) ':'  num2str(ict-1) ':ADD_COLOR:DEFAULT]\n']);
                end
                fprintf(fidO,'\n');
                
                
                
                ntl = ntl+1;
            end
            
            
        end
        
        fclose(fidO);
        fclose(fidR);
        
    end
    

    
    
end


load('gong','Fs','y')
sound(y, Fs);

