% Purpose : Make Speaker ID labels

% Make speaker ID Vector
spks = dir(wavpath);
numspks = length(spks) - 2;

for i = 3:length(spks)
    
    spkdir = strcat(wavpath,spks(i).name,'/');
    files = dir(spkdir);
    tgtspkdir = strcat(spklabelpath,spks(i).name,'/');
    mkdir(tgtspkdir);
    
    for j = 3:length(files)
        fprintf('Generateing speaker labels for spk : %s ; file : %s ...\n',spks(i).name,files(j).name);
        
        % Get the duration of each wavfile
        [fname,tok] = strtok(files(j).name,'.');
        aa = mmfileinfo(strcat(spkdir,files(j).name));
        dur = aa.Duration;
        
        nof = round((dur/frshiftms)*1000);
        spkid = zeros(nof,numspks);
        spkid(:,i-2) = 1;
        dlmwrite(strcat(tgtspkdir,fname,'.label'),spkid,'delimiter',' ');
    end
    
    
end

