% DF Graphics Standardization - Cleaning empty originals and Commenting out
% missing tiles
% Written by Andrés Muñoz-Jaramillo (Quiet-Sun)

%% Cleaning empty originals
for ifG = 1:length(FlsG)
    
    
    fidG = fopen(FlsG(ifG).name);
        
    %Reading all file line by line to see if any creatures remain
    del_sw = true; %Switch indicating that file is marked for deletion

    while 1
        
        tlineG = fgetl(fidG);
        if ~ischar(tlineG),   break,   end
        
        if ~isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))
            del_sw = false;
            break
        end
        
    end
    
    fclose(fidG);
    
    if del_sw
        delete(FlsG(ifG).name)
    end
    
end

%Copying files while substituting tile size

%Finding all Standard Files
FlsTx = rdir([FolderOtx '**\*.txt']);

for ifTx = 1:length(FlsTx)
    
    slsh_in = strfind(FlsTx(ifTx).name,'\');
    FileOtx = [FolderO 'raw\graphics\' FlsTx(ifTx).name(max(slsh_in)+1:length(FlsTx(ifTx).name))];
    
    
    fidTx = fopen(FlsTx(ifTx).name);
    fidTxO = fopen(FileOtx,'w');
    
        
    %Reading all file line by line and replacing tile sizes
    while 1
        
        tlineTx = fgetl(fidTx);
        if ~ischar(tlineTx),   break,   end
        
        if ~isempty(strfind(tlineTx,'X:X'))
            tlineTx = strrep(tlineTx, 'X:X', [num2str(tlsz(1)) ':' num2str(tlsz(2))]);
        end

        if ~isempty(strfind(tlineTx,'XxX'))
            tlineTx = strrep(tlineTx, 'XxX', [num2str(tlsz(1)) 'x' num2str(tlsz(2))]);
        end
        
        fprintf(fidTxO,[tlineTx '\n']);
        
    end
    
    fclose(fidTx);
    fclose(fidTxO);
    
    
end


