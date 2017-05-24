% Purpose : Make training data for ASV using DNN

spks = dir(audiofeatspath);

data = [];
targets = [];
clv = [];

for i = 3:length(spks)
    
    spkname = spks(i).name;
    fprintf('Making training data for speaker : %s \n',spkname);
    
    files = dir(strcat(audio_trainpath,spks(i).name));
        
    spkaudiotrainpath = strcat(audio_trainpath,spks(i).name,'/');
    spkidtrainpath = strcat(spkid_trainpath,spks(i).name,'/');

    X = []; Y = [];
    for j = 3:length(files)
        [fname,tok] = strtok(files(j).name,'.');
        D = dlmread(strcat(spkaudiotrainpath,files(j).name));
        T = dlmread(strcat(spkidtrainpath,fname,'.label'));
        
        n1 = size(D,1);
        n2 = size(T,1);
        
        nmin = min([n1 n2]);
        
        D = D(1:nmin,:);
        T = T(1:nmin,:);
        
        X = [X;D];
        Y = [Y;T];
    end
    
    data = [data;single(X)];
    targets = [targets;single(Y)];
    clv = [clv;size(X,1)];
    
end

save(strcat(matfilespath,'train.mat'),'data','targets','clv','-v7.3')