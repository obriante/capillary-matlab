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

classdef EndDevice
    
    %%
    %
    %% EndDevice
    %
    % Represent a End Device of the Network
    %
    %
    %%   Authors: Orazio Briante <orazio.briante@unirc.it>, Anna Maria Mandalari <anna.mandalari.647@studenti.unirc.it>
    %
    %%   Organization: Laboratory A.R.T.S. - University Mediterranea of Reggio Calabria - Faculty of Engineering
    %
    %%   Year:      2013
    %
    %%
    
    properties(GetAccess = 'public', SetAccess = 'public')
        solarHarvester;                 % A SolarHarvester object
        energyStoreDevice;              % a EnergyStoreDevice object
        transmissionSystem;             % The Transmission System
        predictorSystem;                % The Energy Predictor
        
        lastStoredEnergy=0;
        lastEnergyConsumption=0;
        
        totStoredEnergy=0;
        totEnergyConsumption=0;
        
    end
    
    methods
        
        
        function print(obj)
            fprintf('End Device:\n');
            fprintf('\n');
            
            obj.solarHarvester.print();
            obj.energyStoreDevice.print();
            obj.transmissionSystem.print();
            obj.predictorSystem.print();
            
            fprintf('Last Harvested Energy:                    %d [J]\n',obj.lastStoredEnergy);
            fprintf('Last Energy Consumption:                  %d [J]\n',obj.lastEnergyConsumption);
            fprintf('\n');
            
            fprintf('Tot Harvested Energy:                    %d [J]\n',obj.totStoredEnergy);
            fprintf('Tot Energy Consumption:                  %d [J]\n',obj.totEnergyConsumption);
            fprintf('\n');
        end
        
        %%
        %
        %% Class Constructor
        %
        %% input: (optional)
        %       esd: a EnergyStoreDevice object
        %       energyController: a energyController object
        %       sensor: a Sensor object
        %       solarHarvester: a SolarHarvester Object
        %%
        function obj=EndDevice(transmissionSystem, energyStoreDevice, solarHarvester, predictorSystem)
            
            if nargin==0
                
                obj.transmissionSystem=TransmissionSystem();
                obj.energyStoreDevice=EnergyStoreDevice();
                obj.solarHarvester=SolarHarvester();
                obj.predictorSystem=PredictorSystem();
                
            elseif nargin==1
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                obj.transmissionSystem=transmissionSystem.clone();
                obj.energyStoreDevice=EnergyStoreDevice();
                obj.solarHarvester=SolarHarvester();
                obj.predictorSystem=PredictorSystem();
                
            elseif nargin==2
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                obj.transmissionSystem=transmissionSystem.clone();
                obj.energyStoreDevice=energyStoreDevice.clone();
                obj.solarHarvester=SolarHarvester();
                obj.predictorSystem=PredictorSystem();
                
                
            elseif nargin==3
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                obj.transmissionSystem=transmissionSystem.clone();
                obj.energyStoreDevice=energyStoreDevice.clone();
                obj.solarHarvester=solarHarvester.clone();
                obj.predictorSystem=PredictorSystem();
                
            elseif nargin==4
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                if ~isa(predictorSystem, 'PredictorSystem')
                    error('predictorSystem should be a PredictorSystem object');
                end
                
                obj.transmissionSystem=transmissionSystem.clone();
                obj.energyStoreDevice=energyStoreDevice.clone();
                obj.solarHarvester=solarHarvester.clone();
                obj.predictorSystem=predictorSystem.clone();
            end
        end
        
        
        %%
        %% Getters and Setters Sections
        %%
        
        function obj=set.transmissionSystem(obj, transmissionSystem)
            if (~isa(transmissionSystem, 'TransmissionSystem'))
                error('transmissionSystem should be an object of type TransmissionSystem');
            else
                obj.transmissionSystem=transmissionSystem;
            end
        end
        
        function transmissionSystem=get.transmissionSystem(obj)
            transmissionSystem=obj.transmissionSystem;
        end
        
        function obj=set.energyStoreDevice(obj, energyStoreDevice)
            if (~isa(energyStoreDevice, 'EnergyStoreDevice'))
                error('energyStoreDevice should be an object of type EnergyStoreDevice');
            else
                obj.energyStoreDevice=energyStoreDevice;
            end
        end
        
        function energyStoreDevice=get.energyStoreDevice(obj)
            energyStoreDevice=obj.energyStoreDevice;
        end
        
        function obj=set.solarHarvester(obj, solarHarvester)
            if (~isa(solarHarvester, 'SolarHarvester'))
                error('solarHarvester should be an object of type SolarHarvester');
            else
                obj.solarHarvester=solarHarvester;
            end
        end
        
        function solarHarvester=get.solarHarvester(obj)
            solarHarvester=obj.solarHarvester;
        end
        
        function obj=set.predictorSystem(obj, predictorSystem)
            if (~isa(predictorSystem, 'PredictorSystem'))
                error('predictorSystem should be an object of type PredictorSystem');
            else
                obj.predictorSystem=predictorSystem;
            end
        end
        
        function predictorSystem=get.predictorSystem(obj)
            predictorSystem=obj.predictorSystem;
        end
        
    end
    
    methods(Access='public')
        
        function obj=Store(obj, energy)
            obj.lastStoredEnergy=energy;
            obj.energyStoreDevice=obj.energyStoreDevice.store(obj.lastStoredEnergy);
            obj.totStoredEnergy=obj.totStoredEnergy+obj.lastStoredEnergy;
        end
        
        function obj=Consume(obj, energy)
            
            if(nargin==2)
                obj.lastEnergyConsumption=energy;
                obj.energyStoreDevice=obj.energyStoreDevice.consume(energy);
                obj.totEnergyConsumption=obj.totEnergyConsumption+obj.lastEnergyConsumption;
            else
                error('input arguments are: obj, energy');
            end
        end
        
        function obj=PredictAvailability(obj)
            if(nargin==1)
                obj.predictorSystem=obj.predictorSystem.Predict(obj.lastStoredEnergy);
            else
                error('input arguments are: obj');
            end
        end
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'EndDevice'))
                obj=EndDevice();
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
            
            if nargin == 2 || nargin == 3 % Allow nargin
                
                if nargin==3
                    if ~isa(proto,'EndDevice')
                        error('proto should be a EndDevice object')
                    end
                end
                
                obj(m,n) = EndDevice; % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        
                        if nargin==2
                            obj(i,j) = EndDevice();
                        else
                            obj(i,j) = proto.clone();
                        end
                        
                        
                    end
                end
                
            else
                error('input arguments are: m,n, proto')
            end
        end
    end
end
