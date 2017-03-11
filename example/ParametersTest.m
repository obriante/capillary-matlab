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

format long;

addpath(genpath('../core'));

networkTypeA = '802.11g';
deviceTypeA  = 'RN-131';

networkTypeB = '802.15.4';
deviceTypeB  = 'CC2520';

nSlots = 15;

parameters=Parameters(deviceTypeA, networkTypeA);
parameters.print();

activeSlots=randi(nSlots, 1,5)
nodeEnergy= parameters.EnergyEximationEndDevice(nSlots, activeSlots)

coordinatorEnergy=parameters.EnergyEximationCoordinator(5, 5)

parameters=Parameters(deviceTypeB,networkTypeB);
parameters.print();

coordinatorEnergy=parameters.EnergyEximationCoordinator(5,5)

activeSlots=randi(nSlots, 3,5)

%activeSlots=[0, 7, 10, 15, 2; 0, 7, 10, 15, 2; 0, 7, 10, 15, 2; ];

[nodeEnergy, energyRFD, energyTX, energyRX, energyIDLE, energySBY, energySLEEP]= parameters.EnergyEximationEndDevice(nSlots, activeSlots)
