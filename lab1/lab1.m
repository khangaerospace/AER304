clear all;
% YOu can do all at once. But I just like it this way for now
file = readmatrix("specimen1.txt"); % out the speciment data you want %
specnum = 5; % Speciment number %
time = file(:,1);
force = file(:,2);
displace = file(:,3);
lasdisp = file(:,4);
gauge1 = file(:,5);
gauge2 = file(:,6);
% right now, I will calculate stress using the initial area, I will add in
% poison ratio later
width = [14.87, 14.85, 14.95, 14.87,15.23].*0.001; % Define the dimensions of the specimen
thick = [3.22, 3.20, 3.10, 3.25, 3.32].*0.001;
A = width.*thick;

% find stress
stress_all = force./A(specnum);

stress = zeros(1,length(force));
stress(1) = stress_all(1);
strain = zeros(1,length(force));
strain(1) = gauge1(1);

% Calculate average rate of change of strain gauge data over first 10% of data
n_start = round(length(gauge1)*0.1);
slope_start = mean(diff(gauge1(1:n_start))./diff(lasdisp(1:n_start)));

for i = 2:length(force)
    % Check whether to switch to using laser displacement data to calculate strain
    if i > n_start && i < length(gauge1)*0.9
        slope_i = mean(diff(gauge1(i-n_start:i))./diff(lasdisp(i-n_start:i)));
        if abs(slope_i - slope_start) > 0.005 * abs(slope_start)
            % If the strain gauge has broken, use laser displacement data to calculate the strain
            strain(i) = strain(i-1) + (lasdisp(i)-lasdisp(i-1))/lasdisp(i-1);
            stress(i) = stress_all(i);
            % we need to check when the material break.
            
            continue
        end
    end
    
    % Otherwise, use the strain gauge data to calculate the strain
    strain(i) = abs(gauge1(i));
    dx = abs(gauge1(i));
    dy = abs(gauge2(i));
    stress(i) = stress_all(i);
    linestress = stress_all(i); % for calculating the stress before yeilding
end

% Plot lazer only
strain_las = zeros(1,length(force));
strain_las(1) = gauge1(1);

for i = 2:length(force)
    % the laser will not break therefore I have not add an if condition in.
    strain_las(i) = abs(strain_las(i-1)) + (lasdisp(i)-lasdisp(i-1))/lasdisp(i); 
end

% find the poisson ratio
poisson = dx ./ dy;
avg_poison = mean(poisson);
%disp('Poisson Ratio of speciment');
%disp(avg_poison);

% find the Young's mododulus
E = linestress ./dx;
E_avg = mean(E);
%disp('Young modulus of speciment');
%disp(E_avg);

% plot stress and strain
figure(1);
plot(strain,stress)
xlabel('Strain');
ylabel('Stress');
title('Stress-Strain Curve for Specimen 1');


% Now, calulcate the % Young modulus of the first speciment
Young_mo = zeros(1,length(force));
for i = 1:length(force)
    if stress_all(i) > 40600000
        break
    end
    
    Young_mo = stress_all(i)/strain_las(i);
end
disp("Average YOung modulus using laser");
ave_young_mo = mean(Young_mo);
disp(ave_young_mo);

% Plot the graph
figure(2)
plot(strain_las,stress_all)
xlabel('Strain');
ylabel('Stress');
title('Stress-Strain Curve using laser');
