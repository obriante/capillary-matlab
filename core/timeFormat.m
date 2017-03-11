%%
% Copyright (c) 2014 Universita' Mediterranea di Reggio Calabria (UNIRC)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License version 2 as
% published by the Free Software Foundation;
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% Author: Orazio Briante <orazio.briante@unirc.it>
%%

function  output = timeFormat( time )
timeD=0;
timeH=0;
timeM=0;
timeS=0;
timem=0;
timeu=0;

output='';

if time >= 3600*24
    timeD=(time-mod(time, (3600*24)))/(3600*24);
    time=mod(time, (3600*24));
    output=sprintf('%s%0.0f [day] ', output, timeD);
end

if time >= 3600
    timeH=(time-mod(time, 3600))/3600;
    
    time=mod(time, 3600);
    output=sprintf('%s%0.0f [hour] ',output, timeH);
end

if time >= 60
    timeM=(time-mod(time, 60))/60;
    
    time=mod(time, 60);
    output=sprintf('%s%0.0f [min] ', output, timeM);
end

if time >= 1
    timeS=time-mod(time, 1);
    
    time=mod(time, 1);
end

if time >= 1E-3
    timem=(time-mod(time, 1E-3))*1E3;
    time=mod(time, 1E-3);
    
end

timeu=time/1E-6;

output=sprintf('%s%0.0f [sec] %0.0f [msec] %0.5f [usec]', output, timeS, timem, timeu);

end

