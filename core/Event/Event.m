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

classdef Event
    %EVENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'public')
        next;
    end
    
    methods
        function print(obj)
            fprintf('next event: %0.6f\n', obj.next);
            fprintf('\n');
        end
        
        function obj=Event(time)
            obj.next=0;
            if nargin==1
                if time < 0
                    error ('time can not be negative!')
                end
                obj.next=time;
            end
            
        end
        
        function obj=move(obj, time)
            if nargin~=2
                error('input arguments are: time')
            end
            
            if time < 0
                error ('time can not be negative!')
            end                    
            
            if time > 0
                obj.next=obj.next+time;
            else
                obj.next=obj.next+1;
            end
        end
        
        function obj=moveAt(obj, time)
                        
            current=obj.next;
            
            if time > current
                obj.next=time;
            else
                obj.next=obj.next+1;
            end
            
        end
        
        
        function obj=set.next(obj, next)
            
            if next<=obj.next
                error('the next occurrence must be late in time.');
            end
            
            obj.next=next;
        end
        
    end
    
end

