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

function [Q] = TransitionMatrix(Ps)

length=size(Ps);
nDevices=length(2)-1;
nSlots=length(1)-1;

j_MAX = nDevices;

Q = zeros(j_MAX + 1,j_MAX + 1);
for index_i = 1:j_MAX + 1
    i = index_i - 1;
    for index_j=1:j_MAX + 1
        j = index_j - 1;
        if (j < i) || (j > i + nSlots)
            Q(index_i,index_j) = 0;
        else if (j > i) && (j <= i + nSlots)
                Q(index_i,index_j) = Ps(j - i + 1, nDevices - i + 1);
                % 1 is added to index correctly the matrix component
            end
        end
    end
    for index_j=1:j_MAX + 1
        Q(index_i,index_i) =  Q(index_i,index_i) + Q(index_i,index_j);
    end
    Q(index_i,index_i) = 1 - Q(index_i,index_i);
end

end

