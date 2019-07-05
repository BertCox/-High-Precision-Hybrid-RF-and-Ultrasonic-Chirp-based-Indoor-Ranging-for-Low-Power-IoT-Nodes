function drawRoom3D(room, source, microphone)
%
% draws a 3D representation of a room with microphones and sound sources.
% The main walls adjacent to the origin [0 0 0] are shown as grey surfaces,
% indicating the room size. Microphones are shown as blue-green spheres and
% sound sources as red spheres. Microphones and sound sources are also
% numbered as in the room description.
% 
%  parameters:
%   * room: room dimensions along the carthesian axes in meter 
%       -> size_x
%       -> size_y
%       -> size_z
%   * source(ii): position of the sound sources (e.g. microphones and
%                 loudspeakers) (expressed in carthesian coordinates in
%                 meter)
%       -> pos_x
%       -> pos_y
%       -> pos_z
%   * microphone(ii): position of the microphones (expressed in carthesian 
%                     coordinates in meter)
%       -> pos_x
%       -> pos_y
%       -> pos_z% 
%  -----------------------------------------------------------
%  version 1.2007.05.03
%  
%  author: ir. H. Brouckxon
%          Vrije Universiteit Brussel 
%          dept ETRO-DSSP
% 
%  Revision History:
%      2007.05.03: First version (H. Brouckxon)

n_microphones = length(microphone);
n_sources = length(source);

[S_x,S_y,S_z] = sphere(5); % coordinates on a sphere surface (radius 1)

Display.figure = figure();
hold on;

% ********************************
% * draw the basic room contours *
% ********************************
% XY surface
Wx = [ 0 room.size_x
       0 room.size_x];
Wy = [ 0 0
      room.size_y  room.size_y];
Wz = [ 0  0
       0  0];
C = 0 * Wz + 0; % surface color 0
Display.Wall(1) = surf(Wx, Wy, Wz, C);

% XZ surface
Wx = [ 0 room.size_x
       0 room.size_x];
Wy = [ 0 0
      0  0];
Wz = [ 0  0
       room.size_z  room.size_z];
C = 0 * Wz + 0; % surface color 0
Display.Wall(2) = surf(Wx, Wy, Wz, C);

% YZ surface
Wx = [ 0 0
       0 0];
Wy = [ 0 room.size_y
      0  room.size_y];
Wz = [ 0  0
       room.size_z  room.size_z];
C = 0 * Wz + 0; % surface color 0
Display.Wall(2) = surf(Wx, Wy, Wz, C);


% ************************
% * draw the microphones *
% ************************

SphereSize = 0.03;

for ii = 1:n_microphones,
    Sx = (SphereSize * S_x) + microphone(ii).pos_x;
    Sy = (SphereSize * S_y) + microphone(ii).pos_y;
    Sz = (SphereSize * S_z) + microphone(ii).pos_z;
    C = (0*Sz)+ 1; % surface color 1
    Display.microphone(ii) = surf(Sx, Sy, Sz, C);
    text(microphone(ii).pos_x, microphone(ii).pos_y, (microphone(ii).pos_z+SphereSize+0.03), int2str(ii))
end;

% **************************
% * draw the sound sources *
% **************************

SphereSize = 0.03;

for jj = 1:n_sources,
    Sx = (SphereSize * S_x) + source(jj).pos_x;
    Sy = (SphereSize * S_y) + source(jj).pos_y;
    Sz = (SphereSize * S_z) + source(jj).pos_z;
    C = (0*Sz) + 2; % surface color 2
    Display.source(ii) = surf(Sx, Sy, Sz, C);
    text(source(jj).pos_x, source(jj).pos_y, (source(jj).pos_z+SphereSize+0.03), int2str(jj))
end;

% set the colormap (0=grey; 1=green-blue; 2=red)
colormap([0.9  0.9  0.9; 0  1  1; 1 0 0]);

hold off;