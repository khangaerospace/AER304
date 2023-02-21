clear all;
file = readmatrix("specimen1.txt"); % out the speciment data you want %
specnum = 1; % Speciment number %
time = file(:,1);
force = file(:,2);
displace = file(:,3);
lasdisp = file(:,4);
gauge1 = file(:,5);
gauge2 = file(:,6);
% right now, I will calculate stress using the initial area, I will add in
% poison ratio later
width = [14.87, 14.85, 14.95, 14.87,15.23]; % Define the dimensions of the specimen
thick = [3.22, 3.20, 3.10, 3.25, 3.32];
A = width.*thick;

% find stress
stress = force./A(specnum);

strain = zeros(1,length(force));
strain(1) = gauge1(1);

% Calculate average rate of change of strain gauge data over first 10% of data
n_start = round(length(gauge1)*0.1);
slope_start = mean(diff(gauge1(1:n_start))./diff(lasdisp(1:n_start)));

for i = 2:length(force)
    % Check whether to switch to using laser displacement data to calculate strain
    if i > n_start && i < length(gauge1)*0.9
        slope_i = mean(diff(gauge1(i-n_start:i))./diff(lasdisp(i-n_start:i)));
        if abs(slope_i - slope_start) > 0.05 * abs(slope_start)
            % If the strain gauge has broken, use laser displacement data to calculate the strain
            strain(i) = strain(i-1) + (lasdisp(i)-lasdisp(i-1))/lasdisp(i-1);
            continue
        end
    end
    
    % Otherwise, use the strain gauge data to calculate the strain
    strain(i) = abs(gauge1(i));
    dx = abs(gauge1(i));
    dy = abs(gauge2(i));
    linestress = stress(i); % for calculating the stress before yeilding
end

% find the poisson ratio
poisson = dx ./ dy;
avg_poison = mean(poisson);
disp('Poisson Ratio of speciment');
disp(avg_poison);

% find the Young's mododulus
E = linestress ./dx;
E_avg = mean(E);
disp('Young modulus of speciment');
disp(E_avg);

% plot stress and strain
plot(strain,stress)
xlabel('Strain');
ylabel('Stress');
title('Stress-Strain Curve for Specimen 1');
