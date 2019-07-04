function ApplyRoom(room, RIR_path, sources_path, microphones_path)
% ApplyRoom.m
%    Based on the room impulse responses, this program simulates the
%    microphone outputs that correspond to the given excitation signals.
%    The impulse responses can for example be calculated using 
%    the roomsim software.
%
% Parameters:
%    * room: structure containing the room/source/microphone configuration
%                that will be simulated.
%    * RIR_path: path containing the room impulse responses
%    * sources_path: path containing the audio files for the sound sources
%    * microphones_path: path for the microphone audio files
% -----------------------------------------------------------
% version 2.2015.01.13
% 
% author: ir. H. Brouckxon, Vrije Universiteit Brussel, dept ETRO-DSSP
%
% Revision History:
%     2007.01.20: First version (H. Brouckxon)

if not(exist(microphones_path,'dir'))
    s = mkdir(microphones_path);
end;

%% generate intermediate audio files for each source-microphone pair  
max_length= 0;
for kk = 1:length(room.soundsource),
    % read the audio input for sound source kk
    source_signal = audioread([sources_path 'source' int2str(kk) '.wav']);
    for ii = 1:length(room.node),
        for jj = 1:length(room.node(ii).mic),
            % read room impulse response from source kk to microphone(ii,jj) 
            RIRfile = [RIR_path 'RIR_source_' int2str(kk) ...
                                '_node_' int2str(ii) ...
                                '_mic_' int2str(jj) '.mat'];
            load(RIRfile, 'data');
            RIR = data;
            
            % calculate contribution of source kk to the signal in microphone(ii,jj)
            int_signal = filter(RIR, 1, source_signal); 
            
            % save to an intermediate audio file
            INTfile = [microphones_path 'INT_source_' int2str(kk) ...
                                '_node_' int2str(ii) ...
                                '_mic_' int2str(jj) '.wav'];
            audiowrite(INTfile, int_signal, room.fs); 
            
            if (length(int_signal) > max_length),
                max_length = length(int_signal);
            end;
        end;
    end;
end;

%% sum the contributions from all sources to get the complete signal for microphone(ii,jj)

for ii = 1:length(room.node),
    for jj = 1:length(room.node(ii).mic),
        mic_signal = zeros(max_length,1);
        for kk = 1:length(room.soundsource),
            % read the intermediate signal, corresponding to 
            INTfile = [microphones_path 'INT_source_' int2str(kk) ...
                                '_node_' int2str(ii) ...
                                '_mic_' int2str(jj) '.wav'];
            [int_signal] = audioread(INTfile); 
            
            % make sure that both signals are the same length
            int_signal(max_length) = 0;
                        
            % ... and add the intermediate signal from source kk
            mic_signal =  mic_signal + int_signal;
        end;
        MICfile = [microphones_path 'Signal_node_' int2str(ii) ...
                                          '_mic_' int2str(jj) '.wav'];
        audiowrite(MICfile, mic_signal, room.fs); 
    end;
end;



end



