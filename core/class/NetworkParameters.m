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

classdef NetworkParameters
    
    %%
    %% NetworkParameters
    %
    %   Network Parameters
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
        
        networkType;         % { '802.11g', '802.15.4' }
        
        %% Length variables
        
        CRC;                 % CRC (bits)
        
        MAC_HEADER;          % MAC Header (bits)
        
        RFD_HEADER;          % RFD header (bits)
        RFD_PAYLOAD;         % RFD _PAYLOAD (bits)
        RFD;                 % RFD length (bits)
        
        FBP_HEADER;          % FBP header (bits)
        FBP_SLOT_PAYLOAD;    % FBP Singol Slot _PAYLOAD (bits)
        
        MAX_DATA_PAYLOAD;    % Max Paket payload supported by the tecnology (bits)
        DATA_PAYLOAD;        % Paket payload  (bits)
        DATA_LENGTH;         % Paket length (bits)
        
        
        %% Time variables
        
        RATE;                % data-rate in bps
        TIFS;                % IFS duration in sec
        
        T_PREAMBLE;          % duration of a frame preamble (sec)
        
        %% Estimated Parameters
        
        RFD_TIME;            % duration of a RFD packet (sec)
        DATA_TIME;           % duration of a DATA packet (sec)
        FBP_HEADER_TIME;     % duration of FBP Header (sec)
        
        
        
        
    end
    
    methods
        
        function print(obj)
            fprintf('Network Parameters:\n');
            fprintf('\n');
            fprintf('Network Type:           %s\n',obj.networkType);
            fprintf('CRC:                    %d [bits]\n',obj.CRC);
            fprintf('MAC Header:             %d [bits]\n',obj.MAC_HEADER);
            fprintf('RFD Header:             %d [bits]\n',obj.RFD_HEADER);
            fprintf('FBP Header:             %d [bits]\n',obj.FBP_HEADER);
            fprintf('FBP Slot Payload:       %d [bits]\n',obj.FBP_SLOT_PAYLOAD);
            fprintf('Max Data Payload:       %d [bits]\n',obj.MAX_DATA_PAYLOAD);
            fprintf('Data Payload:           %d [bits]\n',obj.DATA_PAYLOAD);
            fprintf('Rate:                   %d [bps]\n',obj.RATE);
            fprintf('TIFS:                   %d [sec]\n',obj.TIFS);
            fprintf('Preamble Time:          %d [sec]\n',obj.T_PREAMBLE);
            fprintf('\n');
            fprintf('RFD Time:               %d [sec]\n',obj.RFD_TIME);
            fprintf('DATA Time:              %d [sec]\n',obj.DATA_TIME);
            fprintf('FBP HEADER Time:        %d [sec]\n',obj.FBP_HEADER_TIME);
            fprintf('\n');
            
        end
        
        %%
        %
        %% Class Constructor
        %
        %% input:
        %           networkType: supported networks: '802.11g', '802.15.4'
        %%
        function obj=NetworkParameters(networkType, CRC, MAC_HEADER, RFD_HEADER, FBP_HEADER, FBP_SLOT_PAYLOAD, MAX_DATA_PAYLOAD, DATA_PAYLOAD, RATE, TIFS, T_PREAMBLE)
            if nargin == 1
                if strcmp(networkType,'802.11g')
                    obj.networkType         =   '802.11g';
                    obj.CRC                 =   4*8;
                    obj.MAC_HEADER          =   30*8;
                    obj.RFD_HEADER          =   0;
                    obj.FBP_HEADER          =   0;
                    obj.FBP_SLOT_PAYLOAD    =   2;
                    obj.MAX_DATA_PAYLOAD    =   2312*8;
                    obj.DATA_PAYLOAD        =   2312*8;
                    
                    obj.RATE                =   54E6;
                    obj.TIFS                =   16E-6;
                    obj.T_PREAMBLE          =   20E-6;
                    
                elseif strcmp(networkType,'802.15.4')
                    obj.networkType         =   '802.15.4';
                    obj.CRC                 =   2*8;
                    obj.MAC_HEADER          =   8*8;
                    obj.RFD_HEADER          =   0; %4;
                    obj.FBP_HEADER          =   0; %4;
                    obj.FBP_SLOT_PAYLOAD    =   2;
                    obj.MAX_DATA_PAYLOAD    =   104*8;
                    obj.DATA_PAYLOAD        =   104*8;
                    
                    obj.RATE                =   250E3;
                    obj.TIFS                =   192E-6;
                    obj.T_PREAMBLE          =   160E-6;
                end
                
            elseif nargin==11
                
                obj.networkType         =   networkType;
                obj.CRC                 =   CRC;
                obj.MAC_HEADER          =   MAC_HEADER;
                obj.RFD_HEADER          =   RFD_HEADER;
                obj.FBP_HEADER          =   FBP_HEADER;
                obj.FBP_SLOT_PAYLOAD    =   FBP_SLOT_PAYLOAD;
                obj.DATA_PAYLOAD        =   DATA_PAYLOAD;
                obj.MAX_DATA_PAYLOAD    =   MAX_DATA_PAYLOAD;
                
                obj.RATE                =   RATE;
                obj.TIFS                =   TIFS;
                obj.T_PREAMBLE          =   T_PREAMBLE;
            else
                error('Input arguments are: networkType, CRC, MAC_HEADER, RFD_HEADER, FBP_HEADER, FBP_SLOT_PAYLOAD, MAX_DATA_PAYLOAD, DATA_PAYLOAD, RATE, TIFS, T_PREAMBLE')
            end
            
            obj.RFD_PAYLOAD = obj.RFD_HEADER;
            obj.RFD = obj.RFD_PAYLOAD + (obj.MAC_HEADER + obj.CRC);
            
            
            if(obj.DATA_PAYLOAD<obj.MAX_DATA_PAYLOAD)
                obj.DATA_LENGTH  = (obj.DATA_PAYLOAD + obj.MAC_HEADER + obj.CRC);
            else
                obj.DATA_LENGTH  = (obj.MAX_DATA_PAYLOAD + obj.MAC_HEADER + obj.CRC);
            end
            
            obj.RFD_TIME    = (obj.RFD / obj.RATE) + obj.T_PREAMBLE;
            obj.DATA_TIME   = (obj.DATA_LENGTH / obj.RATE) + obj.T_PREAMBLE;
            obj.FBP_HEADER_TIME    = (obj.T_PREAMBLE +(obj.FBP_HEADER + obj.MAC_HEADER + obj.CRC)) / obj.RATE;
            
        end
        
        
        %%
        %% Getters and Setters Sections
        %%
        
        function obj=set.networkType(obj, networkType)
            
            obj.networkType=networkType;
            %validStrings = {'802.11g','802.15.4'};
            %obj.networkType = validatestring(networkType,validStrings);
        end
        
        
        %%
        %%
        %%
        function [time]=FBP_TIME(obj, nSlots)
            time=obj.FBP_HEADER_TIME+(nSlots * obj.FBP_SLOT_PAYLOAD / obj.RATE);
        end
        
        function [time]=SINGLE_FRAME_TIME(obj, nSlots)
            time=(2*obj.TIFS) + nSlots * obj.DATA_TIME + obj.FBP_TIME(nSlots);
        end
        
        
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'NetworkParameters'))
                obj=NetworkParameters();
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
                if ~isa(proto,'NetworkParameters')
                    error('proto should be a NetworkParameters object')
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
