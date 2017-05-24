% Purpose : Extract MFCC features for each of the speakers data

clear all; close all; clc;

% set paths
wavpath = '../../../../ASR/TIMIT/dataset/train_wav_v1/';
statfeatspath = '../../../feats/vb_mfcc_stat/';
dynfeatspath = '../../../feats/vb_mfcc_dd/';
mfccpath = '../rastamat';
voicebox = '../../../../../MatlabWorkspace/voicebox';

addpath(mfccpath);
addpath(voicebox);

mkdir(statfeatspath);
mkdir(dynfeatspath);

spks = dir(wavpath);

for i = 3:length(spks)
    spkname = spks(i).name;
    fprintf('Extracting MFCC features for speaker : %s \n',spkname);
    
    spkdir = strcat(wavpath,spkname,'/');
    files = dir(spkdir);
    
    mkdir(strcat(statfeatspath,spkname,'/'))
    mkdir(strcat(dynfeatspath,spkname,'/'))
    
    for j = 3:length(files)
        [fname,tok] = strtok(files(j).name,'.');
        [y,fs] = wavread(strcat(spkdir,files(j).name));
        
        % Voicebox MFCC
        c = melcepst(y,fs,'e0dD');
        
        %         % Extract MFCC
        %         [cep,aspec,pspec] = melfcc(y, fs,'lifterexp',-22,'nbands',20,'maxfreq',8000,'sumpower',0,'fbtype','htkmel','dcttype',3);
        %
        %         % Extract  deltas + del-deltas
        %         d = deltas(cep);
        %         dd = deltas(deltas(cep,5),5);
        %         dcep = [cep;d;dd];
        
        % Write MFCC features to a file
        dlmwrite(strcat(statfeatspath,spkname,'/',fname,'.mfcc'),c(:,1:13),'delimiter',' ');
        dlmwrite(strcat(dynfeatspath,spkname,'/',fname,'.mfcc'),c,'delimiter',' ');
        
    end
    
end


