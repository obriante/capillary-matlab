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

classdef Sensor
    %%
    %%  Sensor Class
    %
    %   Represent a Sensor object that can be explained with a poisson
    %   distribution
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
        %         maxNumber;
        %         minNumber;
        %         readingTime;         % [sec]
        
        lambda; % The arrival rate
    end
    
    methods
        
        function print(obj)
            fprintf('Sensor:\n');
            fprintf('\n');
            fprintf('Arrival Rate (lambda): %d\n', obj.lambda);
            fprintf('\n');
        end
        
        %%
        %
        %% Class Constructor
        %
        % input: (optional)
        %       lambda: the arrival rate (default = 1)
        %
        %%
        function obj=Sensor(lambda)
            if nargin==0
                obj.lambda=1;
            elseif nargin ==1
                obj.lambda=lambda;
            else
                error('The input arguments are: lambda')
            end
        end
        
        %%
        %% Getters and Setters Sections
        %%
        
        function obj=set.lambda(obj, lambda)
            if(~isnumeric(lambda))
                error('lambda should be a number.')
            else
                obj.lambda=lambda;
            end
        end
        
        function lambda=get.lambda(obj)
            lambda=obj.lambda;
        end
        
        %%
        %
        %% Simulate the data reading from the sensor
        %
        %% input:
        %       nFrameSlots: The number of Slots used into the FSA Frame
        %
        %% output:
        %       data: is the number of datas readed.
        %%
        function data=read(obj)
            data=poissrnd(obj.lambda,  1, 1);
        end
        
        %%
        %
        %% Simulate the data reading from the sensor into a Frame FSA
        %
        %% input:
        %       nFrameSlots: The number of Slots used into the FSA Frame
        %
        %% output:
        %       data: [ 1 X nFrameSlots+4 (because: RFD+IFS+nFrameSlots+IFS+FBP) ] matrix where obj(i,j) is the
        %       number of datas readed into every single slots ()
        %%
        function data=readInFrame(obj, nFrameSlots)
            if (nargin<2 || nargin >2)
                error('The input parameter are. obj, nDevices, nFrameSlots.');
            elseif (~isnumeric(nFrameSlots))
                error('nFrameSlots should be a number');
            elseif (nFrameSlots <= 0)
                error('nFrameSlots should be >0');
            else
                data=poissrnd(obj.lambda,  1, nFrameSlots+4);
            end
        end
        
        %%
        %
        %% This method is usefull to clone an object of this class
        %
        %%
        function obj=clone(obj)
            if (~isa(obj, 'Sensor'))
                obj=Sensor();
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
                    if ~isa(proto,'Sensor')
                        error('proto should be a Sensor object')
                    end
                end
                
                obj(m,n) = Sensor; % Preallocate object array
                for i = 1:m
                    for j = 1:n
                        
                        if nargin==2
                            obj(i,j) = Sensor();
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
