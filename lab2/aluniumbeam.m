clear all;
clc
% You can do all at once. But I just like it this way for now
file = readmatrix("aluminum_3_point.txt"); % out the speciment data you want %\file = readmatrix("specimen1.txt");
file2 = readmatrix("aluminum_4_point.txt");
Area = 1472.59; % [mm^2]

% now create the variable for strain 3 points load
time1 = file(:,1); %[s]
MTSforce1 = -file(:,2); %[N]
MTSdisp1 = file(:,3); %[mm]
LD1 = file(:,4); %[mm]
SG11 = -1*file(:,6); %[mm/mm]
SG21 = -1*file(:,5); %[mm/mm]
SG31 = -1*file(:,7); %[mm/mm]
SG451 = -file(:,8); %[mm/mm]
ActualLD1 = -1*file(:,9); %[mm/mm]

% using picture, we will also have the follow for 3 points bending.
picLD1 = -1*[0.06635, -0.094508, -0.129403, -0.122613, -0.355676, -0.550519, -0.742947, -0.895336]';
pic11 = -1*[0, -0.000220618, -0.000223732, -0.000119214, -0.0001179182, -0.00010797964, -0.00010595612, -0.0001344236]';
pic21 = -1*[0, -0.0002501, -0.000323736, -0.000207743, -0.00023669, -0.000276908, -0.000354158, -0.000406692]';
pic31 = -1*[0, -0.000307732, -0.000326346, -0.000270148, -0.000319308, -0.000431834, -0.000492094, -0.000594886]';
pic451 = -1*[0, 0.00004113916, 0.0000235116, 0.00001933302, -0.000061958, -0.0000570436, -0.000137936, -0.000177588]';
force1 = -1*[45.822726, -449.56334, -1466.527103, -3547.833426, -6433.258865, -9514.160002, -12690.38897, -15915.71075]';
% now create variable for 4 points load
time2 = file2(:,1); %[s]
MTSforce2 = -file2(:,2); %[N]
MTSdisp2 = file2(:,3); %[mm]
LD2 = file2(:,4); %[mm]
SG12 = -file2(:,6); %[mm/mm]
SG22 = -file2(:,5); %[mm/mm]
SG32 = -file2(:,7); %[mm/mm]
SG452 = -file2(:,8); %[mm/mm]
ActualLD2 = -file2(:,9); %[mm/mm]

% using picture, we will also have the follow for 4 points bending.
picLD2 = -1*[0.158717, -0.104026, -0.322249, -0.450453, -0.452343, -0.520697, -0.517687, -0.426023, -0.502742, -0.419373, -0.534977]';
pic12 = -1*[0, -0.000554054, -0.00073228, -0.001026094, -0.001046134, -0.0010805, -0.00120797, -0.001150464, -0.001083736, -0.00122678, -0.00123052]';
pic22 = -1* [0, -0.0006596, -0.00097684, -0.00131908, -0.00140994, -0.00152646, -0.00167052, -0.00167098, -0.00171792, -0.00166962, -0.0017422]';
pic32 = -1*[0, -0.000786818, -0.001237, -0.00136022, -0.00162358, -0.00169236, -0.001759, -0.00196852, -0.00186584, -0.0020953, -0.00209964]';
pic452 = [0, 0.0003866792, 0.0000690874, 0.0008556088, 0.0001613134, 0.000283604, 0.0001064004, 0.0001017156, 0.0001903126, 0.000198518, 0.0000994292];
force2 = -1*[22.05976, -229.564695, -1114.590972, -2240.011095, -3155.066707, -4618.697248, -6512.786438, -8762.008011, -11999.31326, -15092.02309, -18577.11328]';
%draw line of best fit for 3 points bending
coef11 = polyfit(ActualLD1, SG11, 1);
coef21 = polyfit(ActualLD1, SG21, 1);
coef31 = polyfit(ActualLD1, SG31, 1);
dis1 = linspace(0, max(ActualLD1), 1000);
yFit1 = polyval(coef11 , dis1);
yFit2 = polyval(coef21 , dis1);
yFit3 = polyval(coef31 , dis1);

