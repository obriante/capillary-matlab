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


devicesParameters=DevicesParameters('RN-131');
devicesParameters.print();

devicesParametersClone=devicesParameters.clone()

deviceType      =   'CC2520';

devicesParameters=DevicesParameters(deviceType);
devicesParameters.print();

devicesParametersClone=devicesParameters.clone()



P_RADIO_TX      =   100.8E-3;
P_RADIO_RX      =   66.9E-3;
P_RADIO_IDLE    =   P_RADIO_RX;
P_SBY           =   3 * 175E-6;
P_RADIO_SLEEP   =   3*4E-6;


devicesParameters=DevicesParameters(deviceType, P_RADIO_TX, P_RADIO_RX, P_RADIO_IDLE, P_SBY, P_RADIO_SLEEP);
devicesParameters.print();

