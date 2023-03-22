clear all;
clc
% You can do all at once. But I just like it this way for now
file = readmatrix("aluminum_3_point.txt"); % out the speciment data you want %\file = readmatrix("specimen1.txt");
file2 = readmatrix("aluminum_4_point.txt");
Area = 1472.59; % [mm^2]
% now create the variable for strain 3 points load
time1 = file(:,1); %[s]
MTSforce1 = file(:,2); %[N]
MTSdisp1 = file(:,3); %[mm]
LD1 = file(:,4); %[mm]
SG11 = file(:,5); %[mm/mm]
SG21 = file(:,6); %[mm/mm]
SG31 = file(:,7); %[mm/mm]
SG451 = file(:,8); %[mm/mm]
ActualLD1 = file(:,9); %[mm/mm]

% now create variable for 4 points load
time2 = file2(:,1); %[s]
MTSforce2 = file2(:,2); %[N]
MTSdisp2 = file2(:,3); %[mm]
LD2 = file2(:,4); %[mm]
SG12 = file2(:,5); %[mm/mm]
SG22 = file2(:,6); %[mm/mm]
SG32 = file2(:,7); %[mm/mm]
SG452 = file2(:,8); %[mm/mm]
ActualLD2 = file2(:,9); %[mm/mm]

% find stress for 3 points bending
figure(1);
plot(ActualLD1,SG11);
hold on
plot(ActualLD1,SG21);
hold on
plot(ActualLD1,SG31);
legend({'Strain Gauge 1', 'Strain Gauge 2', 'Strain Gauge 3'},'Location','southeast')
xlabel('Displacement')
ylabel('Strain')
title('Displacement vs strain for 3 points bending')



