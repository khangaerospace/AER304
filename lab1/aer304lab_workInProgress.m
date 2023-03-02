%% AER304 Lab
clear all

diagnostic_plot = 0;

%Load data for each specimen 1-5
file{1} = readmatrix("specimen1.txt");
file{2} = readmatrix("specimen2.txt");
file{3} = readmatrix("specimen3.txt");
file{4} = readmatrix("specimen4.txt");
file{5} = readmatrix("specimen5.txt");

%preallocate
poisson_ratio(1:5)=0;
linear_time(1:5) = 0;
youngs_mod_laser(1:5) = 0;
youngs_mod_gauge(1:5) = 0;
yield_stress(1:5) = 0;
uts(1:5) = 0;

%% Determining where gauge ratios are linear wrt time (qualitative)
%%Qualitatively determine where gauge ratios are linear wrt time
if diagnostic_plot
for i = 1:5
    gauge1{i}(:) = file{i}(:,5);
    gauge2{i}(:) = file{i}(:,6);
    figure(i)
    plot(gauge2{i}./gauge1{i})
    xlabel('Index')
    ylabel('gauge2/gauge1 Ratio')
end
end

% gauge_linear_range(1,:) = [45 740];
% gauge_linear_range(2,:) = [16 140];
% gauge_linear_range(3,:) = [45 315];
% gauge_linear_range(4,:) = [25 690];
% gauge_linear_range(5,:) = [45 900]; 

%% Analysis

for i = 1:5
[strain{i},stress{i},poisson_ratio(i), linear_time(i), youngs_mod_laser(i), youngs_mod_gauge(i),yield_stress(i),uts(i)]=analyze(file{i},i);
end

poisson_ratio
youngs_mod_laser
youngs_mod_gauge
yield_stress
uts

%% Determining qualitatively where stress/strain relationship is linear
if diagnostic_plot
for k = 1:5
    figure(k+5)
    plot(strain{k}(1:end-10),stress{k}(1:end-10))
    xlabel('Strain')
    ylabel('Stress')
end
end

%% Determining qualitatively where unloading region is
if diagnostic_plot
for k = 1:5
    figure(k+10)
    plot(file{k}(1:500,6))
    xlabel('Index')
    ylabel('Gauge Displacement')
end
end
%% Determining qualitatively where failure occured (by looking at graphs)
%failure_strain_index = find(strain{3}>0.33,1)


%% Functions
function [strain, stress, poisson, linear_time, youngs_laser, youngs_gauge, yield_stress, uts] = analyze(file, specnum)
%%% definitions
%strain is determined using laser extensometer data
%stress is calculated as force/initial_area [Pa]
%poisson is the Poisson's ratio
%linear_time is the time where the relationship is linear [seconds]
%youngs_laser is Young's Modulus calculated using the laser [Pa]
%youngs_gauge is Young's Modulus calculated using the strain gauges [Pa]
%yield_stress is the calculated yield stress [Pa]
%uts is the ultimate tensile stress [Pa]
%file is the data file, specnum is the specimen number

%%% Set up, defining ranges and areas
%number of data points relationship is linear per specimen
%determined qualitatively from laser extensometer data
linear_portion = [549 106 348 702 409];
%data point where failure occurred, determined qualitatively
usable_portion = [1102 705 1228 949 1317];

%determined qualitatively from gauge data
gauge_linear_range(1,:) = [45 740];
gauge_linear_range(2,:) = [16 140];
gauge_linear_range(3,:) = [45 315];
gauge_linear_range(4,:) = [25 690];
gauge_linear_range(5,:) = [45 900];

%unloading phases (Determined by looking at strain gauge graphs)
unloading(1,:) = [101 145];
unloading(2,:) = [119 140];
unloading(3,:) = [129 170];
unloading(4,:) = [243 300];
unloading(5,:) = [277 342];

%The index range [a,b] where gauge ratio is linear for this specimen
gauge_index_a = gauge_linear_range(specnum,1);
gauge_index_b = gauge_linear_range(specnum,2);
unloading_index_a = unloading(specnum,1);
unloading_index_b = unloading(specnum,2);

%Calculate cross sectional area for each specimen using measured dimensions
width = [14.87, 14.85, 14.95, 14.87,15.23]; %%mm
thick = [3.22, 3.20, 3.10, 3.25, 3.32]; %mm
A = width.*thick/1000000; %[m^2]

time = file(:,1)';
force = file(:,2)';
lasdisp = file(:,4)';
gauge1 = file(:,5)';
gauge2 = file(:,6)';

%Determine which gauge is measuring axial and which is transverse
if min(gauge2)<min(gauge1)
    axial = gauge1;
    transverse = gauge2;
else
    axial = gauge2;
    transverse = gauge1;
end

%Determine time when linear-relationship deteriorated (using laser data as gauges may have broken during this period)
linear_time = time(linear_portion(specnum));

%find stress as function of datapoints (aka time)
stress = force/A(specnum); %Newtons/square m = Pascals

%determine strain using laser extensometer
strain(:) = (lasdisp(:)-lasdisp(1))/lasdisp(1); %laser strain 

%%calculate Poisson's Ratio using curated strain gauge data
[poisson,~] = poissonRatio(axial(gauge_index_a:gauge_index_b),transverse(gauge_index_a:gauge_index_b));

%%calculate Young's modulus using strain gauge data
%youngs_gauge = mean(stress(unloading_index_a:unloading_index_b)./axial(unloading_index_a:unloading_index_b));
unloadingLineGauge = polyfit(axial(unloading_index_a:unloading_index_b),stress(unloading_index_a:unloading_index_b),1);
youngs_gauge = unloadingLineGauge(1);

%%calculate Young's modulus using laser extensometer data (considering only unloading region)
%youngs_laser = mean(stress(unloading_index_a:unloading_index_b)./strain(unloading_index_a:unloading_index_b));
unloadingLineLaser = polyfit(strain(unloading_index_a:unloading_index_b),stress(unloading_index_a:unloading_index_b),1);
youngs_laser = unloadingLineLaser(1);

%%calculate Yield stress
threshold = 0.002; % 0.2% of strain
%determine equation of intersecting line by finding initial slope
%Initial slope approximated using the linear range of data points
p = polyfit(strain(1:linear_portion(specnum)),stress(1:linear_portion(specnum)),1);
slope = p(1);
yintersect = -slope*threshold;
t = strain(1:usable_portion(specnum));

%threshold function aka 0.002% linear offset
ythreshold = slope*t+yintersect;

%determine when intersection happens
%ie the strain corresponding to actual(strain)<ythreshold(strain)
tt = find(stress(1:usable_portion(specnum))<ythreshold,1);
yield_stress = stress(tt);

%if yield_stress is unable to be calculated from laser data, return as -1
if isempty(yield_stress)
    yield_stress = -1;
end

%%determine Ultimate Tensile Stress
%the stress corresponding to the last useful data point
uts = stress(usable_portion(specnum));
end

function [average_poisson_ratio, poisson_ratio] = poissonRatio(axial,transverse)
    %axial strain and transverse strain
    %average_poisson_ratio will be a scalar.
    %poisson_ratio will be a vector of ratios at each point in time

    poisson_ratio = -transverse./axial;
    average_poisson_ratio = mean(poisson_ratio);
end