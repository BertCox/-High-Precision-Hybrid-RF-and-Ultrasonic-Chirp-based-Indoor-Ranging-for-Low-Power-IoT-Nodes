%% common.m  Defines the "global" variables, necessary for roomsim
% 
% ------------------------------------------------------------------------
% version: 3.2007.04.25
% 
% author: ir. H. Brouckxon, Vrije Universiteit Brussel, dept ETRO-DSSP
% 
% revision history: 
%      * first version: 2007.01 (H. Brouckxon)
%      * 2007.04: added parameters RIRfile and "room.absorption" 

global deg2rad; % Conversion factor degrees to radians. 
global rad2deg; % Conversion factor radians to degrees. 

global LOG_FID; % Identifier of logfile. 
global MACHINE  % Users machine identifier
global MAXSIZE; % largest number of elements allowed in an array on this machine
global FIG_LOC; % Location for plots

global SPEED_FACTOR;  % To be used for estimating roomsim_core.m execution time
global CONV_FACTOR;   % To be used for estimating convolution times for routines using conv.m (not in use)
global CONV_FACTOR_2; % To be used for estimating convolution times for roomsim_convolve.m, roomsim_cocktail.m

global H_filename; % filename for saving the impulse response 
                   % (value given in roomsim_run.m)

deg2rad=pi/180; % Conversion factor degrees to radians
rad2deg=180/pi; % and radians to degrees

LOG_FID =fopen('Roomsim.log','at'); % Open a new logfile for writing text and get an identifier
[MACHINE,MAXSIZE]=computer;
FIG_LEFT=100; % Set the left and bottom reference coordinates for the figure plots
FIG_BOTTOM=100;
FIG_LOC=[FIG_LEFT FIG_BOTTOM 450 350]; % Location for plots

