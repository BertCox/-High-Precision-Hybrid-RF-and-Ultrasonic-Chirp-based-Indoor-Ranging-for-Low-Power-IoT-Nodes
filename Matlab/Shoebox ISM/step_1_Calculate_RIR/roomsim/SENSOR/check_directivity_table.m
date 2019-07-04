%Check a sensor directivity pattern
% This script reads a directivity cell array and plots
% The directivity pattern using polar plots.
% The pattern can be displayed with an angular offset from the sensor axis.
%----------------------------------------------------------------------------- 
% 
% Copyright (C) 2003  Douglas R Campbell
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program in the MATLAB file roomsim_licence.m ; if not,
%  write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%-----------------------------------------------------------------------------------
%Functions called:

clear all;
deg2rad=pi/180;

repeat=true;
while repeat,
    repeat=false; % Do once if correct filename and ext given
    beep;
    [name path] = uigetfile('sensor_directivity.mat', 'Get a sensor directivity data file'); %Display the dialogue box
    if ~any(name), 
        return; % **Alternate return for cancel operation. No data read from file.
    end;
    filename = [path name]; % Form full filename as path+name
    [pathstr,name,ext,versn] = fileparts(filename);
    if ~strcmpi(lower(ext),'.mat'),
        h=errordlg('You must specify a .mat extension ','Error in check_sensitivity');
        beep;
        uiwait(h);
        repeat=true;
    end;
end; % of while loop to trap non .mat files

load(filename, 'S3D');
SS3D=cell2mat(S3D);
%--------------------------------------------

for elev=-90:90, % All possible source elevations
    e_index=elev+91;
    for azim = -180:180, % All possible source azimuths
        a_index=azim+181;
        imp_read(e_index,a_index)=max(SS3D(e_index,a_index,:)); % Extract directivity data for display
    end;
end;
figure(1);
x=[-180:180]; y=[-90:90];
imagesc(x,y,imp_read); % Display the sensor directivity matrix in sensor axes
title('Sensor directivity in sensor axes');
xlabel('Azimuth (deg)');
ylabel('Elevation (deg)');
%-------------------------------------------

out_of_range = true;
while out_of_range, %Loop if sensor offset data is not sensible
    answer={};
    while isempty(answer),
        banner = 'Sensor Directional Offsets (Default is zero degrees)';
        prompt = {'Enter -180< azimuth offset <180 deg:'...
                ,'Enter -90< elevation offset <90 deg:'...
                ,'Enter -180< roll offset <180 deg:'};
        lines = 1;
        def = {'0','0','0'}; %Default values for x axis look direction
        beep;
        answer = inputdlg(prompt,banner,lines,def);
    end; % of while loop to disable inappropriate CANCEL button operation
    azim_off=str2num(answer{1});
    elev_off=str2num(answer{2});
    roll_off=str2num(answer{3});
    
    % Check values within range
    if elev_off < -90 || elev_off > 90,
        message='-90< Sensor elevation offset <90 deg';
    else,
        out_of_range = false; % Input accepted
    end;
    
    if azim_off < -180 || azim_off > 180,
        message='-180< Sensor azimuth offset <180 deg';
    else,
        out_of_range = false; % Input accepted
    end;
    
    if roll_off < -180 || roll_off > 180,
        message='-180< Sensor roll offset <180 deg';
    else,
        out_of_range = false; % Input accepted
    end;
    
    if out_of_range  
        banner='Re-enter value';
        h=msgbox(message,banner,'warn');  %Warn & beep.
        beep;
        uiwait(h);% Wait for user to acknowledge
        answer={};
    end;
end;

roll=0; % Fix roll angle at zero degrees
for elev=-90:90, % All possible source elevations in one degree steps
    e_index=elev+91;
    
    for azim=-180:180, % All possible source azimuths in one degree steps
        a_index=azim+181;
        
        [az, el]=room2sensor(azim,azim_off,elev,elev_off,roll,roll_off);
        elevation=round(el);
        azimuth=round(az);
        imp_resp(e_index,a_index)=max(abs(SS3D(elevation+91,azimuth+181,:)));
        
    end;   
end;

x=[-180:180]; y=[-90:90];
figure(2);
imagesc(x,y,imp_resp); % Display the sensor directivity matrix in room axes
title('Visible locations');
xlabel('Azimuth (deg)');
ylabel('Elevation (deg)');


for elev=-90:90,
    e_index=elev+91;
    beta(e_index)=elev.*deg2rad;
    for azim = -180:180,
        a_index=azim+181;
        alpha(a_index)=azim.*deg2rad;
        imp_value(e_index,a_index)=imp_resp(e_index,a_index,:);
    end;
end;

elev=elev_off; %Sensor elevation offset from room axis system
azim=azim_off; %Sensor azimuth offset from room axis system

figure(3);
subplot(2,1,1);
polar(alpha,imp_value(elev+91,round(alpha.*180/pi+181)),'r');
title('Azimuth');

subplot(2,1,2);
polar(beta',imp_resp(round(beta.*180/pi+91),azim+181),'r');
title('Elevation');
