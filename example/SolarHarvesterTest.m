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

addpath(genpath('../core'));

rng('shuffle','v5uniform');

nSampleHours=3600;

sunrise=7*nSampleHours;
sunset=18*nSampleHours;

% time=sunrise:sunset;
time=sunset-10:sunset;

maxValue=1.8874782*10^3;
minValue=1.5631218*10^3;
solarPanelEfficiency=8;
DCDCefficiency=90;

solarHarvester=SolarHarvester(maxValue, minValue, sunrise, sunset, solarPanelEfficiency, DCDCefficiency)
solarHarvester.print()

[lastHarvestedEnergy, lastSolarRadiation]=solarHarvester.Harvest(time)

solarHarvester2=solarHarvester.clone()
solarHarvesters=SolarHarvester.Array(5, 10, solarHarvester)
[lastHarvestedEnergy, lastSolarRadiation]=solarHarvester.Harvest(sunset+30)
[lastHarvestedEnergy, lastSolarRadiation]=solarHarvester.Harvest(sunrise+20)