% draw the line of best fit for the 3 points bending using the NCORR
piccoe11 = polyfit(picLD1, pic11,1);
piccoe21 = polyfit(picLD1, pic21,1);
piccoe31 = polyfit(picLD1, pic31,1);
dispic1 = linspace(0, max(picLD1), 1000);
ypic11 = polyval(piccoe11, dispic1);
ypic21 = polyval(piccoe21, dispic1);
ypic31 = polyval(piccoe31, dispic1);

%draw the line of best fit for 4 points bending
coef12 = polyfit(ActualLD2, SG12, 1);
coef22 = polyfit(ActualLD2, SG22, 1);
coef32 = polyfit(ActualLD2, SG32, 1);
dis2 = linspace(0, max(ActualLD2), 1000);
yFit12 = polyval(coef12 , dis2);
yFit22 = polyval(coef22 , dis2);
yFit32 = polyval(coef32 , dis2);


% find stress for 3 points bending
figure(1);
plot(ActualLD1,SG11,'-o');
hold on
plot(ActualLD1,SG21,'-o');
hold on
plot(ActualLD1,SG31,'-o');
hold on
plot(picLD1, pic11,'-o')
hold on
plot(picLD1, pic21,'-o')
hold on
plot(picLD1, pic31,'-o')
hold on
plot(dis1, yFit1, 'k-');
hold on
plot(dis1, yFit2, 'k-');
hold on
plot(dis1, yFit3, 'k-');
hold on %
plot(dispic1, ypic11 , 'k-');%
hold on %
plot(dispic1, ypic21 , 'k-');%
hold on %
plot(dispic1, ypic31 , 'k-');%
legend({'Strain Gauge 1 (5 mm)', 'Strain Gauge 2 (19 mm)', 'Strain Gauge 3 (38 mm)', 'NCORR Strain at 5 mm', 'NCORR Strain at 19 mm', 'NCORR Strain at 27.5 mm'},'Location','northwest')
xlabel('Displacement [mm]')
ylabel('Strain')
title('Strain vs Displacement for 3 Points Bending')
hold off

% find stress for 4 points bending
figure(2)
plot(ActualLD2,SG12,'-o');
hold on
plot(ActualLD2,SG22, '-o');
hold on
plot(ActualLD2,SG32, '-o');
hold on
plot(picLD2, pic12,'-o');
hold on
plot(picLD2, pic22,'-o');
hold on
plot(picLD2, pic32,'-o');
hold on
plot(dis2, yFit12, 'k-');
hold on
plot(dis2, yFit22, 'k-');
hold on
plot(dis2, yFit32, 'k-');
legend({'Strain Gauge 1 (5 mm)', 'Strain Gauge 2 (19 mm)', 'Strain Gauge 3 (38 mm)', 'NCORR Strain at 5 mm', 'NCORR Strain at 19 mm', 'NCORR Strain at 27.5 mm'},'Location','northwest')
xlabel('Displacement [mm]')
ylabel('Strain')
title('Strain vs Displacement  for 4 Points Bending')
hold off

% shear strain can be calculate from 2* strain gauge at 45 degree
shear1 = 2*SG451;
shear2 = 2*SG452;
%shear force using pic
shearpic1 = 2*pic451;
shearpic2 = 2*pic452;

% we will plot the shear strain vs stress. 
figure(3)
plot(MTSforce1,shear1,'-o');
hold on
plot(force1, shearpic1,'-o')
xlabel('Force [N]');
ylabel('Shear Strain');
legend({'Using the Strain Gauge at 45^{\circ}', 'Using NCORR'},'Location','northwest') 
title('Force vs Shear Strain for 3 points bending')
hold off

figure(4)
plot(MTSforce2, shear2,'-o');
hold on
plot(force2, shearpic2,'-o');
xlabel('Force [N]');
ylabel('Shear Strain');
legend({'Using the Strain Gauge at 45^{\circ}', 'Using NCORR'},'Location','northwest') 
title('Force vs Shear Strain for 4 Points Bending')
hold off

