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

classdef PredictorSystem
    %PREDICTIONSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'public')
        smootingFactor;
        predictedValue=0;
        currentTimeUpdate=0
        lastTimeUpdate=0;
    end
    
    methods
        function print(obj)
            fprintf('PredictorSystem:\n');
            fprintf('\n');
            fprintf('Smooting Factor  : %0.4f\n',obj.smootingFactor);
            fprintf('Predicted Value  : %0.4f\n',obj.predictedValue);
            fprintf('Last Time Update : %0.4f\n',obj.lastTimeUpdate);
            fprintf('\n');
        end
        
        %%
        %
        %% Class Constructor
        %
        %%
        function obj=PredictorSystem(smootingFactor)
            
            if(nargin==0)
                
                obj.smootingFactor=1;
                obj.predictedValue=0;
                
            elseif(nargin==1)
                
                obj.smootingFactor=smootingFactor;
                obj.predictedValue=0;
                
            else
                error('input arguments are: smootingFactor');
            end
        end
        
        function obj=set.smootingFactor(obj, smootingFactor)
            if (~isnumeric(smootingFactor))
                error('smootingFactor should be a number');
            else
                obj.smootingFactor=smootingFactor;
            end
        end
        
        function smootingFactor=get.smootingFactor(obj)
            smootingFactor=obj.smootingFactor;
        end
        
        function predictedValue=get.predictedValue(obj)
            predictedValue=obj.predictedValue;
        end
        
        function obj=Predict(obj, currentValue, currentTime)
            if(nargin==3)
                obj.predictedValue=EWMAFilter(currentValue, obj.predictedValue, obj.smootingFactor);
                obj.lastTimeUpdate=obj.currentTimeUpdate;
                obj.currentTimeUpdate=currentTime;
            else
                error('input arguments are: currentValue');
            end
        end
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'PredictorSystem'))
                obj=PredictorSystem();
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
                    if ~isa(proto,'PredictorSystem')
                        error('proto should be a PredictorSystem object')
                    end
                end
                
                obj(m,n) = PredictorSystem; % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        
                        if nargin==2
                            obj(i,j) = PredictorSystem();
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

