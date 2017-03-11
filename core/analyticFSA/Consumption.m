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

function [eBurned]= Consumption(devicesParameters, nFrameSlots, timeFBP)
            
            if(nFrameSlots < 0)
                error('nFrameSlots should be >= 0');
            end
            
            activeSlot=ceil(nFrameSlots/2);
            
                
            eBurned = devicesParameters.IFS_ENERGY + devicesParameters.DATA_ENERGY_SBY*(activeSlot-1) + devicesParameters.DATA_ENERGY_TX + devicesParameters.DATA_ENERGY_SLEEP * (nFrameSlots - activeSlot )  + devicesParameters.IFS_ENERGY + timeFBP * devicesParameters.P_RADIO_RX;
                

            
           eBurned = eBurned + devicesParameters.RFD_ENERGY_RX;
end

