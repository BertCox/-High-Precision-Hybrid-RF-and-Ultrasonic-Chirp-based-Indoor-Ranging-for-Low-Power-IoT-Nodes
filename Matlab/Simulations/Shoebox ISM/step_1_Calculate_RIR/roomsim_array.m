function roomsim_array(room, RIR_path, plots)
%% roomsim_array.m
%   This program uses the "roomsim" algorithms to calculate the impulse 
%   response between multiple sources and multiple microphone 
%   clusters (nodes) in a given shoebox-shaped room. 
%   input parameters: 
%       -> room: structure, containing the configuration parameters of the
%                room that will be simulated (dimensions, positions of
%                sources and microphones,...). Use import_room.m to
%                generate this struct from an XML file.
%       -> output_path: path where the results should be saved (only use
%                       full path names, not relative paths!) 
%               * .txt files containing the roomsim configurations are  
%                 written in subfolder \txt\ in the output_path
%               * .mat files containing the impulse responses are written
%                 in a subfolder \RIR\ in the output_path 
%
% -----------------------------------------------------------
% version 4.2015.01.13
% 
% author: ir. H. Brouckxon, Vrije Universiteit Brussel, dept ETRO-DSSP
%
% Revision History:
%     2007.01.20: First version (H. Brouckxon)

if not(exist(RIR_path,'dir'))
    s = mkdir(RIR_path);
end;
txt_path = [RIR_path 'txt\'];
if not(exist(txt_path,'dir'))
    s = mkdir(txt_path);
end;

for kk = 1:length(room.soundsource),
    for ii = 1:length(room.node),
        for jj = 1:length(room.node(ii).mic),
            
            mic = room.node(ii).mic(jj);
            source = room.soundsource(kk);
            % *********************************************
            % * transform the source location(s) to polar *
            % * coordinates relative to the microphone(s) *
            % *********************************************
        
            % carthesian coordinates of source jj, relative to microphone ii
            posU = source.posx - mic.posx;
            posV = source.posy - mic.posy;
            posW = source.posz - mic.posz;
            % transform carthesian coordinates to polar coordinates
            [theta, fi, R] = cart2sph(posU,posV,posW);
            source.rel_to_mic.R = R;
            source.rel_to_mic.theta = theta;
            source.rel_to_mic.fi = fi;
            
            % ***********************************************
            % * Generate the text input file that describes *
            % * the acoustic enviromnent for roomsim        *
            % ***********************************************
            
            textfile = [txt_path 'configuration_source_' int2str(kk) ...
                '_node_' int2str(ii) ...
                '_mic_' int2str(jj) '.txt'];
            RIRfile = ['RIR_source_' int2str(kk) ...
                '_node_' int2str(ii) ...
                '_mic_' int2str(jj)];
            
            generate_roomsim_configuration(textfile, RIRfile, room, ...
                mic, source.rel_to_mic, room.fs);
            
            % *************************************************
            % * Run RoomSim based on the above configuration  *
            % * to determine the appropriate impulse response *
            % *************************************************
            
            roomsim_run(textfile, plots);
            
            copyfile(['.\RIR\' RIRfile '.mat'], [RIR_path RIRfile '.mat']);
            delete(['.\RIR\' RIRfile '.mat']);
            disp(['finished source ' int2str(kk) ' -> mic (' int2str(ii) ',' int2str(jj) ').']);
            close all;
            fclose('all');
        end;
    end
end;
end

