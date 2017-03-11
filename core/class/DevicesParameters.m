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

classdef DevicesParameters
    %%
    %% DevicesParameters
    %
    %    Devices Parameters
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
        
        deviceType;
        
        P_RADIO_TX;             % transmission power
        P_RADIO_RX;             % reception power
        P_RADIO_IDLE;           % idle power
        P_SBY;                  % standby power consumption
        P_RADIO_SLEEP;          % (standby mode) Remaining connected to the Access Point, in Power-Save mode
        
        
    end
    
    methods
        
        function print(obj)
            fprintf('Devices Parameters:\n');
            fprintf('\n');
            fprintf('Device Type          : %s\n',obj.deviceType);
            fprintf('TX Power             : %d [W]\n',obj.P_RADIO_TX);
            fprintf('RX Power             : %d [W]\n',obj.P_RADIO_RX);
            fprintf('IDLE Power           : %d [W]\n',obj.P_RADIO_IDLE);
            fprintf('Standby Power        : %d [W]\n',obj.P_SBY);
            fprintf('SLEEP Power          : %d [W]\n',obj.P_RADIO_SLEEP);
            fprintf('\n');
        end
        
        
        %%
        %
        %% Class Constructor
        %
        %% input:
        %           deviceType: supported devices: 'RN-131', 'CC2520'
        %
        %           networkParameters: a NetworkParameters object
        %%
        function obj=DevicesParameters(deviceType, P_RADIO_TX, P_RADIO_RX, P_RADIO_IDLE, P_SBY, P_RADIO_SLEEP)
            if nargin ==1
                
                if strcmp(deviceType, 'RN-131')
                    
                    obj.deviceType      =   'RN-131';
                    obj.P_RADIO_TX      =   3 * 210E-3;
                    obj.P_RADIO_RX      =   3 * 40E-3;
                    obj.P_RADIO_IDLE    =   obj.P_RADIO_RX;
                    obj.P_SBY           =   3*15E-3;
                    obj.P_RADIO_SLEEP   =   3 * 0.03E-6;
                    
                    
                elseif strcmp(deviceType, 'CC2520')
                    
                    obj.deviceType      =   'CC2520';
                    obj.P_RADIO_TX      =   100.8E-3;
                    obj.P_RADIO_RX      =   66.9E-3;
                    obj.P_RADIO_IDLE    =   obj.P_RADIO_RX;
                    obj.P_SBY           =   3 * 175E-6;
                    obj.P_RADIO_SLEEP   =   3*4E-6;
                    
                end
                
            elseif nargin ==6
                
                obj.deviceType      =  deviceType;
                obj.P_RADIO_TX      =  P_RADIO_TX;
                obj.P_RADIO_RX      =  P_RADIO_RX;
                obj.P_RADIO_IDLE    =  P_RADIO_IDLE;
                obj.P_SBY           =  P_SBY;
                obj.P_RADIO_SLEEP   =  P_RADIO_SLEEP;
            else
                error('input arguments are: networkParameters, deviceType, P_RADIO_TX, P_RADIO_RX, P_RADIO_IDLE, P_SBY, P_RADIO_SLEEP');
            end
            
        end
        
        %%
        %% Getters and Setters Sections
        %%
        
        function obj=set.deviceType(obj, deviceType)
            obj.deviceType=deviceType;
            
            %validStrings = {'RN-131','CC2520'};
            %obj.deviceType = validatestring(deviceType,validStrings);
        end
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'DevicesParameters'))
                obj=DevicesParameters();
            else
                fns = properties(obj);
                for i=1:length(fns)
                    obj.(fns{i}) = obj.(fns{i});
                end
            end
            
        end
        
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
                if ~isa(proto,'DevicesParameters')
                    error('proto should be a DevicesParameters object')
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
