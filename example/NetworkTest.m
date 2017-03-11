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
close all;
format('long');

addpath(genpath('../core'));

nDevices        = 300;
nPackets        = 1;

%% Solar Harvester
nSampleHours            = 3600;
sunriseTime             = 7*nSampleHours;
sunsetTime              = 18*nSampleHours;
maxValue                = 1.8874782*10^3;
minValue                = 1.5631218*10^3;
solarPanelEfficiency    = 8;
DCDCefficiency          = 90;


%% Parameters
networkType  = '802.11g';
devicesType  = 'RN-131';

%% Prediction
alpha = 0.89;
beta  = 0.50;
gamma = 0.50;

%% Energy Store Device
esdType         = 'ML612S';
startingLevel   = 100;
nominalCapacity = 2.6;
nominalVoltage  = 3;
number          = 1;
connectionType  = 'Single';

energyConsumption=3;

network=Network(nDevices, Parameters(devicesType, networkType), TransmissionSystem(0, nPackets), ...
    EnergyStoreDevice(esdType, startingLevel, nominalCapacity, nominalVoltage, number, connectionType), ...
    SolarHarvester(maxValue, minValue, sunriseTime, sunsetTime, solarPanelEfficiency, DCDCefficiency), alpha, beta, gamma);

%% Printing Data
network.print();

endDevice1=network.GetDevice();
endDevice1.print();

network2=Network.FromPrototype(nDevices, network.GetDevice(nDevices), Parameters(devicesType, networkType));
network2.print();

network.packets2Transmit()
network.LastStoredEnergyAll()
network.LastConsumedEnergyAll()
network.LastPredictedEnergyAll()
network.TotConsumedEnergyAll()
network.NumberDevices()
network.NumberCoordinator()
network.GetCurrentEnergyAll()

network=network.Harvest(0, 0);
network.LastStoredEnergyAll()

network=network.Harvest(8*3600,1);
network.LastStoredEnergyAll()

network=network.Harvest(24*3600,1);
network.LastStoredEnergyAll()

network=network.Harvest((24+8)*3600,1);
network.LastStoredEnergyAll()

network.TotStoredEnergyAll()
