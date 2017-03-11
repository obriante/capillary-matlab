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

clc;
clear all;

addpath(genpath('../core'));

prototype=EndDevices(1, TransmissionSystem(1,5), EnergyStoreDevice('Test', 50, 1, 1, 1, 'Single'), SolarHarvester());
prototype.print();
fprintf('\n\n');
% input('Press any Button to Continue');
% clc;

prototype=prototype.Store(0.2);
prototype=prototype.PredictAvailability();
prototype.print();
fprintf('\n\n');
% input('Press any Button to Continue');
% clc;

prototype=prototype.Store(0.3);
prototype=prototype.PredictAvailability();
prototype.print();
fprintf('\n\n');
% input('Press any Button to Continue');
% clc;

prototype=prototype.Consume(0.1);
prototype.print();
