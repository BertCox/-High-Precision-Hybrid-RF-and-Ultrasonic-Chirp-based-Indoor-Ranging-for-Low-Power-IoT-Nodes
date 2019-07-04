function [ output_args ] = prepare_sources(room, ref_audio_path, sources_path)
% prepare_sources
% this function prepares a set of audio files, corresponding to the sound
% sources in a room. Each file is made by starting a specific input sound
% file at a predefined time index, as defined in the 'room' input parameter.
%
% v1.1.20150113
%
% H.Brouckxon and W. Verhelst - Vrije Universiteit Brussel

if not(exist(sources_path,'dir'))
    s = mkdir(sources_path);
end;

max_length = 0;
for kk = 1:length(room.soundsource)
    x1 = zeros(room.soundsource(kk).start * room.fs, 1);
    x2 = audioread([ref_audio_path room.soundsource(kk).file]);
    x(kk).wf = [x1 ; x2];
    max_length = max([max_length length(x(kk).wf)]);
end;

for kk = 1:length(room.soundsource)
    x(kk).wf(max_length) = 0;   % same length for all audio files
    audiowrite([sources_path 'source' int2str(kk) '.wav'], x(kk).wf, room.fs);
end;
end

