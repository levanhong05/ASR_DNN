% Purpose : Run script for data preparation

clear all; close all; clc;

% Load configuration file
config

% Audio feature extraction
extract_mfcc

% Generate speaker labels
gen_spkid

% Train'n'Test Split
split_trainntest

% Make train data
make_traindata

% Make test data
make_testdata