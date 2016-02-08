% DF Tile resizer
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)

clear
fclose('all');

disp('Matlab Script for upscaling-downscaling Graphics Sets v. 0.5')
disp('Made by Andrés Muñoz-Jaramillo aka Quiet-Sun')

disp(' ')
disp('Please select folder with graphic set to upscale/text change')

%Asking user for folder with files to upscale/downscale
FolderI = uigetdir('','Select folder with graphic set to upscale/text change');
FolderO = [FolderI '\'];

disp(' ')
disp('Please select original and final pixel sizes')

%Asking user for initial and final pixel size
prompt = {'Enter ORIGINAL pixel size:','Enter desired FINAL pixel Size:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'16','24'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);


pxI = str2num(answer{1});  %Initial pixel size
pxO = str2num(answer{2});  %Output pixel size


disp(' ')
disp('Please select if you want the resizer to modify your txt files to the new resolution')
button = questdlg('Do you want the code to modify your txt files to the new resolution?','Image template choice','Yes','No','No');

if strcmp(button,'Yes')
    res_sw = true;
else
    res_sw = false;
end


disp(' ')
disp('Please select if you want the resizer to scale your image files (a new folder will be created)')
button = questdlg('Do you want the code to scale your image files?','Image template choice','Yes','No','No');

if strcmp(button,'Yes')
    
% If upscaling, ask the user if they want to dissasembly each image first    
disp(' ')
disp('Please select if you want the each image to be dissasembled into individual tiles')
button = questdlg('Do you want the code to dissasemble the images into individual tiles first?','Dissasembly choice','Yes','No','No');

if strcmp(button,'Yes')
    dis_sw = true;
else
    dis_sw = false;
end    
    
    
    % If upscaling, ask the user which algorithm to use provided
    if pxI<pxO
        
        disp(' ')
        disp('Please select which upscaling algorithm do you want to use')
        
        
        button = questdlg('Which upscaling algorithm do you want to use?','Upscaling Algorithm','HQx','Waifu2x','Lanczos3','Lanczos3');
        HQx_sw = strcmp('HQx',button);   %Algorithm Switch, if true, use HQx.  I false, use Waifu2x
        Lan3_sw = strcmp('Lanczos3',button);
    else
        HQx_sw = true;  %If downscaling, the algorithm switch is set to true because with HQx there is generally a downscaling step
    end
    
    
    disp(' ')
    disp('Creating Output folders')
    slsh_in = strfind(FolderI,'\');
    FolderO = [FolderI(max(slsh_in)+1:length(FolderI)) '-Scaled'];   %Output Folder
    mkdir(FolderO);
    rmdir(FolderO ,'s')
    mkdir(FolderO);
    
    %Create target folder
    copyfile(FolderI,FolderO)
    FolderO = [FolderO '\'];
    
    FdisL = fopen([FolderO 'Log_3_Resizer.txt'],'w');
    
    
    %     disp(' ')
    %     disp('Please select if you want the resizer to modify your txt files to the new resolution')
    %     button = questdlg('Do you want the code to modify your txt files to the new resolution?','Image template choice','Yes','No','No');
    %
    %     if strcmp(button,'Yes')
    %         res_sw = true;
    %     else
    %         res_sw = false;
    %     end
    
    
    dwsz_sw = true;
    % % If using HQx or downscaling set downscaling switch to true
    % if HQx_sw
    %     dwsz_sw = true;     %Downscaling switch
    % else
    %     %If using Waifu2x then ask the user whether let Matlab do the
    %     %downscaling, or the external converter
    %     button = questdlg('Exact scaling factor, or closest upper integer scaling factor with downscale?','Upscaling factor','Exact','Integer with Downscaling','Exact');
    %     dwsz_sw = ~strcmp('Exact',button);
    % end
    
    
    %Calculating integer or exact scaling factor
    if dwsz_sw
        amp = ceil(pxO/pxI);
    else
        amp = pxO/pxI;
    end
    
    %If downscaling ask user for algorithm to use
    %
    % disp(' ')
    % disp('Please select which downscaling algorithm do you want to use (for non-integer sizes)')
    % if dwsz_sw|(pxO<pxI)
    %
    %     Algth = {'nearest','bilinear','bicubic','lanczos2','lanczos3'};
    %     [sel,v] = listdlg('PromptString','Which downscaling algorithm do you want to use?',...
    %         'SelectionMode','single',...
    %         'InitialValue',5,...
    %         'ListString',Algth);
    %
    %     Algth = Algth{sel};
    %
    % end
    
    Algth = 'lanczos3';
    
    disp(' ')
    disp('Creating temporary dissasembly folder')
    
    Foldertmp = 'Tile_tmp';   %Temporary folder
    mkdir(Foldertmp);
    
    Foldertmp = [Foldertmp '\'];
    
    %Clear output temporary and output folders
    delete([Foldertmp '*'])
    
    
    %Processing each folder inside the input folder
    %Finding all PNGs
    FilesI = rdir([FolderO '**\*.png']);
    
    %Removing templates
    FilesI = FilesI(cellfun(@isempty,strfind({FilesI.name}, 'QS_ST_TMP')));

    %Removing files with the target size
    FilesI = FilesI(cellfun(@isempty,strfind({FilesI.name}, [num2str(pxO) 'x'])));
    
    fidEX = fopen('UPSCALING_EXEPTIONS.txt');
    
    %Reading all file line by line until finding the end and copying
    %file
    while 1
        
        %Reading line
        tlineEX = fgetl(fidEX);
        if ~ischar(tlineEX),   break,   end
        
        %Removing files with the target size
        FilesI = FilesI(cellfun(@isempty,strfind({FilesI.name}, tlineEX)));
        
    end
    
    
    %Going through each file
    for i=1:length(FilesI)
        
        %-------------------------------------
        %Manipulating names to create the output file name
        
        if ~isempty(strfind(FilesI(i).name, [num2str(pxI) 'x' num2str(pxI)]))
            fileOut = strrep(FilesI(i).name, [num2str(pxI) 'x' num2str(pxI)], [num2str(pxO) 'x' num2str(pxO)]);
            FileInNew = FilesI(i).name;
        else
            dot_in = strfind(FilesI(i).name,'.');
            fileOut = [FilesI(i).name(1:max(dot_in)-1) '_' num2str(pxO) 'x' num2str(pxO) FilesI(i).name(max(dot_in):length(FilesI(i).name))];
            FileInNew = [FilesI(i).name(1:max(dot_in)-1) '_' num2str(pxI) 'x' num2str(pxI) FilesI(i).name(max(dot_in):length(FilesI(i).name))];
            copyfile(FilesI(i).name,FileInNew);
            delete(FilesI(i).name)
        end
        
        %Making sure the image doesn't exist
        if isempty(rdir(fileOut))
            
            %Read the image (Img) and its transparency layer (Trns)
            [Img,map,Trns] = imread(FileInNew);
            
            if (size(Img,3)~=3)&&~isempty(map)
                Img = ind2rgb(Img,map);
            elseif (size(Img,3)~=3)
                Img = cat(3, Img, Img, Img);
            end
            
            if isempty(Trns)
                Trns = Img(:,:,1)*0+255;
            end
                
            
            %If the size of the image is a multiple of the tile size process it
            if (mod(size(Img,1),pxI)==0)&&(mod(size(Img,2),pxI)==0)&&dis_sw
                
                slsh_in = strfind(FileInNew,'\');
                shrtnm = FileInNew(max(slsh_in)+1:length(FileInNew));
                
                disp(' ')
                disp(['Dissasembling ' shrtnm])
                fprintf(FdisL,['Dissasembling ' shrtnm ' ...']);
                
                %Going through each tile
                for m = 1:size(Img,1)/pxI
                    for n = 1:size(Img,2)/pxI
                        
                        %Place a section on a temporary variable
                        tmpim = Img(1+(m-1)*pxI:m*pxI,1+(n-1)*pxI:n*pxI,:);
                        
                        %If it has a transparency layer save it
                        if ~isempty(Trns)
                            tmptrs = Trns(1+(m-1)*pxI:m*pxI,1+(n-1)*pxI:n*pxI);
                            imwrite(tmpim,[Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'],'png','Alpha',double(tmptrs)/255)
                        else
                            imwrite(tmpim,[Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'],'png')
                        end
                        
                    end
                end
                fprintf(FdisL,'done!\n');
                
                %If the user is upscaling
                if (pxI<pxO)&&~Lan3_sw
                    
                    disp(' ')
                    disp('Upscaling tiles using HQx or Weifu2x')
                    
                    
                    if HQx_sw
                        fprintf(FdisL,'Upscaling tiles using HQx...');
                    else
                        fprintf(FdisL,'Upscaling tiles using Weifu2x...');
                    end
                    
                    
                    %Going through each saved tile and overwrite it with the
                    %upscaled version
                    for m = 1:size(Img,1)/pxI
                        for n = 1:size(Img,2)/pxI

                            [Imgt,mapt,Trnst] = imread([Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png']);
                            
                            tmpI = Imgt(2:pxI-1,2:pxI-1,:);
                            tmpT = Trnst(2:pxI-1,2:pxI-1);
                            
                            R = tmpI(:,:,1);
                            G = tmpI(:,:,2);
                            B = tmpI(:,:,3);
                            
                            %If image is transparent, or of uniform color
                            %simply create a big empty tile
                            if (sum(tmpT(:))==0)||((sum(R(:)~=min(R(:)))==0)&&(sum(G(:)~=min(G(:)))==0)&&(sum(B(:)~=min(B(:)))==0))
                                
%                                 disp(['Tile ' num2str(m) 'x' num2str(n) '.png is empty using blank tile.'])
%                                 fprintf(FdisL,['Tile ' num2str(m) 'x' num2str(n) '.png is empty using blank tile.\n']);
                                
                                %Creating Images without names
                                Imgt  = uint8(zeros(pxO,pxO,3));
                                Trnst = uint8(zeros(pxO,pxO));
                                
                                imwrite(Imgt,[Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'],'png','Alpha',double(Trnst)/255)
                                
                            else
%                                 disp(['Upscaling tile_' num2str(m) 'x' num2str(n) '.png'])
%                                 fprintf(FdisL,['Upscaling tile_' num2str(m) 'x' num2str(n) '.png\n']);
                                
                                %Calling external upscaling binaries
                                if HQx_sw
                                    %Using HQx
                                    [status,cmdout] = system(['hqx\bin\hqx.exe -s ' num2str(amp) ' "' [Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'] '" "' [Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'] '"'],'-echo');
                                else
                                    %Using Waifu2x
                                    [status,cmdout] = system(['waifu2x\waifu2x-converter_x64.exe --model_dir waifu2x\models_rgb -i "' [Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'] '" --scale_ratio ' num2str(amp) ' -o "' [Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'] '"'],'-echo');
                                end
                                
                            end
                            
                        end
                        
                    end
                    fprintf(FdisL,'Done.\n');
                    
                end
                
                %If there is need to downscale
                if dwsz_sw&&(mod(pxO,pxI)~=0)||Lan3_sw
                    
                    disp(' ')
                    disp('Upscaling/Downscaling tiles using Lanczos3')
                    
                    fprintf(FdisL,'Upscaling/Downscaling tiles using Lanczos3...');
                    
                    %Going through each tile
                    for m = 1:size(Img,1)/pxI
                        for n = 1:size(Img,2)/pxI
                            
%                             disp(['Upscaling/Downscaling tile_' num2str(m) 'x' num2str(n) '.png'])
%                             fprintf(FdisL,['Upscaling/Downscaling tile_' num2str(m) 'x' num2str(n) '.png\n']);
                            
                            [Imgt,mapt,Trnst] = imread([Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png']);
                            tmpim = imresize(Imgt,[pxO pxO],Algth);
                            
                            %Making sure transparency is saved if necessary
                            if ~isempty(Trnst)
                                tmptrs = imresize(Trnst,[pxO pxO]);
                                imwrite(tmpim,[Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'],'png','Alpha',double(tmptrs)/255)
                            else
                                imwrite(tmpim,[Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png'],'png')
                            end
                            
                        end
                        
                    end
                    
                    fprintf(FdisL,'Done.\n');
                    
                end
                
                
                disp(' ')
                disp(['Reconstructing ' shrtnm])
                
                fprintf(FdisL,['Reconstructing ' shrtnm '...']);
                
                %Initializing output image (ImgO) and output transparency layer
                %(TrnsO)
                ImgO = uint8(zeros(size(Img,1)/pxI*pxO,size(Img,2)/pxI*pxO,3));
                
                if ~isempty(Trns)
                    TrnsO = uint8(zeros(size(Img,1)/pxI*pxO,size(Img,2)/pxI*pxO));
                end
                
                %Adding each tile
                for m = 1:size(Img,1)/pxI
                    for n = 1:size(Img,2)/pxI
                        
%                         disp(['Adding tile_' num2str(m) 'x' num2str(n) '.png'])
%                         fprintf(FdisL,['Adding tile_' num2str(m) 'x' num2str(n) '.png\n']);
                        %Reading each tile
                        [Imgt,mapt,Trnst] = imread([Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png']);
                        
                        %Adding it
                        ImgO(1+(m-1)*pxO:m*pxO,1+(n-1)*pxO:n*pxO,:) = Imgt;
                        if ~isempty(Trns)
                            TrnsO(1+(m-1)*pxO:m*pxO,1+(n-1)*pxO:n*pxO) = Trnst;
                        end
                        
                    end
                    
                end
                
                fprintf(FdisL,'Done.\n\n');
                
                %Saving the output file
                if ~isempty(Trns)
                    imwrite(ImgO,fileOut,'png','Alpha',double(TrnsO)/255)
                else
                    imwrite(ImgO,fileOut,'png')
                end
                
                %Clearing temporary folder
                delete([Foldertmp '*'])
                
            elseif dis_sw
                %If a file is found with a weird size let the user know
                disp([shrtnm ' is not divisible by ' num2str(pxI)])
                fprintf(FdisL,[shrtnm ' is not divisible by ' num2str(pxI) '\n']);
                
            %If no dissasembly is desired:
            else
                
                slsh_in = strfind(FileInNew,'\');
                shrtnm = FileInNew(max(slsh_in)+1:length(FileInNew));
                
                disp(['Processing ' shrtnm])
                fprintf(FdisL,['Processing ' shrtnm ':\n']);
                
                %If the user is upscaling
                if (pxI<pxO)&&~Lan3_sw
                    
                    disp(' ')
                    disp('Upscaling using HQx or Weifu2x')
                    
                    if HQx_sw
                        fprintf(FdisL,'Upscaling using HQx...');
                    else
                        fprintf(FdisL,'Upscaling using Weifu2x...');
                    end
                                
                    %Calling external upscaling binaries
                    if HQx_sw
                        %Using HQx
                        [status,cmdout] = system(['hqx\bin\hqx.exe -s ' num2str(amp) ' "' FileInNew '" "' fileOut '"'],'-echo');
                    else
                        %Using Waifu2x
                        [status,cmdout] = system(['waifu2x\waifu2x-converter_x64.exe --model_dir waifu2x\models_rgb -i "' FileInNew '" --scale_ratio ' num2str(amp) ' -o "' fileOut '"'],'-echo');
                    end
                                
                    fprintf(FdisL,'Done.\n');
                    
                end
                
                %If there is need to downscale
                if dwsz_sw&&(mod(pxO,pxI)~=0)||Lan3_sw
                    
                    disp(' ')
                    disp('Upscaling/Downscaling using Lanczos3')
                    
                    fprintf(FdisL,'Upscaling/Downscaling using Lanczos3...');
                    
                    tmpim = imresize(Img,round([size(Img,1) size(Img,2)]*amp),Algth);
                    tmptrs = imresize(Trns,round([size(Img,1) size(Img,2)]*amp));
                    imwrite(tmpim,fileOut,'png','Alpha',double(tmptrs)/255)
                    
                    fprintf(FdisL,'Done.\n');
                    
                end                
                
                fprintf(FdisL,'\n');
                
            end
            
        end
        
    end
    
    
else
    
   FdisL = fopen([FolderO 'Log_3_Resizer.txt'],'w');
    
end


%Finding all .txt standard files in the raw/graphics folder of the output set
FlsStd = rdir([FolderO 'raw\graphics\**\*.txt']);

disp(' ')
disp('Changing text files')
fprintf(FdisL,['Changing text files:\n']);

if res_sw
    
    % raw/graphics
    for ifR = 1:length(FlsStd)
        
        
        %Copy file of interest into dummy
        copyfile(FlsStd(ifR).name,'tmp.txt');
        
        fidG = fopen('tmp.txt');
        fidGo = fopen(FlsStd(ifR).name,'w');
        
        slsh_in = strfind(FlsStd(ifR).name,'\');
        fprintf(FdisL,['Processing ' FlsStd(ifR).name(max(slsh_in)+1:length(FlsStd(ifR).name)) '\n']);
        
        %Reading all file line by line until finding the end and copying
        %file
        while 1
            
            %Reading line
            tlineG = fgetl(fidG);
            if ~ischar(tlineG),   break,   end
            
            
            if ~isempty(strfind(tlineG, '.png'))
                
                if ~isempty(strfind(tlineG, [num2str(pxI) 'x' num2str(pxI)]))
                    tlineG = strrep(tlineG, [num2str(pxI) 'x' num2str(pxI)], [num2str(pxO) 'x' num2str(pxO)]);
                else
                    dot_in = strfind(tlineG,'.');
                    tlineG = [tlineG(1:max(dot_in)-1) '_' num2str(pxO) 'x' num2str(pxO) tlineG(max(dot_in):length(tlineG))];
                end
                
            end
            
            
            if ~isempty(strfind(tlineG, '[TILE_DIM:'))
                
                tlineG = strrep(tlineG, [num2str(pxI) ':' num2str(pxI)], [num2str(pxO) ':' num2str(pxO)]);
            end
            
            fprintf(fidGo,[tlineG '\n']);
            
        end
        
        fclose(fidG);
        fclose(fidGo);
        
        
    end
    fprintf(FdisL,'Done with text files.\n\n');
    
    
    
    %Manifest
    FlsStd = rdir([FolderO 'manifest.json']);
    if ~isempty(FlsStd)
        
        fprintf(FdisL,'Changing Manifest.json...');
        
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
                
                if ~isempty(strfind(tlineG, [num2str(pxI) 'px']))
                    tlineG = strrep(tlineG, [num2str(pxI) 'px'], [num2str(pxO) 'px']);
                end
                
                qt_in = strfind(tlineG,'"');
                tlineG = [tlineG(1:max(qt_in)-1) ' Scaled' tlineG(max(qt_in):length(tlineG))];
                
            end
            
            fprintf(fidGo,[tlineG '\n']);
            
        end
        
        fclose(fidG);
        fclose(fidGo);
        fprintf(FdisL,'Done.\n\n');
        
    end
    
    
    %Init
    FlsStd = rdir([FolderO '**\init.txt']);
    if ~isempty(FlsStd)
        
        fprintf(FdisL,'Changing init.txt...');
        
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
            
            
            if ~isempty(strfind(tlineG, '[GRAPHICS_FONT:'))||~isempty(strfind(tlineG, '[GRAPHICS_FULLFONT:'))
                
                if ~isempty(strfind(tlineG, [num2str(pxI) 'x' num2str(pxI)]))
                    tlineG = strrep(tlineG, [num2str(pxI) 'x' num2str(pxI)], [num2str(pxO) 'x' num2str(pxO)]);
                else
                    dot_in = strfind(tlineG,'.');
                    tlineG = [tlineG(1:max(dot_in)-1) '_' num2str(pxO) 'x' num2str(pxO) tlineG(max(dot_in):length(tlineG))];
                end
                
            end
            
            fprintf(fidGo,[tlineG '\n']);
            
        end
        
        fclose(fidG);
        fclose(fidGo);
        
        fprintf(FdisL,'Done.\n\n');
        
    end
    
    
    
else
    
    for ifR = 1:length(FlsStd)
        
        
        %Copy file of interest into dummy
        copyfile(FlsStd(ifR).name,'tmp.txt');
        
        fidG = fopen('tmp.txt');
        fidGo = fopen(FlsStd(ifR).name,'w');
        
        slsh_in = strfind(FlsStd(ifR).name,'\');
        fprintf(FdisL,['Processing ' FlsStd(ifR).name(max(slsh_in)+1:length(FlsStd(ifR).name)) '\n']);        
        
        %Reading all file line by line until finding the end and copying
        %file
        while 1
            
            %Reading line
            tlineG = fgetl(fidG);
            if ~ischar(tlineG),   break,   end
            
            
            if ~isempty(strfind(tlineG, '.png'))
                
                if isempty(strfind(tlineG, [num2str(pxI) 'x' num2str(pxI)]))
                    dot_in = strfind(tlineG,'.');
                    tlineG = [tlineG(1:max(dot_in)-1) '_' num2str(pxI) 'x' num2str(pxI) tlineG(max(dot_in):length(tlineG))];
                end
                
            end
            
            fprintf(fidGo,[tlineG '\n']);
            
        end
        
        fclose(fidG);
        fclose(fidGo);
        
        
    end
    
    
    
end


load('gong','Fs','y')
sound(y, Fs);

fprintf(FdisL,'Done with all!');
fclose(FdisL);

disp('Done!')


