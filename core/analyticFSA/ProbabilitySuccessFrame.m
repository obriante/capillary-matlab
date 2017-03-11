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

function [ Ps ] = ProbabilitySuccessFrame(nSlots, nDevices)

Ps = zeros(nSlots + 1, nDevices + 1);

for index_nodes = 1:nDevices + 1
    nodes = index_nodes - 1;
    for index_m1 = 1:1:nSlots + 1
        m1 = index_m1 - 1;
        s1 = 0;
        for k = 1:(nodes - m1)
            p2 = 1;
            for j = 0:(k - 1)
                p2 = p2 * (nodes - m1 - j) * (nSlots - m1 - j);
            end;
            s1 = s1 + (-1)^k * p2 * (nSlots - m1 - k)^(nodes - m1 - k)/factorial(k);
        end;
        
        G = (nSlots - m1)^(nodes - m1) + s1;
        
        p1 = 1;
        for k = 0:(m1-1)
            p1 = p1 * (nodes  - k);
        end;
        if (m1 <= nodes)
            Ps(index_m1,index_nodes) = p1 * nchoosek(nSlots, m1) * G /nSlots^nodes;
        else
            Ps(index_m1,index_nodes) = 0;
        end
    end
end
end
