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

classdef EnergyController
    %ENERGYCONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'public')
        
        wakeUpTime;
        
        timeOFF;
        maxToFF;
        
        energyPrevDay;
        
        thrMax;
        thrMin;
        EthrMin;
        
    end
    
    methods
        
        function print(obj)
            fprintf('EnergyController:\n');
            fprintf('\n');
            fprintf('OFF Time            :\t %0.4f\n', obj.timeOFF);
            fprintf('Wake Up Time        :\t %0.4f\n', obj.wakeUpTime);
            fprintf('Max Threshold       :\t %0.4f\n', obj.thrMax);
            fprintf('Min Threshold       :\t %0.4f\n', obj.thrMin);
            fprintf('Energy Previous Day :\t %0.4f\n', obj.energyPrevDay);
            fprintf('\n');
        end
        
        function obj=EnergyController(thrMax, thrMin, energyStoreDevice, energyPrevDay)
            
            if nargin>4 || nargin ==2 || nargin==3
                error('parameters are: thrMax, thrMin, energyStoreDevice, energyPrevDay');
            end
            
            obj.wakeUpTime    = 0;
            obj.timeOFF       = 0;
            obj.maxToFF       = 0;
            obj.energyPrevDay = 0;
            
            obj.thrMax        = 100;
            obj.thrMin        = 0;
            obj.EthrMin       = 0;
            
            if nargin==1
                obj.thrMax    = thrMax;
            elseif nargin==4
                obj.thrMax    = thrMax;
                obj.thrMin    = thrMin;
                obj.energyPrevDay = energyPrevDay;
                obj.EthrMin   = max(energyStoreDevice.Percentage2Joule(obj.thrMin), (energyStoreDevice.Percentage2Joule(obj.thrMax)-(1/2*obj.energyPrevDay)));
            end
            
        end
        
        function obj=EstimateTimeOFF(obj, energyStoreDevice, sunsetTime, sunriseTime, avgDelayDCR, avgNodeEnergy, currentTime)
            
            if nargin == 7
                if currentTime >= obj.wakeUpTime
                    
                    sunriseTimeNextDay = sunriseTime + (24*3600);
                    sunsetTimeNextDay  = sunsetTime  + (24*3600);
                    
                    if currentTime>sunriseTimeNextDay && currentTime<sunsetTimeNextDay
                        
                        if energyStoreDevice.getPercentage() >= obj.thrMax
                            
                            nDCR=(sunsetTimeNextDay-currentTime)/avgDelayDCR;
                            
                        elseif energyStoreDevice.getPercentage() > obj.thrMin && energyStoreDevice.getPercentage() < obj.thrMax
                            
                            Econsumable=obj.energyPrevDay-energyStoreDevice.totStoredEnergy;
                            
                            if Econsumable>0
                                nDCR=(energyStoreDevice.Ecurrent+Econsumable-energyStoreDevice.Percentage2Joule(obj.thrMax))/avgDelayDCR;
                            else
                                nDCR=0;
                            end
                            
                        else
                            nDCR=0;
                        end
                        
                        if nDCR<=0
                            obj.timeOFF=obj.maxToFF;
                        else
                            obj.timeOFF = ((sunsetTimeNextDay-currentTime)/nDCR)-avgDelayDCR;
                        end
                        
                        if obj.timeOFF < 0 || isnan(obj.timeOFF)
                            obj.timeOFF=0;
                        end
                        
                        if obj.timeOFF > obj.maxToFF
                            obj.timeOFF= obj.maxToFF;
                        end
                        
                    else
                        
                        if energyStoreDevice.Ecurrent > obj.EthrMin
                            nDCR=(energyStoreDevice.Ecurrent-obj.EthrMin)/avgNodeEnergy;
                            
                            if nDCR<=0
                                obj.timeOFF=obj.maxToFF;
                            else
                                obj.timeOFF=((sunriseTimeNextDay-currentTime)/nDCR)-avgDelayDCR;
                            end
                            
                            if obj.timeOFF>obj.maxToFF
                                obj.maxToFF=obj.timeOFF;
                            end
                            
                        else
                            obj.timeOFF=(sunriseTimeNextDay-currentTime)-avgDelayDCR;
                        end
                        
                        if obj.timeOFF < 0 || isnan(obj.timeOFF)
                            obj.timeOFF=0;
                        end
                        
                    end
                    
                    obj.wakeUpTime = currentTime + avgDelayDCR + obj.timeOFF;
                end
                
            else
                error('obj, energyStoreDevice, sunsetTime, sunriseTime, avgDelayDCR, avgNodeEnergy, currentTime');
            end
        end
        
        function obj=clone(obj)
            if (~isa(obj, 'EnergyController'))
                obj=EnergyController();
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
                    if ~isa(proto,'EnergyController')
                        error('proto should be a EnergyController object')
                    end
                end
                
                obj(m,n) = EnergyController; % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        
                        if nargin==2
                            obj(i,j) = EnergyController();
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
