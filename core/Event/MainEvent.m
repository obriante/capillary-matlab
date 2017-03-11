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

classdef MainEvent
    %MAINEVENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'public')
        startTime=0;
        currentTime=0;
        stopTime=0;
    end
    
    methods
        
        function print(obj)
            fprintf('Main event:\n');
            fprintf('startTime: %0.6f\n', obj.startTime);
            fprintf('currentTime: %0.6f\n', obj.currentTime);
            fprintf('stopTime: %0.6f\n', obj.stopTime);
            fprintf('\n');
        end
        
        function debug(obj, message)
            if ischar(message)
                fprintf('[%0.10f ]\t%s\n', obj.currentTime, message);
            end
        end
        
        function obj=MainEvent(startTime, stopTime)
            if nargin~=2
                error('input arguments are: start, stop');
            end
            
            if stopTime < startTime
                error('stopTime must be >= startTime');
            end
            obj.startTime=startTime;
            obj.currentTime=startTime;
            obj.stopTime=stopTime;
        end
        
        function obj=move(obj, args)
            
            if nargin>1
                
                current=obj.currentTime;
                
                next=min([args.next]);
                
                if next > current
                    obj.currentTime=next;
                else
                    obj.currentTime=obj.currentTime+1;
                end
                
            end
                        
        end
        
        function value=isEnd(obj)
            value=0;
            if obj.currentTime > obj.stopTime
                value=1;
            end
        end
        
        function value=is(obj, event)
            if nargin~=2
                error('input parameters are: obj, event');
            end
            
            if ~isa(event, 'Event')
                error('event must be aEvent object');
            end
            
            value=0;
            if obj.currentTime==event.next
                value=1;
            end
        end
    end
end
