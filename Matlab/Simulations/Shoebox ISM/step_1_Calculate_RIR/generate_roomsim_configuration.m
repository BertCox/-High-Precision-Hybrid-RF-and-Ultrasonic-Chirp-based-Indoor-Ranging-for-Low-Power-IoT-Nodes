function generate_roomsim_configuration(textfile, RIRfile, room, microphone, source, fs) 
%% generate_roomsim_configuration.m  Produces the necessary configuration
%                                   file for RoomSim to generate the room
%                                   impulse response from a single given
%                                   source location to a single given
%                                   microphone location. 
%
% use: generate_roomsim_configuration(textfile, room, microphone, source)
%
% parameters:
%      * textfile: name of the textfile in which to write the room
%                  configuration
%      * RIRfile: name of the file in which the room impulse response will
%                 be written
%      * room: room configuration. 
%          -> length: size of the room along the x axis (m)
%          -> width: size of the room along the y axis (m)
%          -> height: size of the room along the z axis (m)
%          -> v: speed of sound
%          -> absorption: room surface absorption parameters (optional)
%                  -> freqs(1..N): frequencies at which the absorption
%                                  parameters are given (in Hz)
%                  -> Ax1(1..N): absorption parameters for the x1 wall
%                                (between 0 and 1)
%                  -> Ax2(1..N): absorption parameters for the x2 wall
%                  -> Ay1(1..N): absorption parameters for the y1 wall
%                  -> Ay2(1..N): absorption parameters for the y2 wall
%                  -> Az1(1..N): absorption parameters for the z1 wall
%                  -> Az2(1..N): absorption parameters for the z2 wall
%      * microphone: configuration of the microphone
%          -> posx: position along the x axis (m)
%          -> posy: position along the y axis (m)
%          -> posz: position along the z axis (m)
%      * source: configuration of the sound source, with the position
%                given in spherical coordinates, relative to the mic. 
%          -> R: distance between microphone and source (m)
%          -> theta:  azimuth relative to the microphone (radians)
%          -> fi: elevation relative to the microphone(radians)
%      * fs: sampling frequency [Hz], integer value
%
% remark: the written configuration text files are based on the
%         "setup_test_cube.txt" example from the roomsim software. 
% ------------------------------------------------------------------------
% version: 3.2007.04.25
% 
% author: ir. H. Brouckxon 
%         Vrije Universiteit Brussel
%         dept ETRO-DSSP
% 
% revision history: 
%      * first version: 2007.01 (H. Brouckxon)
%      * 2007.04: added parameters RIRfile and "room.absorption" 

% if ~isfield(room, 'absorption'),
%     room.absorption.freqs = [125	250     500     1000	2000	4000];  % fixed, do not change !!!
%     room.absorption.Ax1 =   [0.75	0.75	0.75	0.75	0.75	0.75];
%     room.absorption.Ax2 =   [0.75	0.75	0.75	0.75	0.75	0.75];
%     room.absorption.Ay1 =   [0.75	0.75	0.75	0.75	0.75	0.75];
%     room.absorption.Ay2 =   [0.75	0.75	0.75	0.75	0.75	0.75];
%     room.absorption.Az1 =   [0.75	0.75	0.75	0.75	0.75	0.75];
%     room.absorption.Az2 =   [0.75	0.75	0.75	0.75	0.75	0.75];
% end;

% convert speed of sound to an equivalent temperature (needed for roomsim)
temperature = ((room.v/331)^2 - 1)/0.0036;

% open 'textfile' for writing
fid = fopen(textfile,'w');

% Simulation Control Parameters (single value data fields)
fprintf(fid,'Parameter\tValue \r\n');
fprintf(fid,['Fs\t' int2str(fs) '  \r\n']);     % sampling frequency (Hz)
fprintf(fid,'humidity\t40 \r\n');   % Relative humidity of the air (20-70%)
fprintf(fid,['TEMP\t' num2str(temperature) ' \r\n']);       % temperature (deg C)
fprintf(fid,'order\t-1 \r\n');      % limit for the order of reflections computed (determined by roomsim if negative)
fprintf(fid,'H_length\t-1 \r\n');   % impulse response length (set to RT60 length if negative) 
fprintf(fid,['H_filename\t' RIRfile '\r\n']);      % filename for saving the impulse response

