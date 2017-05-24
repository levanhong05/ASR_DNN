% Purpose : To split the data into Train/Test

spks = dir(audiofeatspath);

for i = 3:length(spks)
    
    spkname = spks(i).name;
    fprintf('Splitting data for speaker : %s \n',spkname);
    
    files = dir(strcat(audiofeatspath,spks(i).name));
    
    rng(i)
    ix = randperm(length(files)-2);
    
    spkaudiotrainpath = strcat(audio_trainpath,spks(i).name,'/');
    spkaudiotestpath = strcat(audio_testpath,spks(i).name,'/');
    spkidtrainpath = strcat(spkid_trainpath,spks(i).name,'/');
    spkidtestpath = strcat(spkid_testpath,spks(i).name,'/');
    
    mkdir(spkaudiotrainpath);
    mkdir(spkaudiotestpath);
    mkdir(spkidtrainpath);
    mkdir(spkidtestpath);
    
    for j = 1:length(ix)-2
        [fname,tok] = strtok(files(ix(j)+2).name,'.');
        system(['cp', ' ', strcat(audiofeatspath,spks(i).name,'/',files(ix(j)+2).name), ' ', strcat(spkaudiotrainpath,files(ix(j)+2).name)]);
        system(['cp', ' ', strcat(spklabelpath,spks(i).name,'/',fname,'.label'), ' ', strcat(spkidtrainpath,fname,'.label')]);
    end
    
    
    system(['cp', ' ', strcat(audiofeatspath,spks(i).name,'/',files(ix(j+1)+2).name), ' ', strcat(spkaudiotestpath,files(ix(j+1)+2).name)]);
    system(['cp', ' ', strcat(audiofeatspath,spks(i).name,'/',files(ix(j+2)+2).name), ' ', strcat(spkaudiotestpath,files(ix(j+2)+2).name)]);
    
    [fname,tok] = strtok(files(ix(j+1)+2).name,'.');
    system(['cp', ' ', strcat(spklabelpath,spks(i).name,'/',fname,'.label'), ' ', strcat(spkidtestpath,fname,'.label')]);
    [fname,tok] = strtok(files(ix(j+2)+2).name,'.');
    system(['cp', ' ', strcat(spklabelpath,spks(i).name,'/',fname,'.label'), ' ', strcat(spkidtestpath,fname,'.label')]);
end






