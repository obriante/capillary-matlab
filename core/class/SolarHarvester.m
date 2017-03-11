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

classdef SolarHarvester
    %%
    %
    %% SolarHarvester
    %
    % Represent the Energy Source for the Harvesting process
    %
    %
    %%   Authors: Orazio Briante <orazio.briante@unirc.it>, Anna Maria Mandalari <anna.mandalari.647@studenti.unirc.it>
    %
    %%   Organization: Laboratory A.R.T.S. - University Mediterranea of Reggio Calabria - Faculty of Engineering
    %
    %%   Year:      2013
    %
    %%
    
    properties
        maxValue=1;                % Harvestable Energy (MAX Value) [J]
        minValue=0;                % Harvestable Energy (MIN Value) [J]
        sunriseTime=7*3600;        % sunrise Time [sec]
        sunsetTime=17*3600;        % sunset  Time [sec]
        solarPanelEfficiency=100;  % The Solar Panel Efficiency in percentage
        DCDCefficiency=100;        % The DC-DC Converter Efficiency in percentage
        
        dailyMaxTrend;
        dailyMinTrend;
        
    end
    
    methods
        
        function print(obj)
            fprintf('Solar Energy Harvester:\n')
            fprintf('\n');
            fprintf('Max Solar Irradiation      : %d [J]\n', obj.maxValue);
            fprintf('Min Solar Irradiation      : %d [J]\n', obj.minValue);
            fprintf('Sunrise Time               : %d [sec]\n', obj.sunriseTime);
            fprintf('Sunset Time                : %d [sec]\n', obj.sunsetTime);
            fprintf('Solar Panel Efficiency     : %d [%%]\n', obj.solarPanelEfficiency);
            fprintf('DC-DC Converter efficiency : %d [%%]\n', obj.DCDCefficiency);
            fprintf('\n');
        end
        
        %%
        %
        %% Class Constructor
        %
        % input: (optional)
        %%
        function obj=SolarHarvester(maxValue, minValue, sunriseTime, sunsetTime, solarPanelEfficiency, DCDCefficiency)
            
            
            if nargin==2
                obj.maxValue=maxValue;
                obj.minValue=minValue;
            elseif nargin==4
                obj.maxValue=maxValue;
                obj.minValue=minValue;
                obj.sunriseTime=sunriseTime;
                obj.sunsetTime=sunsetTime;
            elseif nargin==5
                obj.maxValue=maxValue;
                obj.minValue=minValue;
                obj.sunriseTime=sunriseTime;
                obj.sunsetTime=sunsetTime;
                obj.solarPanelEfficiency=solarPanelEfficiency;
                obj.DCDCefficiency=100;
            elseif nargin==6
                obj.maxValue=maxValue;
                obj.minValue=minValue;
                obj.sunriseTime=sunriseTime;
                obj.sunsetTime=sunsetTime;
                obj.solarPanelEfficiency=solarPanelEfficiency;
                obj.DCDCefficiency=DCDCefficiency;
            elseif nargin>6
                error('The input parameters are: maxValue, minValue, sunriseTime, sunsetTime, solarPanelEfficiency, DCDCefficiency')
            end
            
            obj=obj.DailyMinTrend();
            obj=obj.DailyMaxTrend();
        end
        
        function obj=DailyMaxTrend(obj)
            time=obj.sunriseTime:obj.sunsetTime;
            obj.dailyMaxTrend=sin((pi*(time-obj.sunriseTime))/(obj.sunsetTime-obj.sunriseTime))*(obj.maxValue/(obj.sunsetTime-obj.sunriseTime))*(pi/2);
        end
        
        function obj=DailyMinTrend(obj)
            time=obj.sunriseTime:obj.sunsetTime;
            obj.dailyMinTrend=sin((pi*(time-obj.sunriseTime))/(obj.sunsetTime-obj.sunriseTime))*(obj.minValue/(obj.sunsetTime-obj.sunriseTime))*(pi/2);
        end
        
        %%
        %% Getters and Setters Sections
        %%
        
        function obj=set.minValue(obj, minValue)
            if(isnumeric(minValue))
                obj.minValue=minValue;
                obj=obj.DailyMinTrend();
            else
                error('input should be a number');
            end
        end
        
        function minValue=get.minValue(obj)
            minValue=obj.minValue;
        end
        
        function obj=set.maxValue(obj, maxValue)
            if(isnumeric(maxValue))
                obj.maxValue=maxValue;
                obj=obj.DailyMaxTrend();
            else
                error('input should be a number');
            end
        end
        
        function maxValue=get.maxValue(obj)
            maxValue=obj.maxValue;
        end
        
        function obj=set.sunriseTime(obj, sunriseTime)
            if(isnumeric(sunriseTime))
                obj.sunriseTime=sunriseTime;
                obj=obj.DailyMinTrend();
                obj=obj.DailyMaxTrend();
            else
                error('input should be a number');
            end
        end
        
        function sunriseTime=get.sunriseTime(obj)
            sunriseTime=obj.sunriseTime;
        end
        
        function obj=set.sunsetTime(obj, sunsetTime)
            if(isnumeric(sunsetTime))
                obj.sunsetTime=sunsetTime;
                obj=obj.DailyMinTrend();
                obj=obj.DailyMaxTrend();
            else
                error('input should be a number');
            end
        end
        
        function sunsetTime=get.sunsetTime(obj)
            sunsetTime=obj.sunsetTime;
        end
        
        function obj=set.solarPanelEfficiency(obj, solarPanelEfficiency)
            if(isnumeric(solarPanelEfficiency))
                if(solarPanelEfficiency<=100 && solarPanelEfficiency>=0)
                    obj.solarPanelEfficiency=solarPanelEfficiency;
                else
                    error('input should be a value from 0 to 100');
                end
            else
                error('input should be a number');
            end
        end
        
        function solarPanelEfficiency=get.solarPanelEfficiency(obj)
            solarPanelEfficiency=obj.solarPanelEfficiency;
        end
        
        function obj=set.DCDCefficiency(obj, DCDCefficiency)
            if(isnumeric(DCDCefficiency))
                if(DCDCefficiency<=100 && DCDCefficiency>=0)
                    obj.DCDCefficiency=DCDCefficiency;
                else
                    error('input should be a value from 0 to 100');
                end
            else
                error('input should be a number');
            end
        end
        
        function DCDCefficiency=get.DCDCefficiency(obj)
            DCDCefficiency=obj.DCDCefficiency;
        end
        
        function [lastHarvestedEnergy, lastSolarRadiation]=Harvest(obj, time)
            
            if(time>=(24*3600))
                time=time-(24*3600*floor(time/(24*3600)));
            end
            
            lastHarvestedEnergy=zeros(1, length(time));
            lastSolarRadiation=zeros(1, length(time));
            
            %i=find(time==(obj.sunriseTime:obj.sunsetTime));
            % [v,it,i]=intersect(time, obj.sunriseTime:obj.sunsetTime)
            %i=arrayfun(@(x) find(x==obj.sunriseTime:obj.sunsetTime,1), time)
            
            fullTime=obj.sunriseTime:obj.sunsetTime;
            i=find(ismember(fullTime, time));
            %j=find(time>=obj.sunriseTime & time<=obj.sunsetTime);
            j=find(ismember(time, fullTime));
            lastSolarRadiation(j)=(obj.dailyMaxTrend(i)-obj.dailyMinTrend(i)).*rand() + obj.dailyMinTrend(i);
            
            efficiency=(obj.solarPanelEfficiency/100)*(obj.DCDCefficiency/100);
            lastHarvestedEnergy(j)=lastSolarRadiation(j)*efficiency;
            
            k=find(lastHarvestedEnergy < 1e-6);
            if ~isempty(k)
                lastHarvestedEnergy(k)=0;
            end
            
        end
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'SolarHarvester'))
                obj=SolarHarvester();
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
                    if ~isa(proto,'SolarHarvester')
                        error('proto should be a SolarHarvester object')
                    end
                end
                
                obj(m,n) = SolarHarvester; % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        
                        if nargin==2
                            obj(i,j) = SolarHarvester();
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
