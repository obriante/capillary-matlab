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

classdef TransmissionSystem
    %TRANSMISSIONSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'public')
        dataQueue=0;                    % The Queue of Datas readed from the Sensor
        transmissionQueue=0;                      % The Transmission Queue of the Datas ready to be transmitted
    end
    
    methods
        function print(obj)
            fprintf('TransmissionSystem:\n');
            fprintf('\n');
            fprintf('Packets into the Data Queue:              %d\n',obj.dataQueue);
            fprintf('Packets into the Transmission Queue:      %d\n',obj.transmissionQueue);
            fprintf('\n');
        end
        
        function obj=TransmissionSystem(dataQueue, transmissionQueue)
            if nargin==0
                obj.dataQueue=0;
                obj.transmissionQueue=0;
            elseif nargin==1
                obj.dataQueue=dataQueue;
                obj.transmissionQueue=0;
            elseif nargin==2
                obj.dataQueue=dataQueue;
                obj.transmissionQueue=transmissionQueue;
            else
            end
        end
        
        %%
        %% Getters and Setters Sections
        %%
        
        function obj=set.dataQueue(obj, dataQueue)
            if dataQueue < 0
                obj.dataQueue=0;
            else
                obj.dataQueue=dataQueue;
            end
        end
        
        function dataQueue=get.dataQueue(obj)
            dataQueue=obj.dataQueue;
        end
        
        function obj=set.transmissionQueue(obj, transmissionQueue)
            if transmissionQueue < 0
                obj.transmissionQueue=0;
            else
                obj.transmissionQueue=transmissionQueue;
            end
        end
        
        function transmissionQueue=get.transmissionQueue(obj)
            transmissionQueue=obj.transmissionQueue;
        end
        
        
        function obj=clearTransmissionQueue(obj)
            obj.transmissionQueue=0;
        end
        
        %%
        %
        %% pop a data from the Transmission Queue
        %
        %% input:
        %       Eburned: the energy consumed for the operation
        %
        %%
        function obj=popTransmissionQueue(obj, value)
            if nargin==1
                value=1;
            elseif nargin==2
                
                if value < 0
                    error('value must be >0')
                end
            else
                error ('input parameter are: value')
            end
            obj.transmissionQueue=obj.transmissionQueue-value;
        end
        
        function obj=dropTransmissionQueue(obj, value)
            obj=obj.popTransmissionQueue(value);
        end
        
        %%
        %
        %% push a data into the Transmission Queue
        %
        %%
        function obj=pushTransmissionQueue(obj, value)
            if nargin==1
                value=1;
            elseif nargin==2
                
                if value < 0
                    error('value must be >0')
                end
            else
                error ('input parameter are: value')
            end
            
            if(obj.dataQueue >0)
                
                if(value > obj.dataQueue)
                obj.transmissionQueue=obj.transmissionQueue+obj.dataQueue;    
                obj=obj.clearData();
                else
                obj=obj.popData(value);
                obj.transmissionQueue=obj.transmissionQueue+value;
                end
            end
        end
        
        
        function obj=clearData(obj)
            obj.dataQueue=0;
        end
        
        %%
        %
        %% pop a data from the Data Queue
        %
        %%
        function obj=popData(obj, value)
            
            if nargin==1
                value=1;
            elseif nargin==2
                
                if value < 0
                    error('value must be >0')
                end
            else
                error ('input parameter are: value')
            end
            
            if(obj.dataQueue >0)
                obj.dataQueue=obj.dataQueue-value;
            end
        end

        function obj=dropDataQueue(obj, value)
            obj=obj.popData(value);
        end
        
        %%
        %
        %% push a data into the Data QueuepostTransmission
        %
        %%
        function obj=pushData(obj, value)
            
            if nargin==1
                value=1;
            elseif nargin==2
                
                if value < 0
                    error('value must be >0')
                end
            else
                error ('input parameter are: value')
            end
            
            obj.dataQueue=obj.dataQueue+value;
        end
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'TransmissionSystem'))
                obj=TransmissionSystem();
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
                    if ~isa(proto,'TransmissionSystem')
                        error('proto should be a TransmissionSystem object')
                    end
                end
                
                obj(m,n) = TransmissionSystem; % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        
                        if nargin==2
                            obj(i,j) = TransmissionSystem();
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

