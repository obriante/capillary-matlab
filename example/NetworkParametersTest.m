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

nSlots              =   1;


networkType         =   '802.11g';

networkParameters=NetworkParameters(networkType);
networkParameters.print();

FBP_TIME=networkParameters.FBP_TIME(nSlots)
SINGLE_FRAME_TIME=networkParameters.SINGLE_FRAME_TIME(nSlots)

networkParametersClone=networkParameters.clone()


networkType         =   '802.15.4';
CRC                 =   2*8;
MAC_HEADER          =   8*8;
RFD_HEADER          =   0;
FBP_HEADER          =   0;
FBP_SLOT_PAYLOAD    =   2;
DATA_PAYLOAD        =   8;
MAX_DATA_PAYLOAD    =   104*8;
RATE                =   250E3;
TIFS                =   192E-6;
T_PREAMBLE          =   160E-6;

networkParameters=NetworkParameters(networkType, CRC, MAC_HEADER, RFD_HEADER, FBP_HEADER, FBP_SLOT_PAYLOAD, MAX_DATA_PAYLOAD, DATA_PAYLOAD, RATE, TIFS, T_PREAMBLE);
networkParameters.print();

FBP_TIME=networkParameters.FBP_TIME(nSlots)
SINGLE_FRAME_TIME=networkParameters.SINGLE_FRAME_TIME(nSlots)

networkParametersClone=networkParameters.clone()
