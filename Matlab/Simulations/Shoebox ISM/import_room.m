function [room] = import_room(configuration_path,infile)
% import_room(infile) - reads a room configuration from the XML file 'infile'
%
% input:
%   -> infile: name of the input XML file, containing the room configuration
%
% output: 
%   -> room: struct, containing the read room configuration parameters
%
% v1.1.20150113
%
% H.Brouckxon and W. Verhelst - Vrije Universiteit Brussel

%% some default values
room_v_default = 340; % default speed of sound (m/s) if undefined in XML
room_fs_default = 32000; % default sampling rate (Hz) if undefined in XML



%% read the input XML file
room_xml = xml2struct([configuration_path infile]);
room_xml = room_xml.room(1);

room.absorption.freqs = [125    250     500     1000	2000	4000];  % fixed, do not change !!!

%% read general simulation parameters
    % absorbtion material
if isfield(room_xml,'absorptionmaterial')
    if (length(room_xml.absorptionmaterial) == 1)
        room.absorption.Ax1 = getAbsTableTxtType(room_xml.absorptionmaterial.back.Text);
        room.absorption.Ax2 = getAbsTableTxtType(room_xml.absorptionmaterial.front.Text);
        room.absorption.Ay1 = getAbsTableTxtType(room_xml.absorptionmaterial.left.Text);
        room.absorption.Ay2 = getAbsTableTxtType(room_xml.absorptionmaterial.right.Text);
        room.absorption.Az1 = getAbsTableTxtType(room_xml.absorptionmaterial.floor.Text);
        room.absorption.Az2 = getAbsTableTxtType(room_xml.absorptionmaterial.ceiling.Text);
    else
        error('Multiple references to absorbtion material in xml file...');
    end;
else
    warning(['No absorption material defined in XML file, set to default (acoustic_tile_suspended)']);
    
    room.absorption.Ax1 =   [0.9	0.9     0.9     0.9     0.9     0.9];
    room.absorption.Ax2 =   [0.9	0.9     0.9     0.9     0.9     0.9];
    room.absorption.Ay1 =   [0.9	0.9     0.9     0.9     0.9     0.9];
    room.absorption.Ay2 =   [0.9	0.9     0.9     0.9     0.9     0.9];
    room.absorption.Az1 =   [0.9	0.9     0.9     0.9     0.9     0.9];
    room.absorption.Az2 =   [0.9	0.9     0.9     0.9     0.9     0.9];
end;
%0.5	0.7     0.6     0.7     0.7     0.5
%0.1    0.05	0.06	0.07	0.09	0.08
%0.99	0.99     0.99     0.99     0.99     0.99
%0.1	0.1     0.1     0.1     0.1     0.1
%0.01	0.01     0.01     0.01     0.01     0.01
%0.25	0.25     0.25     0.25     0.25     0.25
%0.5	0.5     0.5     0.5     0.5     0.5


%0.75	0.75     0.75     0.75     0.75     0.75
    % speed of sound v
if isfield(room_xml,'v')
    if (length(room_xml.v) == 1)
        room.v = str2num(room_xml.v.Text); %#ok<*ST2NM>
    elseif (length(room_xml.v) > 1)
        error('Multiple references to speed of sound (v) in xml file...');
    else
        room.v = room_v_default;
        warning(['No speed of sound (v) defined in XML file, set to default (' ...
                 num2str(room.v) ' m/s)']);
    end;
else
    room.v = room_v_default;
    warning(['No speed of sound (v) defined in XML file, set to default (' ...
             num2str(room.v) ' m/s)']);
end;

    % sampling frequency fs
if isfield(room_xml,'fs')
    if (length(room_xml.fs) == 1)
        room.fs = str2num(room_xml.fs.Text); 
    elseif (length(room_xml.fs) > 1)
        error('Multiple references to sampling rate (fs) in xml file...');
    else
        room.fs = room_fs_default;
        warning(['No sampling rate (fs) defined in XML file, set to default (' ...
                 num2str(room.fs) ' Hz)']);
    end;
else
    room.fs = room_fs_default;
    warning(['No sampling rate (fs) defined in XML file, set to default (' ...
              num2str(room.fs) ' Hz)']);
end;


%% read room dimensions
room.length = str2num(room_xml.length.Text); 
room.width  = str2num(room_xml.width.Text);
room.height = str2num(room_xml.height.Text);

%% read properties of the sound sources
    % location