% Flags (single value data fields)
fprintf(fid,'air_F\t1 \r\n');       % absorption due to the air is present if 1, no air absoption if 0
fprintf(fid,'dist_F\t1 \r\n');      % 1/R attennuation with distance if 1, no attennuation if 0
fprintf(fid,'Fc_HP\t200 \r\n');       % cut-off frequency (Hz) for high pass filter, no filter if 0
fprintf(fid,'smooth_F\t0 \r\n');    % smoothing filter applied if 1, no smoothing if 0
fprintf(fid,['plot_F2\t0 \r\n']);   % 2D (XY) representation of the room and mirror rooms is plotted if 1, no plot if 0
fprintf(fid,['plot_F3\t0 \r\n']);   % 3D (XYZ)representation of the room and mirror rooms is plotted if 1, no plot if 0
fprintf(fid,['alpha_F\t0 \r\n']);   % if 1, the opacity of the walls in the 3D plot corresponds to their reflectivity. 
                                    % If 0, fixed opacity of the room walls. 

% room size (single value data fields)
fprintf(fid,['Lx\t' num2str(room.length) '\r\n']);    % room length (along x axis)
fprintf(fid,['Ly\t' num2str(room.width) '\r\n']);    % room width (along y axis)
fprintf(fid,['Lz\t' num2str(room.height) '\r\n']);    % room height (along z axis)

% microphone position and type (single value data fields)
fprintf(fid,['xp\t' num2str(microphone.posx) ' \r\n']);    % microphone position (x)
fprintf(fid,['yp\t' num2str(microphone.posy) ' \r\n']);    % microphone position (y)
fprintf(fid,['zp\t' num2str(microphone.posz) ' \r\n']);    % microphone position (z)
fprintf(fid,['Receiver\tone_mic		\r\n']);    % mic type, set to one_mic
fprintf(fid,['sensor_space\t0.145	\r\n']);    % spacing between capsules of a stereo microphone - irrelevant

% head related transfer function parameters (single value data fields - not used)
fprintf(fid,['MIT_root\tMIT_HRTF	\r\n']); % directory for head transfer function (not used)
fprintf(fid,['subdir1\tKemar	\r\n']);     % idem
fprintf(fid,['subdir2\tcompact	\r\n']);     % idem
fprintf(fid,['filename\thrir_final.mat	\r\n']); % filename for HRTF (not used)
fprintf(fid,['CIPIC_root\tCIPIC_HRTF	\r\n']); % idem
fprintf(fid,['subdir1\tstandard_hrir_database\r\n']); % idem
fprintf(fid,['subdir2\tsubject_ \r\n']);         % idem
fprintf(fid,['S_No\t021             \r\n']);
fprintf(fid,['filename\thrir_final.mat		\r\n']);

% microphone orientation (for directional microphones)
fprintf(fid,['receiver_yaw\t0 			\r\n']);
fprintf(fid,['receiver_pitch\t0			\r\n']);
fprintf(fid,['receiver_roll\t0			\r\n']);
fprintf(fid,['%%--------------------------------------------------------------------------\r\n']);

% surface absorption for the walls (six-value data fields = 6 frequencies at which to define the absorption)
fprintf(fid,['	Set the room surface absorptions \r\n']);
fprintf(fid,['F_abs	' num2str(room.absorption.freqs) '	\r\n']);
fprintf(fid,['Ax1	' num2str(room.absorption.Ax1) '	\r\n']);
fprintf(fid,['Ax2	' num2str(room.absorption.Ax2) '	\r\n']);
fprintf(fid,['Ay1	' num2str(room.absorption.Ay1) '	\r\n']);
fprintf(fid,['Ay2	' num2str(room.absorption.Ay2) '	\r\n']);
fprintf(fid,['Az1	' num2str(room.absorption.Az1) '	\r\n']);
fprintf(fid,['Az2	' num2str(room.absorption.Az2) '    \r\n']);
fprintf(fid,['%%--------------------------------------------------------------------------\r\n']);

% directionality info for the microphone (for use within a pair of
% microphones, otherwise use receiver_yaw, receiver_pitch and
% receiver_roll.)
fprintf(fid,['Directionality  Single/Left		Right_(if present)\r\n']);
fprintf(fid,['azim_off	0			0			\r\n']);
fprintf(fid,['elev_off	0			0			\r\n']);
fprintf(fid,['roll_off	0			0			\r\n']);
fprintf(fid,['SENSOR_root	SENSOR			SENSOR \r\n']);
fprintf(fid,['subdir1		Types			Types \r\n']);
fprintf(fid,['filename	omnidirectional.mat null_sensor.mat	\r\n']);
fprintf(fid,['%%--------------------------------------------------------------------------\r\n']);

% position of the source (relative to the microphone)
fprintf(fid,['SOURCES	R_s (m)	alpha (deg)	beta (deg)	\r\n']);
fprintf(fid,['1\t' num2str(source.R) '\t' num2str(source.theta/pi*180) '\t' num2str(source.fi/pi*180)]);
fclose(fid);
        

