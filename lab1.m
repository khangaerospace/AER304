clear all;
file = readmatrix("specimen1.dat");
specnum = 1;
time = file(:,1);
force = file(:,2);
displace = file(:,3);
lasdisp = file(:,4);
gauge1 = file(:,5);
gause2 = file(:,6);
% right now, I will calculate stress using the initial area, I will add in
% poison ratio later
width = [14.87, 14.85, 14.95, 14.87,15.23]; % Define the dimensions of the specimen
thick = [3.22, 3.20, 3.10, 3.25, 3.32];
A = width.*thick;

stress = zeros(1,length(force));
strain = zeros(1,length(force));
strain(1) = gauge1(1); 
stress = force./A(specnum);
for i = 2:length(force) 
    if gauge1(i) > 0.02 && i > 2 % could use a better testing value
        % If the strain gauge is broken, use laser displacement data to calculate the strain
        strain(i) = strain(i-1) + (lasdisp(i)-lasdisp(i-1))/lasdisp(1);
    else
        % Otherwise, use the strain gauge data to calculate the strain
         strain(i) = gauge1(i);
    end
end

plot(strain,stress)
xlabel('Strain');
ylabel('Stress');
title('Stress-Strain Curve for Specimen 1');


