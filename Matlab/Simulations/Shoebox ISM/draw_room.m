function [] = draw_room( configuration_path,infile )
% draw_room - draws a 3D plot of the microphone positions in the room
%   Plots the positions of the individual microphones and sound sources in  
%   the room.
%   Microphones (red) are identified by a double number "i.j", where 
%   i indicatesthe node number, and j indicates the number of the  
%   microphone within the node 
%   Sound sources (green) are identified by a single number
%
% v1.1.20150113
%
% H.Brouckxon and W. Verhelst - Vrije Universiteit Brussel



room = import_room(configuration_path,infile);

figure;
hold on;
% draw the room outline
x = [0 room.length room.length 0          0 0           room.length room.length 0           0           room.length room.length room.length room.length 0           0           ];
y = [0 0           room.width  room.width 0 0           0           room.width  room.width  0           0           0           room.width  room.width  room.width  room.width  ];
z = [0 0           0           0          0 room.height room.height room.height room.height room.height room.height 0           0           room.height room.height 0           ];
plot3(x, y, z);
% draw the microphones
for ii = 1:length(room.node)
    for jj = 1:length(room.node(ii).mic)
        x = [room.node(ii).mic(jj).posx];
        y = [room.node(ii).mic(jj).posy];
        z = [room.node(ii).mic(jj).posz];
        plot3(x, y, z,'ro');
        text(x+0.01,y,z, [int2str(ii) '.' int2str(jj)], 'Color', 'r');
    end;
end;
% draw the sound sources
for ii = 1:length(room.soundsource)
     x = [room.soundsource(ii).posx];
     y = [room.soundsource(ii).posy];
     z = [room.soundsource(ii).posz];
     plot3(x, y, z,'go');
     text(x,y,z, [int2str(ii)], 'Color', 'g');
end;
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
hold off;

axis equal;
