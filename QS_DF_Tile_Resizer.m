% DF Tile resizer
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)

clear

disp('Matlab Script for upscaling-downscaling Graphics Sets v. 0.1')
disp('Made by Andrés Muñoz-Jaramillo aka Quiet-Sun')

disp(' ')
disp('Please select folder with graphic set to upscale')

%Asking user for folder with files to upscale/downscale
FolderI = uigetdir('','Select folder with graphic set to upscale');


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
disp('Please select which upscaling algorithm do you want to use')

% If upscaling, ask the user which algorithm to use provided
if pxI<pxO
    button = questdlg('Which upscaling algorithm do you want to use?','Upscaling Algorithm','HQx','Waifu2x','Waifu2x');
    HQx_sw = strcmp('HQx',button);   %Algorithm Switch, if true, use HQx.  I false, use Waifu2x
else
    HQx_sw = true;  %If downscaling, the algorithm switch is set to true because with HQx there is generally a downscaling step
end

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

FolderI = [FolderI '\'];
Foldertmp = [Foldertmp '\'];

%Clear output temporary and output folders
delete([Foldertmp '*'])


%Processing each folder inside the input folder
%Finding all PNGs
FilesI = rdir([FolderI '**\*.png']);

%Removing templates
FilesI = FilesI(cellfun(@isempty,strfind({FilesI.name}, 'QS_ST_TMP')));

%Going through each file
for i=1:length(FilesI)
    
    %-------------------------------------
    %Manipulating names to create the output file name
    
    if ~isempty(strfind(FilesI(i).name, [num2str(pxI) 'x' num2str(pxI)]))
        fileOut = strrep(FilesI(i).name, [num2str(pxI) 'x' num2str(pxI)], [num2str(pxO) 'x' num2str(pxO)]);
    else
        dot_in = strfind(FilesI(i).name,'.');
        fileOut = [FilesI(i).name(1:max(dot_in)-1) '_' num2str(pxO) 'x' num2str(pxO) FilesI(i).name(max(dot_in):length(FilesI(i).name))];
    end
    
    %Read the image (Img) and its transparency layer (Trns)
    [Img,map,Trns] = imread(FilesI(i).name);
    
    %If the size of the image is a multiple of the tile size process it
    if (mod(size(Img,1),pxI)==0)&&(mod(size(Img,2),pxI)==0)
        
        slsh_in = strfind(FilesI(i).name,'\');
        shrtnm = FilesI(i).name(max(slsh_in)+1:length(FilesI(i).name));
        
        disp(' ')
        disp(['Dissasembling ' shrtnm])
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
        
        %If the user is upscaling
        if pxI<pxO
            
            disp('Upscaling tiles')
            
            %Going through each saved tile and overwrite it with the
            %upscaled version
            for m = 1:size(Img,1)/pxI
                for n = 1:size(Img,2)/pxI
                    
                    disp(['Upscaling tile_' num2str(m) 'x' num2str(n) '.png'])
                    
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
        
        %If there is need to downscale
        if dwsz_sw&&(mod(pxO,pxI)~=0)
            
            disp('Downscaling tiles')
            
            %Going through each tile
            for m = 1:size(Img,1)/pxI
                for n = 1:size(Img,2)/pxI
                    
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
            
        end
        
        
        
        disp(['Reconstructing ' shrtnm])
        
        %Initializing output image (ImgO) and output transparency layer
        %(TrnsO)
        ImgO = uint8(zeros(size(Img,1)/pxI*pxO,size(Img,2)/pxI*pxO,3));
        
        if ~isempty(Trns)
            TrnsO = uint8(zeros(size(Img,1)/pxI*pxO,size(Img,2)/pxI*pxO));
        end
        
        %Adding each tile
        for m = 1:size(Img,1)/pxI
            for n = 1:size(Img,2)/pxI
                
                %Reading each tile
                [Imgt,mapt,Trnst] = imread([Foldertmp 'tile_' num2str(m) 'x' num2str(n) '.png']);
                %Adding it
                ImgO(1+(m-1)*pxO:m*pxO,1+(n-1)*pxO:n*pxO,:) = Imgt;
                if ~isempty(Trns)
                    TrnsO(1+(m-1)*pxO:m*pxO,1+(n-1)*pxO:n*pxO) = Trnst;
                end
                
            end
            
        end
        
        %Saving the output file
        if ~isempty(Trns)
            imwrite(ImgO,fileOut,'png','Alpha',double(TrnsO)/255)
        else
            imwrite(ImgO,fileOut,'png')
        end
        
        %Clearing temporary folder
        delete([Foldertmp '*'])
        
    else
        %If a file is found with a weird size let the user know
        disp([shrtnm ' is not divisible by ' num2str(pxI)])
    end
end


disp('Done!')


