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
SG11 = -1*file(:,5); %[mm/mm]
SG21 = -1*file(:,6); %[mm/mm]
SG31 = -1*file(:,7); %[mm/mm]
SG451 = file(:,8); %[mm/mm]
ActualLD1 = -1*file(:,9); %[mm/mm]

% now create variable for 4 points load
time2 = file2(:,1); %[s]
MTSforce2 = file2(:,2); %[N]
MTSdisp2 = file2(:,3); %[mm]
LD2 = file2(:,4); %[mm]
SG12 = -file2(:,5); %[mm/mm]
SG22 = -file2(:,6); %[mm/mm]
SG32 = -file2(:,7); %[mm/mm]
SG452 = file2(:,8); %[mm/mm]
ActualLD2 = -file2(:,9); %[mm/mm]

%draw line of best fit for 3 points bending
coef11 = polyfit(ActualLD1, SG11, 1);
coef21 = polyfit(ActualLD1, SG21, 1);
coef31 = polyfit(ActualLD1, SG31, 1);
dis1 = linspace(0, max(ActualLD1), 1000);
yFit1 = polyval(coef11 , dis1);
yFit2 = polyval(coef21 , dis1);
yFit3 = polyval(coef31 , dis1);

%draw the line of best fit for 4 points bending
%draw line of best fit for 3 points bending
coef12 = polyfit(ActualLD2, SG12, 1);
coef22 = polyfit(ActualLD2, SG22, 1);
coef32 = polyfit(ActualLD2, SG32, 1);
dis2 = linspace(0, max(ActualLD2), 1000);
yFit12 = polyval(coef12 , dis2);
yFit22 = polyval(coef22 , dis2);
yFit32 = polyval(coef32 , dis2);

% find stress for 3 points bending
figure(1);
plot(ActualLD1,SG11);
hold on
plot(ActualLD1,SG21);
hold on
plot(ActualLD1,SG31);
hold on
plot(dis1, yFit1, 'k-');
hold on
plot(dis1, yFit2, 'k-');
hold on
plot(dis1, yFit3, 'k-');
legend({'Strain Gauge 1', 'Strain Gauge 2', 'Strain Gauge 3'},'Location','northwest')
xlabel('Displacement')
ylabel('Strain')
title('Displacement vs strain for 3 points bending')
hold off

% find stress for 4 points bending
figure(2)
plot(ActualLD2,SG12);
hold on
plot(ActualLD2,SG22);
hold on
plot(ActualLD2,SG32);
hold on
plot(dis2, yFit12, 'k-');
hold on
plot(dis2, yFit22, 'k-');
hold on
plot(dis2, yFit32, 'k-');
legend({'Strain Gauge 1', 'Strain Gauge 2', 'Strain Gauge 3'},'Location','northwest')
xlabel('Displacement')
ylabel('Strain')
title('Displacement vs strain for 4 points bending')
hold off





