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

classdef EnergyStoreDevice
    %%
    %
    %% EnergyStoreDevice
    %
    % Represent a Non-Ideal Energy Buffer
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
        type;
        nominalCapacity;    % Nominal capacity (mAh)
        nominalVoltage;     % Nominal Voltage (V)
        startingLevel;      % Percentage of initial battery status
        number;             % Number of ESD
        connectionType;     % Single - Series - Parallel
        Emax;               % Max Energy level
        Emin;               % Min Energy Level
        Ecurrent;           % Current Energy Level
        
        
        lastStoredEnergy   = 0;
        lastConsumedEnergy = 0;
        
        totStoredEnergy    = 0;
        totConsumedEnergy  = 0;
    end
    
    methods
        
        function print(obj)
            fprintf('Energy Store Device:\n');
            fprintf('\n');
            fprintf('Type:                     %s\n', obj.type);
            fprintf('Nominal Capacity:         %0.9f [mAh]\n', obj.nominalCapacity);
            fprintf('Nominal Voltage:          %0.2f [V]\n', obj.nominalVoltage);
            fprintf('Starting Level:           %0.0f%s\n', obj.startingLevel, '%');
            fprintf('Number of ESD:            %d\n', obj.number);
            fprintf('Connection Type:          %s\n', obj.connectionType);
            fprintf('\n');
            fprintf('Emax:                     %0.10e [J]\n', obj.Emax);
            fprintf('Emin:                     %0.10e [J]\n', obj.Emin);
            fprintf('Ecurrent:                 %0.10e [J]\n', obj.Ecurrent);
            fprintf('\n');
            fprintf('Last Harvested Energy:    %0.10e [J]\n', obj.lastStoredEnergy);
            fprintf('Last Energy Consumption:  %0.10e [J]\n', obj.lastConsumedEnergy);
            fprintf('\n');
            fprintf('Tot Harvested Energy:     %0.10e [J]\n', obj.totStoredEnergy);
            fprintf('Tot Energy Consumption:   %0.10e [J]\n', obj.totConsumedEnergy);
            fprintf('\n');
        end
        
        
        %%
        %
        %% Class Constructor
        %
        % input: (optional)
        %       type: supported type: 'ML612S' (or define your type using the others)
        %       nominalCapacity:
        %       nominalVoltage:
        %       startingLevel: percentage of initial battery status (default: 100% )
        %
        %%
        function obj=EnergyStoreDevice(type, startingLevel, nominalCapacity, nominalVoltage, number, connectionType)
            
            if nargin==0
                obj.type='None';
                obj.nominalCapacity=0;
                obj.nominalVoltage=0;
                obj.startingLevel=0;
                obj.number=1;
                obj.connectionType='Single';
            elseif nargin==6
                
                if startingLevel < 0 || startingLevel > 100
                    error('0 =< startingLevel =< 100  ');
                end
                
                if number < 1
                    error('number should be >= 1');
                elseif number==1 && ~strcmp(connectionType, 'Single')
                    error('number == 1, the connectionTyoe should be: Single')
                elseif number >1
                    validString={ 'Parallel', 'Series' };
                    validatestring(connectionType, validString);
                end
                
                if ~isnumeric(type)
                    obj.type=type;
                    obj.nominalCapacity=nominalCapacity;
                    obj.nominalVoltage=nominalVoltage;
                    obj.startingLevel=startingLevel;
                    obj.number=number;
                    obj.connectionType=connectionType;
                else
                    error('Use EnergyStoreDevice(type, startingLevel, nominalCapacity, nominalVoltage, number, connectionType)');
                end
                
                
            else
                error(' The input arguments are: type, startingLevel, nominalCapacity, nominalVoltage, number, connectionType');
            end
            
            
            Wh=0;
            
            if obj.number==1
                Wh = obj.nominalCapacity * obj.nominalVoltage / 1000; % Watt H
            else
                if strcmp(obj.connectionType,'Series')
                    Wh = obj.nominalCapacity * (obj.nominalVoltage*obj.number) / 1000;
                elseif strcmp(obj.connectionType,'Parallel')
                    Wh = (obj.nominalCapacity * obj.number) * obj.nominalVoltage / 1000;
                end
            end
            
            obj.Emax=Wh*3600;
            obj.Emin=0;
            obj.Ecurrent=obj.Emax*obj.startingLevel/100;
            
        end
        
        %%
        %% Getters and Setters Sections
        %%
        
        function obj=set.Emax(obj, Emax)
            if (Emax < obj.Emin)
                error('Emax should be >= Emin');
            else
                obj.Emax=Emax;
            end
        end
        
        function EMax=get.Emax(obj)
            EMax=obj.Emax;
        end
        
        function obj=set.Emin(obj, Emin)
            if(Emin > obj.Emax)
                error('Emin should be <= Emax');
            else
                obj.Emin=Emin;
            end
        end
        
        function EMin=get.Emin(obj)
            EMin=obj.Emin;
        end
        
        function obj=set.Ecurrent(obj, Ecurrent)
            
            if(Ecurrent > obj.Emax)
                
                obj.Ecurrent=obj.Emax;
                
            elseif (Ecurrent < obj.Emin)
                
                obj.Ecurrent=obj.Emin;
                
            else
                obj.Ecurrent=Ecurrent;
                
            end
            
        end
        
        function ECurrent=getEcurrent(obj)
            ECurrent=obj.Ecurrent;
        end
        
        
        function percentage=getPercentage(obj)
            percentage=(obj.Ecurrent.*100)./obj.Emax;
        end
        
        function joule=Percentage2Joule(obj, percentage)
            Wh=0;            
            if obj.number==1
                Wh = obj.nominalCapacity * obj.nominalVoltage / 1000; % Watt H
            else
                if strcmp(obj.connectionType,'Series')
                    Wh = obj.nominalCapacity * (obj.nominalVoltage*obj.number) / 1000;
                elseif strcmp(obj.connectionType,'Parallel')
                    Wh = (obj.nominalCapacity * obj.number) * obj.nominalVoltage / 1000;
                end
            end
            
            joule=Wh*3600*percentage/100;
        end
        
        %%
        %
        %% Store an amount of energy into the Energy Buffer
        %
        %   input:
        %       E2Store: The Energy that must be stored
        %
        %%
        function obj=store(obj, energy)
            
            if(nargin==2)
                if (energy >=0 )
                    
                    obj.Ecurrent= obj.Ecurrent + energy;
                    obj.lastStoredEnergy=energy;
                    obj.totStoredEnergy=obj.totStoredEnergy+obj.lastStoredEnergy;
                end
            else
                error('input arguments are: obj, energy');
            end
            
        end
        
        %%
        %
        %%  Represent the energy consumption from the Energy Buffer
        %
        %   input:
        %       Econsume: The Energy that must be consumed
        %
        %%
        function obj=consume(obj, energy)
            
            if(nargin==2)
                if (energy >=0 )
                    
                    obj.Ecurrent= obj.Ecurrent - energy;
                    
                    obj.lastConsumedEnergy=energy;
                    obj.totConsumedEnergy=obj.totConsumedEnergy+obj.lastConsumedEnergy;
                end
            else
                error('input arguments are: obj, energy');
            end
            
        end
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'EnergyStoreDevice'))
                obj=EnergyStoreDevice();
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
                    if ~isa(proto,'EnergyStoreDevice')
                        error('proto should be a EnergyStoreDevice object')
                    end
                end
                
                obj(m,n) = EnergyStoreDevice; % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        
                        if nargin==2
                            obj(i,j) = EnergyStoreDevice();
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
