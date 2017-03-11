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

addpath(genpath('../core'));

disp(timeFormat( 1E-9 ));
disp(timeFormat( 1E-6+1E-9 ));
disp(timeFormat( 1E-3+1E-6+1E-9 ));
disp(timeFormat( 1+1E-3+1E-6+1E-9 ));
disp(timeFormat( 60+1+1E-3+1E-6+1E-9 ));
disp(timeFormat( 3600+60+1+1E-3+1E-6+1E-9 ));
disp(timeFormat( 3600*24+3600+60+1+1E-3+1E-6+1E-9 ));
