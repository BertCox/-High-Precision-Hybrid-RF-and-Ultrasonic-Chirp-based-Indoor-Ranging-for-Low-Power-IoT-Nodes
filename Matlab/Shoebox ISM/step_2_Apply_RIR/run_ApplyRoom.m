function run_ApplyRoom();
%% test_ApplyRoom.m
%      configuration file for simplified use of the ApplyRoom software
%
% -----------------------------------------------------------
% version 1.2007.04.25
% 
% author: ir. H. Brouckxon, Vrije Universiteit Brussel, dept ETRO-DSSP
%
% Revision History:
%     2007.01.20: First version (H. Brouckxon)

% room configuration

room_nbr = 3;

% excitation signals

excitation(1).filename = '.\input_audio\32 kHz\spfe49_1.wav';
excitation(1).level = 0.2;
excitation(2).filename = '.\input_audio\32 kHz\spff51_1.wav';
excitation(2).level = 0.2;
excitation(3).filename = '.\input_audio\32 kHz\spfg53_1.wav';
excitation(3).level = 0.2;
excitation(4).filename = '.\input_audio\32 kHz\spme50_1.wav';
excitation(4).level = 0.2;
excitation(5).filename = '.\input_audio\32 kHz\spmf52_1.wav';
excitation(5).level = 0.2;
excitation(6).filename = '.\input_audio\32 kHz\spmg54_1.wav';
excitation(6).level = 0.5;
%excitation(7).filename = '.\input_audio\32 kHz\abba_69.wav';
%excitation(7).level = 0.2;


%excitation(8).filename = '.\input_audio\32 kHz\spfe49_1.wav';
%excitation(8).level = 0.5;


% uncorrellated microphone self-noise parameters
mic_noise.type = 'white'; % 'none' or 'white'
mic_noise.level = -55; % dB SNR

% drawing flag

draw = true;

% run ApplyRoom

applyroom(room_nbr, excitation, mic_noise, draw);


