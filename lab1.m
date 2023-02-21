clear all;
file = readmatrix("specimen2.dat");
specnum = 1;
time = file(:,1);
force = file(:,2);
displace = file(:,3);
lasdisp = file(:,4);
gauge1 = file(:,5);
gause2 = file(:,6);
% right now, I will calculate stress using the initial area, I will add in
% poison ratio later
width = [14.87, 14.85, 14.95, 14.87,15.23];
thick = [3.22, 3.20, 3.10, 3.25, 3.32];
A = width.*thick;

stress = zeros(1,length(force));
strain = zeros(1,length(force));
strain(1) = gauge1(1); 
stress(1) = force(1)/A(specnum);
for i = 2:length(force)
    stress(i) = force(i)/A(specnum);
    if gauge1(i-1) == 0.0217322*10-3
        strain(i) = (lasdisp(i)-lasdisp(i-1))/lasdisp(i);
    else 
        strain(i) = abs(gauge1(i));  
    end
    
    
end

plot(strain,stress)


