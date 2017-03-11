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

classdef Parameters
    %ENERGYPARAMETERSFSA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'public')
        
        networkParameters;
        deviceParameters;
        
        RFD_ENERGY_RX;          % Energy spent to recive a RFD
        RFD_ENERGY_TX;          % Energy spent to transmit a RFD
        
        IFS_ENERGY;             % Energy associated to the IFS
        
        DATA_ENERGY_TX;         % Energy spent to transmit a DATA PACKET into a slot
        DATA_ENERGY_RX;         % Energy spent to recive a DATA PACKET into a slot
        
        DATA_ENERGY_IDLE;       % Energy associated to the IDLE TIME
        
        DATA_ENERGY_SLEEP;      % Energy associated to the SLEEP MODE into a slot
        
        DATA_ENERGY_SBY;        % Energy associated to the SBY MODE into a slot
        
    end
    
    methods
        
        
        function obj=Parameters(devicesType, networkType)
            
            if nargin ~= 2 && nargin ~=0
                error('input arguments are: devicesType, networkType')
            elseif nargin ==0
                obj.deviceParameters=DevicesParameters('CC2520');
                obj.networkParameters=NetworkParameters('802.15.4');
            else
                
                if isa(devicesType,'DevicesParameters')
                    obj.deviceParameters=devicesType.clone();
                else
                    obj.deviceParameters=DevicesParameters(devicesType);
                end
                
                if isa(networkType,'NetworkParameters')
                    obj.networkParameters=networkType.clone();
                else
                    obj.networkParameters=NetworkParameters(networkType);
                end
                
            end
            
            obj.RFD_ENERGY_RX = obj.networkParameters.RFD_TIME * obj.deviceParameters.P_RADIO_RX;
            obj.RFD_ENERGY_TX = obj.networkParameters.RFD_TIME * obj.deviceParameters.P_RADIO_TX;
            
            obj.IFS_ENERGY = obj.networkParameters.TIFS * obj.deviceParameters.P_RADIO_IDLE;
            
            obj.DATA_ENERGY_TX = obj.networkParameters.DATA_TIME * obj.deviceParameters.P_RADIO_TX;
            obj.DATA_ENERGY_RX = obj.networkParameters.DATA_TIME * obj.deviceParameters.P_RADIO_RX;
            
            obj.DATA_ENERGY_IDLE = obj.networkParameters.DATA_TIME * obj.deviceParameters.P_RADIO_IDLE;
            
            obj.DATA_ENERGY_SLEEP = obj.networkParameters.DATA_TIME * obj.deviceParameters.P_RADIO_SLEEP;
            
            obj.DATA_ENERGY_SBY = obj.networkParameters.DATA_TIME * obj.deviceParameters.P_SBY;
        end
        
        
        function print(obj)
            
            fprintf('Parameters:\n');
            fprintf('\n');
            fprintf('RFD_ENERGY_RX        : %d [J]\n',obj.RFD_ENERGY_RX);
            fprintf('RFD_ENERGY_TX        : %d [J]\n',obj.RFD_ENERGY_TX);
            fprintf('IFS_ENERGY           : %d [J]\n',obj.IFS_ENERGY);
            fprintf('DATA_ENERGY_TX       : %d [J]\n',obj.DATA_ENERGY_TX);
            fprintf('DATA_ENERGY_RX       : %d [J]\n',obj.DATA_ENERGY_RX);
            fprintf('DATA_ENERGY_IDLE     : %d [J]\n',obj.DATA_ENERGY_IDLE);
            fprintf('DATA_ENERGY_SLEEP    : %d [J]\n',obj.DATA_ENERGY_SLEEP);
            fprintf('DATA_ENERGY_SBY      : %d [J]\n',obj.DATA_ENERGY_SBY);
            fprintf('\n');
            obj.deviceParameters.print();
            obj.networkParameters.print();
        end
        
        %%
        %%
        %%
        
        function [time]=DCR_TIME(obj, nSlots, nFrames)
            if max(size(nSlots))>1
                time=obj.networkParameters.RFD_TIME+sum(obj.networkParameters.SINGLE_FRAME_TIME(nSlots));
            else
                time=obj.networkParameters.RFD_TIME+obj.networkParameters.SINGLE_FRAME_TIME(nSlots)*nFrames;
            end
        end
        
        %%
        %%
        %%
        
        function [energy]=FBP_ENERGY_RX(obj, nSlots)
            
            if nSlots >0
                energy=obj.networkParameters.FBP_TIME(nSlots) * obj.deviceParameters.P_RADIO_RX;
            else
                energy=obj.networkParameters.FBP_HEADER_TIME  * obj.deviceParameters.P_RADIO_RX;
            end
        end
        
        function [energy]=FBP_ENERGY_TX(obj, nSlots)
            if nSlots >0
                energy=obj.networkParameters.FBP_TIME(nSlots) * obj.deviceParameters.P_RADIO_TX;
            else
                energy=obj.networkParameters.FBP_HEADER_TIME  * obj.deviceParameters.P_RADIO_TX;
            end
        end
        
        %%
        %
        %% Compute the Energy Consumption of the Coordinator using FSA
        %
        %% input:
        %           txFrames: the number of Frame FSA.
        %% output:
        %           coordinatorEnergy: the energy consumption in J.
        %
        %%
        function [coordinatorEnergy, energyRFD, energyTX, energyRX, energyIDLE]=EnergyEximationCoordinator(obj, nSlots, txFrames)
            
            if nargin~=3
                error('input argument: obj, nSlots, txFrames.');
            end
            
            if(txFrames < 1)
                error('totFrames should be > 0.');
            end
            
            if isvector(nSlots) >1 && length(nSlots) < txFrames
                error('nSlots length < txFrames.');
            elseif(nSlots < 1)
                error('nSlots should be > 0.');
            end
            
            if length(nSlots)==1
                nSlots=nSlots*ones(1,txFrames);
            end
            
            energyRFD  = obj.RFD_ENERGY_TX;
            energyIDLE = obj.IFS_ENERGY * 2 * ones(1,txFrames);
            energyRX   = obj.DATA_ENERGY_RX * nSlots;
            energyTX   = obj.FBP_ENERGY_TX(nSlots);
            
            coordinatorEnergy=energyRFD+sum(energyIDLE)+sum(energyRX)+sum(energyTX);
        end
        
        %%
        %
        %%  Compute the energy consumption, using FSA, for every End-Device into the network
        %
        %%  input:
        %           activeSlots: an array where activeSlots(i) is the random slot selected by the device "i" to transmit into the current FSA Frame;
        %
        %% output:
        %           nodeEnergy: an array where nodeEnergy(i) is the energy consumption of the node "i".
        %
        %%
        function [nodeEnergy, energyRFD, energyTX, energyRX, energyIDLE, energySBY, energySLEEP]= EnergyEximationEndDevice(obj, nSlots, activeSlots)
            
            if nargin~=3
                error('input argument: obj, nSlots, activeSlots.')
            end
            
            s=size(activeSlots);
            nDevices=s(2);
            txFrames=s(1);

            if(max(max(activeSlots))>0)
                
                if isvector(nSlots) >1 && length(nSlots) < txFrames
                    error('nSlots length < txFrames.');
                elseif(nSlots < 1)
                    error('nSlots should be > 0.');
                end
                
                if length(nSlots)==1
                    nSlots=nSlots*ones(size(activeSlots));
                else
                    nSlots=repmat(nSlots,nDevices,1)';
                end
                
                if max(activeSlots>nSlots)
                    error('activeSlots > nSlots');
                end
                
                energyRFD  = obj.RFD_ENERGY_RX .* (activeSlots(1,:)>0);
                energyRX   = obj.FBP_ENERGY_RX(nSlots) .* (activeSlots>0);
                energyIDLE = obj.IFS_ENERGY * (activeSlots>0)*2;
                energyTX   = obj.DATA_ENERGY_TX * (activeSlots>0);
                energySBY  = obj.DATA_ENERGY_SBY * ((activeSlots-1).*(activeSlots>0));
                energySLEEP= obj.DATA_ENERGY_SLEEP *((nSlots-activeSlots).*(activeSlots>0));
                % energySLEEP= obj.networkParameters.SINGLE_FRAME_TIME(nSlots)*obj.deviceParameters.P_RADIO_SLEEP .* (activeSlots==0) + energySLEEP;
                
                nodeEnergy=energyRFD+sum(energyTX)+sum(energyRX)+sum(energyIDLE)+sum(energySBY)+sum(energySLEEP);
            else
                energyRFD   = zeros(1,nDevices);
                energyRX    = zeros(1,nDevices);
                energyIDLE  = zeros(1,nDevices);
                energyTX    = zeros(1,nDevices);
                energySBY   = zeros(1,nDevices);
                % energySLEEP = obj.DATA_ENERGY_SLEEP * obj.DCR_TIME(nSlots, txFrames);
                energySLEEP = zeros(1,nDevices);
                nodeEnergy=energyRFD+sum(energyTX)+sum(energyRX)+sum(energyIDLE)+sum(energySBY)+sum(energySLEEP);
            end
            
        end
        
        %%
        %
        %%  Compute the energy consumption, using FSA, for every End-Device into the network
        %
        %%  input:
        %           activeSlots: an array where activeSlots(i) is the random slot selected by the device "i" to transmit into the current FSA Frame;
        %
        %% output:
        %           nodeEnergy: an array where nodeEnergy(i) is the energy consumption of the node "i".
        %
        %%
        function [nodeEnergy, energyRFD, energyTX, energyRX, energyIDLE, energySBY, energySLEEP]= EnergyEximationEndDeviceForceFBP(obj, nSlots, activeSlots)
            
            if nargin~=3
                error('input argument: obj, nSlots, activeSlots.')
            end
            
            s=size(activeSlots);
            nDevices=s(2);
            txFrames=s(1);
            
            
            
            if isvector(nSlots) >1 && length(nSlots) < txFrames
                error('nSlots length < txFrames.');
            elseif(nSlots < 1)
                error('nSlots should be > 0.');
            end
            
            if length(nSlots)==1
                nSlots=nSlots*ones(size(activeSlots));
            else
                nSlots=repmat(nSlots,nDevices,1)';
            end
            
            if max(activeSlots>nSlots)
                error('activeSlots > nSlots');
            end
            
            energyRFD  = obj.RFD_ENERGY_RX * ones(1,nDevices);
            energyRX   = obj.FBP_ENERGY_RX(nSlots);
            energyIDLE = obj.IFS_ENERGY * (activeSlots>0)*2;
            energyTX   = obj.DATA_ENERGY_TX * (activeSlots>0);
            energySBY  = obj.DATA_ENERGY_SBY * ((activeSlots-1).*(activeSlots>0));
            energySLEEP= obj.DATA_ENERGY_SLEEP *((nSlots-activeSlots).*(activeSlots>0));
            energySLEEP= ((2*obj.networkParameters.TIFS) + nSlots * obj.networkParameters.DATA_TIME)*obj.deviceParameters.P_RADIO_SLEEP .* (activeSlots==0) + energySLEEP;
            
            nodeEnergy=energyRFD+sum(energyTX)+sum(energyRX)+sum(energyIDLE)+sum(energySBY)+sum(energySLEEP);
            
        end
        
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'Parameters'))
                obj=0;
            else
                fns = properties(obj);
                for i=1:length(fns)
                    obj.(fns{i}) = obj.(fns{i});
                end
            end
            
        end
        
    end
    
    methods(Static)
        %%
        %
        %% This method create a (m x n) matrix where obj(i,j) is an object of this class
        %
        %% input:
        %         m: number of rows
        %         n: number of columns
        %         proto: is an optional prototype object. (optional)
        %
        %% output:
        %         obj: the matrix
        %
        %%
        function [obj] = Array(m, n, proto)
            
            if nargin==3
                if ~isa(proto,'Parameters')
                    error('proto should be a Parameters object')
                end
                
                obj(m,n) = proto.clone(); % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        obj(i,j) = proto.clone();
                    end
                end
                
            else
                error('input arguments are: m,n, proto')
            end
        end
    end
end

