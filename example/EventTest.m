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

clc;
clear all;
close all;
rng('shuffle', 'v5uniform');

format long

addpath(genpath('../core'));

mainEvent=MainEvent(0,4);
event1=Event()
event2=Event()
event3=Event(2)

while(mainEvent.currentTime <= mainEvent.stopTime)
    
    if(mainEvent.currentTime==event1.next)
    event1=event1.move(0.5);
    event1.print();
    end
    
    if(mainEvent.currentTime==event2.next)
    event2=event2.move(1);
    event2.print();
    end
    
    if(mainEvent.currentTime==event3.next)
    event2=event3.move(0.1);
    event2.print();
    end
    
    mainEvent=mainEvent.move([event1, event2, event3])
end
