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

% RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

function [deviceRandomSlots, txFrames, frameStatus, successDevices, transitionFrames]=ReservedFramedSlottedALOHA(network, nSlots)

% rng shuffle; %% Not a good Idea!

if ~isa(network,'Network')
    error('network should be a Network object.');
end

if nSlots < 1
    error('nSlots should be >=1.');
end

devicesDataAtStart=network.packets2Transmit();

frameStatus=zeros(1,nSlots);

nDevices=length(devicesDataAtStart);

successDevices=zeros(1, nDevices);

deviceRandomSlots=zeros(1, nDevices);

reservedSlots=zeros(1, nDevices);


txFrames=1;
while(max(devicesDataAtStart)>0)

    [deviceRandomSlots_, frameStatus_, successDevices_, devicesDataAtStart, reservedSlots]=singleFrameRFSA(devicesDataAtStart, nSlots, reservedSlots);
    deviceRandomSlots(txFrames,:)=deviceRandomSlots_(1:nDevices);
    frameStatus(txFrames,:)=frameStatus_(1:nSlots);
    successDevices(txFrames,:)=successDevices_(1:nDevices);
        
    txFrames=txFrames+1;
end

txFrames=txFrames-1;

[~,transitionFrames] = max(successDevices(:,sum(successDevices)>0));
transitionFrames=transitionFrames-1;
end

%%
%
%%  Simulate a single Frame of the Framed Slotted ALOHA
%
%%  input:
%           devicesDataAtStart: an array where devicesDataAtStart(i) is the number of transmission packets initialized for the node i.
%
%           nSlots: the number of slots into a FSA Frame.
%
%%  output:
%           deviceRandomSlots: an array where deviceRandomSlots(i) is the random slot selected by the device i to transmit into the current FSA Frame
%
%           frameStatus: an array with dimension nSlots where frameStatus(i) is the number of packets transmitted into the slots i of the current FSA Frame
%
%           successDevices: an array where successDevices(i) indicate the success transmission by the device i (1=success 0=not success)
%
%
%%   Authors:
%               Orazio Briante          orazio.briante@unirc.it
%               Anna Maria Mandalari    anna.mandalari.647@studenti.unirc.it
%
%%   Organization:
%                   Laboratory A.R.T.S. - University Mediterranea of Reggio Calabria - Faculty of Engineering
%
%%   Year:      2013
%
%%
function [deviceRandomSlots, frameStatus, successDevices, devicesDataAtStop, reservedSlots]=singleFrameRFSA(devicesDataAtStart, nSlots, reservedSlots) % It computes the Frames Number in order to each device has just transmitted successfully

if ~isvector(devicesDataAtStart)
    error('devicesDataAtStart should be an array');
end

if(nSlots < 1)
    error('nSlots must be >= 1')
end;

if ~isvector(reservedSlots)
    error('reservedSlots should be an array');
end

if length(reservedSlots)<length(devicesDataAtStart)
    error('reservedSlots should have nDevices length');
end

freeSlots=1:1:nSlots;
freeSlots(reservedSlots(find(reservedSlots>0)))=[];

nDevices=length(devicesDataAtStart);
noContentDevices=zeros(1,nDevices);

if(max(reservedSlots)>0)
    noContentDevices=reservedSlots>0;
end

currentDevice=find((devicesDataAtStart>0).*~noContentDevices);
randomSlots=freeSlots(randi(length(freeSlots),1,length(currentDevice)));
[a,b] = hist(randomSlots,unique(randomSlots));

a(find(b==0))=[];
b(find(b==0))=[];

frameStatus=zeros(1, nSlots);
frameStatus(b) = a;

if(max(reservedSlots)>0)
    frameStatus(reservedSlots(find(reservedSlots>0)))=1;
end

successDevices=zeros(1,nDevices);
successDevices(currentDevice)=frameStatus(randomSlots)==1;
successDevices=successDevices+noContentDevices;

deviceRandomSlots=zeros(1, nDevices);
deviceRandomSlots(currentDevice)=randomSlots;
deviceRandomSlots=deviceRandomSlots+reservedSlots;

devicesDataAtStop=devicesDataAtStart-successDevices;

reservedSlots=(successDevices.*deviceRandomSlots);
reservedSlots(find(devicesDataAtStop==0))=0;

end
