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
rng('shuffle', 'v5uniform');

format long

addpath(genpath('../core'));

nDevices        = 16;
nCoordinator    = 1;
nSlots          = 16;
nPackets        = 1;

%% Solar Harvester
nSampleHours            = 60;
sunriseTime             = 7*nSampleHours;
sunsetTime              = 18*nSampleHours;
maxValue                = 1.8874782*10^3;
minValue                = 1.5631218*10^3;
solarPanelEfficiency    = 8;
DCDCefficiency          = 90;


% Parameters
networkType  = '802.15.4';
devicesType  = 'CC2520';

%% Energy Store Device

esdType         = 'ML612S';
startingLevel   = 100;
nominalCapacity = 2.6;
nominalVoltage  = 3;
number          = 1;
connectionType  = 'Single';

t = clock;

network=Network(nDevices, Parameters(devicesType, networkType), TransmissionSystem(0,nPackets), ...
EnergyStoreDevice(esdType, startingLevel, nominalCapacity, nominalVoltage, number, connectionType), ...
SolarHarvester(maxValue, minValue, sunriseTime, sunsetTime, solarPanelEfficiency, DCDCefficiency));

network=network.pushDataAll(nPackets);
      
% network=network.pushTransmissionQueueAllEnergy(mainEvent.currentTime, nPackets);
network=network.pushTransmissionQueueAll(nPackets);

network.transmissionSystems(10).transmissionQueue=0;

%% Printing Data
network.print();

% [deviceRandomSlots, txFrames, frameStatus, successDevices]=FramedSlottedALOHA(network, nSlots)
packets2Transmit=network.packets2Transmit()
[deviceRandomSlots, txFrames, delayDCR, frameStatus, successDevices, network]=network.FSALOHA(nSlots, 0)
packets2Transmit=network.packets2Transmit()

% coordinatorEnergy=network.LastCoordinatorConsumedEnergy()
nodeEnergy=network.LastConsumedEnergyAll()

% [coordinatorEnergy, energyRFD, energyTX, energyRX, energyIDLE]=network.parameters.EnergyEximationCoordinator(nSlots, txFrames)

% [nodeEnergy, energyRFD, energyTX, energyRX, energyIDLE, energySBY, energySLEEP]=network.parameters.EnergyEximationEndDevice(nSlots, deviceRandomSlots)

time = etime(clock,t);
fprintf('Total Elapsed Time: %s\n',timeFormat(time));

clear i t time
