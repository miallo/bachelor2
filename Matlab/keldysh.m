phi = 4.8*eV;
leist = 750e-6/100000/200e-15/(16e-6)^2;
omega = 2*pi*c/800e-9;
k = 6.4;
E = sqrt(leist/eps0/c)*k;
Up = eV^2*E^2/(4*m0*omega^2);
gamma = sqrt(phi/(2*Up));

display(['Gamma_min = ' num2str(gamma)])

phi_max = 5.6*eV;
leist_max = 50e-6/100000/200e-15/(16e-6)^2;
omega_max = 2*pi*c/460e-9;
E_max = sqrt(leist_max/eps0/c)*k;
Up_max = eV^2*E^2/(4*m0*omega_max^2);
gamma_max = sqrt(phi_max/(2*Up_max));

display(['Gamma_max = ' num2str(gamma_max)])


r  = 45e-9; %Spitzenradius
U  = 100;   %Spannung
F  = U/k/r; %Elektrisches Feld
dW = sqrt(eV^3*F/(4*pi*eps0)); %Schottky-Reduktion durch DC-Feld
display(['dW = ' num2str(dW/eV) 'eV'])