if (length(room_xml.soundsource) == 1)
    room.soundsource.posx = str2num(room_xml.soundsource.posx.Text);
    room.soundsource.posy = str2num(room_xml.soundsource.posy.Text);
    room.soundsource.posz = str2num(room_xml.soundsource.posz.Text);
    room.soundsource.file = room_xml.soundsource.file.Text;
    room.soundsource.start = str2num(room_xml.soundsource.start.Text);
else
    for ii = 1:length(room_xml.soundsource)
        room.soundsource(ii).posx = str2num(room_xml.soundsource{ii}.posx.Text);
        room.soundsource(ii).posy = str2num(room_xml.soundsource{ii}.posy.Text);
        room.soundsource(ii).posz = str2num(room_xml.soundsource{ii}.posz.Text);    
        room.soundsource(ii).file = room_xml.soundsource{ii}.file.Text;
        room.soundsource(ii).start = str2num(room_xml.soundsource{ii}.start.Text);
    end;
end;

%% read properties of the microphone nodes
if not(isfield(room_xml,'node'))
    error('no microphone node (''node'') defined')
end;    
if (length(room_xml.node) == 1)
% node type
   room.node.type = room_xml.node.type.Text;
% location
   room.node.posx = str2num(room_xml.node.posx.Text);
   room.node.posy = str2num(room_xml.node.posy.Text);
   room.node.posz = str2num(room_xml.node.posz.Text);
% rotation
   if isfield(room_xml.node,'rotateXY')
       room.node.rotateXY = str2num(room_xml.node.rotateXY.Text);
   else
       room.node.rotateXY = 0;
   end;  
else 
   for ii = 1:length(room_xml.node)
% node type
        room.node(ii).type = room_xml.node{ii}.type.Text;
% location
        room.node(ii).posx = str2num(room_xml.node{ii}.posx.Text);
        room.node(ii).posy = str2num(room_xml.node{ii}.posy.Text);
        room.node(ii).posz = str2num(room_xml.node{ii}.posz.Text);    

% rotation
        if isfield(room_xml.node{ii},'rotateXY')
            room.node(ii).rotateXY = str2num(room_xml.node{ii}.rotateXY.Text);
        else
            room.node(ii).rotateXY = 0;
        end;  
    end;
end;

%% expand the microphone node into its separate microphones
for ii = 1:length(room.node)
    node_xml = xml2struct([configuration_path 'Nodes/' room.node(ii).type '.xml']);
    node_xml = node_xml.node(1);
    if (length(node_xml.mic) == 1)
        % read microphone position within node
        x_tmp = str2num(node_xml.mic.posx.Text);
        y_tmp = str2num(node_xml.mic.posy.Text);
        z_tmp = str2num(node_xml.mic.posz.Text);
        % rotate position over rotateXY degrees in XY plane around node
        % center
        [theta_tmp,rho_tmp] = cart2pol(x_tmp,y_tmp);
        rho_tmp = rho_tmp + (room.node(ii).rotateXY * pi/180);
        [x_tmp, y_tmp] = pol2cart(theta_tmp,rho_tmp);
        % calculate actual microphone position
        room.node(ii).mic.posx = room.node(ii).posx + x_tmp;
        room.node(ii).mic.posy = room.node(ii).posy + y_tmp;
        room.node(ii).mic.posz = room.node(ii).posz + z_tmp;
        clear x_tmp y_tmp z_tmp theta_tmp rho_tmp;
    else
        for jj = 1:length(node_xml.mic)
            % read microphone position within node
            x_tmp = str2num(node_xml.mic{jj}.posx.Text);
            y_tmp = str2num(node_xml.mic{jj}.posy.Text);
            z_tmp = str2num(node_xml.mic{jj}.posz.Text);
            % rotate position over rotateXY degrees in XY plane around node
            % center
            [theta_tmp,rho_tmp] = cart2pol(x_tmp,y_tmp);
            theta_tmp = theta_tmp + (room.node(ii).rotateXY * pi/180);
            [x_tmp, y_tmp] = pol2cart(theta_tmp,rho_tmp);
            % calculate actual microphone position            
            room.node(ii).mic(jj).posx = room.node(ii).posx + x_tmp;
            room.node(ii).mic(jj).posy = room.node(ii).posy + y_tmp;
            room.node(ii).mic(jj).posz = room.node(ii).posz + z_tmp; 
            clear x_tmp y_tmp z_tmp theta_tmp rho_tmp;
        end;
    end;
end;
    