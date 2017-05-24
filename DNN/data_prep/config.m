% Purpose : Configuration script for ASV using GMMs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Data Prep %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wavpath = '../../../../ASR/TIMIT/dataset/train_wav_v1/';
mfccpath = '../rastamat';
voicebox = '../../../../../MatlabWorkspace/voicebox';
addpath(mfccpath);
addpath(voicebox);

% Features
pf = 'dan';
sf = 'stat';
audiofeatname  = strcat(pf,'_mfcc_',sf);
audiofeatspath = strcat('../../../feats/',audiofeatname,'/');
spklabelpath = strcat('../../../feats/','spkid','/');

mkdir(audiofeatspath)
mkdir(spklabelpath)

% frameshift in milli seconds
if strcmp(pf,'dan')
    frshiftms = 10; % for dan ellis mfcc feature extraction
else
    frshiftms = 8; % for voicebox mfcc feature extraction
end

% Train/Test
trainpath = '../../../data/train/';
testpath  = '../../../data/test/';

audio_trainpath = strcat(trainpath,audiofeatname,'/');
audio_testpath = strcat(testpath,audiofeatname,'/');

spkid_trainpath = strcat(trainpath,'spkid/');
spkid_testpath = strcat(testpath,'spkid/');

mkdir(audio_trainpath);
mkdir(audio_testpath);
mkdir(spkid_trainpath);
mkdir(spkid_testpath);

% Data path
matfilespath = '../../../matfiles/';
mkdir(matfilespath);

