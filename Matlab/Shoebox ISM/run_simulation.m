function run_simulation(room_nbr, mode)
%RUN_SIMULATION 
% parameters:
%   -> room_nbr: number of the room configuration. This will select a room
%                configuration from the available options in the working
%                path (this path can be defined at the beginning of this
%                m-file). 
%   -> mode: processing mode, determines what processing steps will be
%            applied. Possible values:
%               * 'full': complete simulation (RIR + SIM). Requires a
%                         room configuration XML file, and the
%                         corresponding .wav input audio files.
%               * 'RIR': calculate the room impulse responses. Only
%                         requires the room configuration XML file.
%               * 'SIM': generate the signals, picked up by the
%                         microphones, based on a set of Room Impulse
%                         Respose files from a previous 'full' or 'RIR'
%                         run.
%
% v1.1.20150113
%
% H.Brouckxon and W. Verhelst - Vrije Universiteit Brussel
plots = 0;

current_path = pwd();

%% define the paths where the configuration/input/output files are located
cd('..');
work_path = [pwd() '\room' int2str(room_nbr) '\']; % working path, will contain the room
                  % configuration files and all calculated/processed files 
ref_audio_path = [pwd() '\input_audio\'];% path containing the original  
                  % input audio files that are used to make the room's
                  % sound sources 

cd(current_path);
% additional paths (no manual configuration required)                  
config_path = [work_path 'config\'];% contains the XML room configuration  
                  % file 'room_config.XML'                     
RIR_path = [work_path 'RIR\']; % used to save the room impulse responses
sources_path = [work_path 'sources\']; % used to save the sources' audio
microphones_path = [work_path 'microphones\']; % used to save the 
                  % microphone audio
                    
                    
%% read the room configuration XML file
room = import_room(config_path, 'room_config.xml');
cd(current_path);

%% calculate the room impulse responses
if (strcmpi(mode,'full') || strcmpi(mode,'RIR'))
    cd('.\step_1_Calculate_RIR\');
    roomsim_array(room, RIR_path, plots);
    cd(current_path);
end;

%% prepare the soundfiles for the sound sources
if (strcmpi(mode,'full') || strcmpi(mode,'SIM'))
    cd('.\step_2_Apply_RIR\');
    prepare_sources(room, ref_audio_path, sources_path);
    cd(current_path);
end;

%% generate the microphone audio signals using the RIR and sources files.
if (strcmpi(mode,'full') || strcmpi(mode,'SIM'))
    cd('.\step_2_Apply_RIR\');
    ApplyRoom(room, RIR_path, sources_path, microphones_path);
    cd(current_path);
end;

draw_room(config_path, 'room_config.xml');
end

