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

classdef Network
    
    %%
    %
    %% EndDevice
    %
    %  Represent a End Device
    %
    %
    %%   Authors: Orazio Briante <orazio.briante@unirc.it>
    %
    %%   Organization: Laboratory A.R.T.S. - University Mediterranea of Reggio Calabria - Faculty of Engineering
    %
    %%   Year:      2013
    %
    %%
    
    properties(GetAccess = 'public', SetAccess = 'public')
        
        %% End Devices
        solarHarvester;              % A SolarHarvester object
        energyStoreDevices;          % a EnergyStoreDevice object
        transmissionSystems;         % The Transmission System
        energyHarvestablePredictors; % The Energy Predictor
        energyConsumptionEstimators;
        delayEstimators;
        parameters;                  % Network and Devices Parameters
        energyControllers;
        
        %% Coordinator
        
        %         CoordinatorESD;       % a EnergyStoreDevice object
        
        
    end
    
    methods
        
        function [numbers]=NumberCoordinator(obj)
            %             numbers=length(obj.CoordinatorESD);
            numbers=1;
        end
        
        function [numbers]=NumberDevices(obj)
            numbers=length(obj.transmissionSystems);
        end
        
        function print(obj, index)
            
            if nargin~=1 && nargin~=2
                error('input parameters are: obj, index.')
            end
            
            if nargin==1
                index=1;
            end
            
            fprintf('Network:\n');
            fprintf('\n');
            fprintf('Number of Devices:\t %i\n', obj.NumberDevices());
            fprintf('Number of Coordinator:\t %i\n', obj.NumberCoordinator());
            fprintf('\n');
            obj.parameters.print();
            fprintf('\n');
            fprintf('[Device %i] Properties:\n', index)
            fprintf('\n');
            obj.solarSource.print();
            obj.solarHarvester(index).print();
            obj.energyStoreDevices(index).print();
            obj.transmissionSystems(index).print();
            fprintf('Energy Harvestable - Prediction:\n');
            obj.energyHarvestablePredictors(index).print();
            fprintf('Energy Consumption - Estimator:\n');
            obj.energyConsumptionEstimators(index).print();
            fprintf('Delay - Estimator:\n');
            obj.delayEstimators(index).print();
            obj.energyControllers(index).print();
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
        function obj=Network(nDevices, parameters, transmissionSystem, energyStoreDevice, solarHarvester, alpha, beta, gamma, maxThr, minThr)
            
            if nargin<1 || nargin > 10
                error('The input arguments are: nDevices, transmissionSystem, energyStoreDevice, solarHarvester, predictorSystem, maxToff');
            end
            
            if nDevices<1
                error('nDevices should be a value >=1');
            end
            
            obj.parameters=Parameters();
            obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, TransmissionSystem());
            obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, EnergyStoreDevice());
            obj.solarHarvester=SolarHarvester();
            obj.energyHarvestablePredictors=PredictorSystem.Array(1,nDevices, PredictorSystem());
            obj.energyConsumptionEstimators=PredictorSystem.Array(1,nDevices, PredictorSystem());
            obj.delayEstimators=PredictorSystem.Array(1,nDevices, PredictorSystem());
            obj.energyControllers=EnergyController.Array(1,nDevices, EnergyController());
            
            %             obj.CoordinatorESD=EnergyStoreDevice();
            
            if nargin==2
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                obj.parameters=parameters.clone();
                
            elseif nargin==3
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                
            elseif nargin==4
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, energyStoreDevice);
                
                %                 obj.CoordinatorESD=energyStoreDevice.clone();
                
            elseif nargin==5
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, energyStoreDevice);
                obj.solarHarvester=solarHarvester.clone();
                
                %                 obj.CoordinatorESD=energyStoreDevice.clone();
                
            elseif nargin==6
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                if alpha<0 || alpha>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, energyStoreDevice);
                obj.solarHarvester=solarHarvester.clone();
                obj.energyHarvestablePredictors=PredictorSystem.Array(1,nDevices, PredictorSystem(alpha));
                
                %                 obj.CoordinatorESD=energyStoreDevice.clone();
                
            elseif nargin==7
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                if alpha<0 || alpha>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if beta<0 || beta>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, energyStoreDevice);
                obj.solarHarvester=solarHarvester.clone();
                obj.energyHarvestablePredictors=PredictorSystem.Array(1,nDevices, PredictorSystem(alpha));
                obj.energyConsumptionEstimators=PredictorSystem.Array(1,nDevices, PredictorSystem(beta));
                
                %                 obj.CoordinatorESD=energyStoreDevice.clone();
                
            elseif nargin==8
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                if alpha<0 || alpha>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if beta<0 || beta>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if gamma<0 || gamma>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, energyStoreDevice);
                obj.solarHarvester=solarHarvester.clone();
                obj.energyHarvestablePredictors=PredictorSystem.Array(1,nDevices, PredictorSystem(alpha));
                obj.energyConsumptionEstimators=PredictorSystem.Array(1,nDevices, PredictorSystem(beta));
                obj.delayEstimators=PredictorSystem.Array(1,nDevices, PredictorSystem(gamma));
                
                %                 obj.CoordinatorESD=energyStoreDevice.clone();
                
            elseif nargin==9
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                if alpha<0 || alpha>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if beta<0 || beta>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if gamma<0 || gamma>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                if maxThr<0
                    error('maxToFF must be a value >=0');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, energyStoreDevice);
                obj.solarHarvester=solarHarvester.clone();
                obj.energyHarvestablePredictors=PredictorSystem.Array(1,nDevices, PredictorSystem(alpha));
                
                obj.energyControllers=EnergyController.Array(1,nDevices, EnergyController(maxThr, 0, (solarHarvester.maxValue+solarHarvester.minValue)/2));
                
                %                 obj.CoordinatorESD=energyStoreDevice.clone();
                
            elseif nargin==10
                
                if ~isa(transmissionSystem, 'TransmissionSystem')
                    error('transmissionSystem should be a TransmissionSystem object');
                end
                
                if ~isa(energyStoreDevice, 'EnergyStoreDevice')
                    error('esd should be a EnergyStoreDevice object');
                end
                
                if ~isa(solarHarvester, 'SolarHarvester')
                    error('solarHarvester should be a SolarHarvester object');
                end
                
                if alpha<0 || alpha>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if beta<0 || beta>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if gamma<0 || gamma>1
                    error('alpha should be a value into the intervall [0,1]');
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be a Parameters object');
                end
                
                if maxThr<0
                    error('maxThr must be a value >=0');
                end
                
                if minThr<0
                    error('minThr must be a value >=0');
                end
                
                obj.parameters=parameters.clone();
                obj.transmissionSystems=TransmissionSystem.Array(1,nDevices, transmissionSystem);
                obj.energyStoreDevices=EnergyStoreDevice.Array(1,nDevices, energyStoreDevice);
                obj.solarHarvester=solarHarvester.clone();
                obj.energyHarvestablePredictors=PredictorSystem.Array(1,nDevices, PredictorSystem(alpha));
                
                obj.energyControllers=EnergyController.Array(1,nDevices, EnergyController(maxThr, minThr, energyStoreDevice, (solarHarvester.maxValue+solarHarvester.minValue)/2));
                
                %                 obj.CoordinatorESD=energyStoreDevice.clone();
                
            end
        end
        
        
        %%
        %% Getters and Setters Sections
        %%
        
        % function obj=set.transmissionSystem(obj, transmissionSystem)
        %     if (~isa(transmissionSystem, 'TransmissionSystem'))
        % error('transmissionSystem should be an object of type TransmissionSystem');
        %     else
        % obj.transmissionSystem=transmissionSystem;
        %     end
        % end
        %
        % function transmissionSystem=get.transmissionSystem(obj)
        %     transmissionSystem=obj.transmissionSystem;
        % end
        %
        % function obj=set.energyStoreDevice(obj, energyStoreDevice)
        %     if (~isa(energyStoreDevice, 'EnergyStoreDevice'))
        % error('energyStoreDevice should be an object of type EnergyStoreDevice');
        %     else
        % obj.energyStoreDevice=energyStoreDevice;
        %     end
        % end
        %
        % function energyStoreDevice=get.energyStoreDevice(obj)
        %     energyStoreDevice=obj.energyStoreDevice;
        % end
        %
        % function obj=set.solarHarvester(obj, solarHarvester)
        %     if (~isa(solarHarvester, 'SolarHarvester'))
        % error('solarHarvester should be an object of type SolarHarvester');
        %     else
        % obj.solarHarvester=solarHarvester;
        %     end
        % end
        %
        % function solarHarvester=get.solarHarvester(obj)
        %     solarHarvester=obj.solarHarvester;
        % end
        %
        % function obj=set.predictorSystem(obj, predictorSystem)
        %     if (~isa(predictorSystem, 'PredictorSystem'))
        % error('predictorSystem should be an object of type PredictorSystem');
        %     else
        % obj.predictorSystem=predictorSystem;
        %     end
        % end
        %
        % function predictorSystem=get.predictorSystem(obj)
        %     predictorSystem=obj.predictorSystem;
        % end
        
    end
    
    methods(Access='public')
        
        function [energies]=LastStoredEnergyAll(obj)
            energies=[ obj.energyStoreDevices.lastStoredEnergy];
        end
        
        function [energies]=LastConsumedEnergyAll(obj)
            energies=[obj.energyStoreDevices.lastConsumedEnergy];
        end
        
        % function [energies]=LastCoordinatorConsumedEnergy(obj)
        %     energies=obj.CoordinatorESD.lastConsumedEnergy;
        % end
        
        function [energies]=LastPredictedEnergyAll(obj)
            energies=[obj.energyHarvestablePredictors.predictedValue];
        end
        
        function [energies]=TotStoredEnergyAll(obj)
            energies=[obj.energyStoreDevices.totStoredEnergy];
        end
        
        % function [energies]=TotCoordinatorConsumedEnergy(obj)
        %     energies=obj.CoordinatorESD.totConsumedEnergy;
        % end
        
        function [energies]=TotConsumedEnergyAll(obj)
            energies=[obj.energyStoreDevices.totConsumedEnergy];
        end
        
        function [energy]=GetCoordinatorEnergy(obj, nSlots, txFrames)
            energy=obj.parameters.EnergyEximationCoordinator(nSlots, txFrames);
        end
        
        
        function [batteryLevels]=GetCurrentEnergyAll(obj)
            batteryLevels=[obj.energyStoreDevices.Ecurrent];
        end
        
        function [percentageLevels]=GetEnergyPercentageAll(obj)
            percentageLevels=zeros(1,obj.NumberDevices());
            
            for i=1:obj.NumberDevices()
                percentageLevels(i)=obj.energyStoreDevices(i).getPercentage();
            end
        end
        
        function [TimeOFF]=GetTimeOFFAll(obj)
            TimeOFF=[obj.energyControllers.timeOFF];
        end
        
        function [wakeUpTime]=wakeUpTime(obj)
            wakeUpTime=[obj.energyControllers.wakeUpTime];
        end
        
        
        function obj=pushDataAll(obj, nPackets)
            
            if nargin==1
                nPackets=1;
            end
            
            for i=1:obj.NumberDevices()
                if obj.energyStoreDevices(i).Ecurrent >0
                    obj.transmissionSystems(i)=obj.transmissionSystems(i).pushData(nPackets);
                end
            end
        end
        
        function obj=pushTransmissionQueueAll(obj, nPackets)
            
            if nargin==1
                nPackets=1;
            end
            
            if nargin >2
                error('input arguments are: obj, nPackets');
            end
            
            for i=1:obj.NumberDevices()
                if obj.energyStoreDevices(i).Ecurrent >0
                    obj.transmissionSystems(i)=obj.transmissionSystems(i).pushTransmissionQueue(nPackets);
                end
            end
        end
        
        
        function obj=pushTransmissionQueueAllEnergy(obj, currentTime, nPackets, batteryPercentage)
            
            if nargin==2
                nPackets=1;
                batteryPercentage=1;
            end
            
            if nargin >4 || nargin <2
                error('input arguments are: obj, currentTime, nPackets, batteryPercentage');
            end
            
            for i=1:obj.NumberDevices()
                if obj.energyStoreDevices(i).getPercentage() > batteryPercentage
                    
                    if obj.energyControllers(i).wakeUpTime <= currentTime
                        obj.transmissionSystems(i)=obj.transmissionSystems(i).pushTransmissionQueue(nPackets);
                    end
                end
            end
        end
        
        function packets2Transmit=packets2Transmit(obj)
            packets2Transmit=arrayfun(@(x) x.transmissionQueue, obj.transmissionSystems);
        end
        
        function obj=Harvest(obj, harvestingTime, sample)
            for i=1:obj.NumberDevices()
                lastHarvestedEnergy=obj.solarHarvester.Harvest(harvestingTime);
                
                if lastHarvestedEnergy > 1e-6
                    obj.energyStoreDevices(i)=obj.energyStoreDevices(i).store(lastHarvestedEnergy*sample);
                else
                    obj.energyStoreDevices(i)=obj.energyStoreDevices(i).store(0);
                end
                
                obj.energyHarvestablePredictors(i)=obj.energyHarvestablePredictors(i).Predict(lastHarvestedEnergy, harvestingTime);
            end
        end
        
        function [deviceRandomSlots, txFrames, delayDCR, frameStatus, successDevices, obj]=FSALOHA(obj, nSlots, currentTime)
            if nSlots < 1
                error('nSlots should be >=1.');
            end
            
            activeDevices=obj.packets2Transmit();
            
            [deviceRandomSlots, txFrames, frameStatus, successDevices]=FramedSlottedALOHA(obj, nSlots);
            
            [delayDCR]=obj.parameters.DCR_TIME(nSlots, txFrames);
            
            [coordinatorEnergy]=obj.parameters.EnergyEximationCoordinator(nSlots, txFrames);
            % obj.CoordinatorESD=obj.CoordinatorESD.consume(coordinatorEnergy);
            
            [nodeEnergy]=obj.parameters.EnergyEximationEndDevice(nSlots, deviceRandomSlots);
            
            for i=1:length(activeDevices)
                if(activeDevices(i)>0)
                    obj.transmissionSystems(i)=obj.transmissionSystems(i).clearTransmissionQueue();
                    
                    % energyWaitingRFD=0;
                    % if obj.energyControllers(i).wakeUpTime < currentTime
                    %     energyWaitingRFD=(currentTime-obj.energyControllers(i).wakeUpTime)*obj.parameters.deviceParameters.P_RADIO_RX;
                    % end
                    
                    % obj.energyStoreDevices(i)=obj.energyStoreDevices(i).consume(energyWaitingRFD+nodeEnergy(i));
                    obj.energyStoreDevices(i)=obj.energyStoreDevices(i).consume(nodeEnergy(i));
                    
                    obj.energyConsumptionEstimators(i)=obj.energyConsumptionEstimators(i).Predict(nodeEnergy(i), currentTime);
                    obj.delayEstimators(i)=obj.delayEstimators(i).Predict(delayDCR, currentTime);
                    
                end
                
                obj.energyControllers(i)=obj.energyControllers(i).EstimateTimeOFF(obj.energyStoreDevices(i), obj.solarHarvester.sunsetTime, ...
                    obj.solarHarvester.sunriseTime, obj.delayEstimators(i).predictedValue, ...
                    obj.energyConsumptionEstimators(i).predictedValue, currentTime);
            end
        end
        
        function endDevice=GetDevice(obj, index)
            
            if nargin==1
                endDevice=EndDevice(obj.transmissionSystems(1), obj.energyStoreDevices(1), obj.solarHarvester, obj.energyHarvestablePredictors(1));
            elseif nargin==2
                endDevice=EndDevice(obj.transmissionSystems(index), obj.energyStoreDevices(index), obj.solarHarvester, obj.energyHarvestablePredictors(index));
            else
                error('input parameters are: obj, index');
            end
            
        end
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'Network'))
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
        function network=FromPrototype(nDevices, prototype, parameters)
            
            if nargin==3
                
                if ~isa(prototype, 'EndDevice')
                    error('prototype should be an EndDevice object')
                end
                
                if ~isa(parameters, 'Parameters')
                    error('parameters should be an Parameters object')
                end
                
                network=Network(nDevices, parameters, prototype.transmissionSystem, prototype.energyStoreDevice, prototype.solarHarvester, prototype.predictorSystem.smootingFactor);
                
            else
                error('input parameters are: nDevices, prototype, parameters');
            end
        end
    end
end
