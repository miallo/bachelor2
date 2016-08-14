% Programm konstanten.m
%*******************************************************
% m-File zum Laden von physikalischen Parametern und Konstanten 
% in die Arbeitsumgebung


c = 2.99792458e8;       % Lichtgeschwindigkeit in m/s
q = 1.60217649e-19;     % Elementarladung in Amperesekunden
eV = q;	               % 1 eV = {q}J = 1.60217653e-19 J 
h_J = 6.6260693e-34;    % Plancksche Konstante in Js
h = h_J/eV;             % Plancksche Konstante in eVs
hquer = h/(2*pi);       % Plancksche Konstante geteilt durch 2*pi in eVs
kBJ = 1.3806505e-23;    % Boltzmann-Konstante in J/K
kB = kBJ/eV;            % Boltzmann-Konstante in eV/K
kT = kB * 300;          % Energie entsprechend 300 K in eV 
					         % (oder "Temperaturspannung" entsprechend 300 K in Volt)
m0 = 9.1093826e-31;     % Ruhemasse des freien Elektrons in kg
m_prot = 1.67262171e-27; % Ruhemasse des Protons in kg
m_neutr = 1.67492716e-27;  % Ruhemasse des Neutrons
eps0 = 8.854187817e-12; % Elektrische Feldkonstante in As/Vm (exakt)
                        % (Dielektrizitätskonstante des Vakuums)
my0 = 4*pi*1e-7;        % Magnetische Feldkonstante in Vs/Am (exakt)
K_Coul = 1/4/pi/eps0;   % Konstante im Coulomb'schen Gesetz in Nm^2/C^2
EH = 13.605692;         % Bindungsenergie des Elektrons am Wasserstoff in eV
aB0 = 5.2917722e-11;    % Radius der ersten Bohrschen Bahn am Wasserstoff in m
NAvo = 6.0221415e23;    % Avogadro-Konstante in 1/mol
                        % in m/s^2
Gravk = 6.673e-11;      % Gravitationskonstante in m^3 kg-1s-2
g_fall = 9.81;          % mittlere Fallbeschleunigung auf der Erdoberfläche
RErde = 6.37e6;         % Erdradius in m
MErde = 5.977e24;       % Masse der Erde in kg
R_id = kBJ*NAvo;        % Allgemeine Gaskonstante des idealen Gases in J/(mol*K)
sigmaSB = 2* pi^5 * kBJ^4/15/h_J^3/c^2;
                        % Stefan-Boltzmann'sche Konstante in W/(m^2*K^4)
b_lambda = 2.89777e-3;  % Maximum der Strahlungsenergie (Konstante des Wíen'schen
                        % Verschiebungsgesetzes) in m*K
lambda_c = 2.426319215e-12; % Compton-Wellenlaenge des Elektrons in m 

