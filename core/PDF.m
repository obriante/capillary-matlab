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

function [p]=PDF(data, range)

s=size(data);

N = hist(data, range);
p = N./s(1);

% m=round(M);
% range=min(m(:))-1:1:max(m(:))+1;
% s=size(m);
% 
% 
% p=zeros(s(1), length(range));
% 
% for i=2:length(range)-1
% p(:,i)=sum(m'==range(i))./s(2);
% end

end
