function roomsim_welcome;
%Usage: roomsim_welcome;   This presents the welcome notice and 
% responds to acceptance of the copyright conditions.
%
% Copyright (C) 2003  Douglas R Campbell
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
%
% Functions called:

%------ Welcome Screen -----------------
welcome=strvcat(...
    '   Copyright (C) February 2004 Douglas R. Campbell & Kalle J. Palomaki'...
    ,' '...
    ,'          Roomsim comes with ABSOLUTELY NO WARRANTY;'... 
    ,'for COPYRIGHT details choose Roomsim Licence from the main menu.'...
    ,' '...
    ,'This is free software, and you are welcome to redistribute it'...
    ,'under the licence conditions with the following EXCEPTION:'...
    ,'Anyone wishing to redistribute the CIPIC or MIT Media Lab data'...
    ,'other than in this program should first obtain their permission.'...
    ,' '...
    ,'The authors gratefully acknowledge permission to include the HRTF data'...
    ,'from the copyright holders at: '...
    ,'1) Center for Image Processing and Integrated Computing (CIPIC),'...
    ,' University of California, Davis. (http://interface.cipic.ucdavis.edu)'...
    ,'2) MIT Media Laboratory, Massachusetts. (http://sound.media.mit.edu)'...
    ,' '...
    ,'Any publication incorporating results or materials arising from use of'...
    ,'this program should separately acknowledge the CIPIC and/or MIT sources'...
    ,'as appropriate, in addition to the authors of this program.'...
    ,' '...
    ,'        Enquiries by email to:    d.r.campbell@paisley.ac.uk'...
    );
PROMPTstring='Welcome to ROOMSIM, a simulation of "shoebox" room acoustics.';
OKstring='I accept these conditions';
CANCELstring='Quit';
[dummy,OK]=listdlg('PromptString',PROMPTstring,'SelectionMode','single','ListSize',[500 400]...
    ,'ListString',welcome,'OKstring',CANCELstring,'CancelString',OKstring);
beep;
if OK == 1, % OK button or double click detected in window, thus conditions not explicitly accepted, so quit
    quit;
end;
%---------------------- End of roomsim_welcome.m ----------------
