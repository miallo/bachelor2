%% Spannungen Auswertung

spannungenpath = '/Users/Michael/Desktop/480nm_Voltscan_Apex/';%PAutoVolt


plotall='n';
neuBerechnen='n';
voltages=dir2(spannungenpath);
fig = figure;
steigungen = zeros(length(voltages),3);
steigung_fehler = zeros(length(voltages),3);

spannungen=zeros(length(voltages),1);
for voltage = 1:length(voltages)
    clearvars ste
    shutterZeit = dir2([spannungenpath voltages(voltage).name '/']);
    wavelength = steigungen;
    elek400=zeros(length(shutterZeit),1);
    for numMess = 1 %:length(shutterZeit)    % 1:100ms  2:10ms  3:200ms
        if ~exist([spannungenpath voltages(voltage).name '/' shutterZeit(numMess).name '/auswertung.mat'])
            display(['Fehler in Datei ' spannungenpath ...
                voltages(voltage).name '/' shutterZeit(numMess).name '/auswertung.mat'])
        end
        load([spannungenpath voltages(voltage).name '/' shutterZeit(numMess).name '/auswertung.mat'])
        elek400(numMess)=exp(slope(1)*log(400)+slope(2));

        
        steigungen(voltage,numMess) = slope(1);
        if exist('ste')
            steigung_fehler(voltage, numMess) = ste(1);
        else
            steigung_fehler(voltage, numMess) = 0.1;
        end
        wl = regexp(shutterZeit(numMess).name, '_', 'split');
%         if length(wl)==1
%             wavelength(numMess) = 580; %wlHP(numMess).name(end-2:end);
%         else
        wavelength(numMess) = str2double(regexprep(wl(2),'nm',''));
%        end
    end
    
    temp = str2double(regexp(voltages(voltage).name, 'V', 'split'));
    spannungen(voltage) = temp(1); %regexprep(voltages(voltage).name,'V',''));
    %clearvars temp;
    %[wavelength_s,b] = sort(wavelength);
    %ph_energy=1.24./(wavelength_s/1000.0);
end
%xlabel('Spannung an Tip und Suppressor [V]')    
plot(spannungen, steigungen(:,1), 'o') % spannungen falls gegen angelegte
% Spannung  errorbar(ph_,steig,,steigung_fehler(b),'o-')
xlabel('Spannungen U_T_i_p & U_S_u_p [V]')

ylabel('Steigung in Intensitätsplot')