%strain vs force
figure(5);
plot(MTSforce1,SG11,'-o');
hold on
plot(MTSforce1,SG21,'-o');
hold on
plot(MTSforce1,SG31,'-o');
hold on
plot(force1, pic11,'-o');
hold on
plot(force1, pic21,'-o');
hold on
plot(force1, pic31,'-o');
legend({'Strain Gauge 1 (5 mm)', 'Strain Gauge 2 (19 mm)', 'Strain Gauge 3 (38 mm)', 'NCORR Strain at 5 mm', 'NCORR Strain at 19 mm', 'NCORR Strain at 27.5 mm'},'Location','northwest')
xlabel('Force [N]')
ylabel('Strain')
title('Strain vs Force for 3 Points Bending')
hold off

figure(6);
plot(MTSforce2,SG12,'-o');
hold on
plot(MTSforce2,SG22,'-o');
hold on
plot(MTSforce2,SG32,'-o');
hold on
plot(force2, pic12,'-o');
hold on
plot(force2, pic22,'-o');
hold on
plot(force2, pic32,'-o');
legend({'Strain Gauge 1', 'Strain Gauge 2', 'Strain Gauge 3', 'height 5', 'height 19', 'height 27.5'},'Location','northwest')
xlabel('Force [N]')
ylabel('Strain')
title('Strain vs Force for 4 Points Bending')
hold off

% Now plot the strain at 90 seconds 


strain1 = [5.53698300000000e-05,0.000259000000000000,0.000535000000000000];
picstrain1 = -1*[-0.000001797306, -0.00010595612, -1.79e-04, -2.47e-04, -0.000354158, -0.000420132, -0.000492094];
strain2 = [1.27044600000000e-06,6.99419400000000e-05,0.000133000000000000]; % do it later
picstrain2 = -1*[-0.001098992, -0.00120797, -1.22e-03, -0.00162484, -0.00167052, -0.00177278, -0.001759];
picdis = [0, 5, 10, 15, 19, 23, 27.5];
distance = [5, 19, 38];

figure(7);
plot(distance,strain1,'-o')
hold on
plot(picdis, picstrain1, '-o')
legend({'Using 3 Strain Gauges', 'Using NCORR'},'Location','northwest') 
xlabel('Y-Distance [mm]')
ylabel('Strain')
title('Strain vs Y-Distance at 90 seconds for 3 Points Bending')
hold off

figure(8);
plot(distance,strain1,'-o')
hold on
plot(picdis, picstrain2, '-o')
legend({'Using 3 Strain Gauges', 'Using NCORR'},'Location','northwest') 
xlabel('Y distance [mm]')
ylabel('Strain')
title('Strain vs Y-Distance at 90 seconds for 3 Points Bending')
hold off



%theoretical displacement

% for 3 points bending
L = 400; % [mm]
E = 72000; % [MPa]
I = 1245500.07; % mm^4
L_out = 140; %mm

U_max1 = (MTSforce1.*(L^3))./(48*E*I);
U_max2 = -(MTSforce2.*L_out.*(-3*L^2 + 4*L_out^2))./(48*E*I);

figure(9)
plot(MTSforce1,ActualLD1, '-o')
hold on
plot(MTSforce1,U_max1)
legend({'Experimental Result', 'Theoretical Result'},'Location','northwest') 
xlabel('Foce Applied [N]')
ylabel('Displacement [mm]')
title('Displacement vs Force Applied for 3 Points Bending')
hold off

figure(10)
plot(MTSforce2,ActualLD2, '-o')
hold on
plot(MTSforce2,U_max2)
legend({'Experimental Result', 'Theoretical Result'},'Location','northwest') 
xlabel('Foce Applied [N]')
ylabel('Displacement [mm]')
title('Displacement vs Force Applied for 4 Points Bending')
hold off
