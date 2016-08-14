%% High Power Auswertung

highpowerpath = '/Users/Michael/Desktop/HighPower/';%PAutoVolt

plotall='n';
voltages=dir2(highpowerpath);
spannungen=zeros(length(voltages),1);
for voltage = 1:1 %length(voltages)
    clearvars ste
    wlHP = dir2([highpowerpath voltages(voltage).name '/']);
    steigungen = zeros(length(wlHP),1);
    steigung_fehler = zeros(length(wlHP),1);
    wavelength = steigungen;
    elek400=zeros(length(wlHP),1);
    hellig_steigung = zeros(length(wlHP),1);
    hellig_steigung_fehler = zeros(length(wlHP),1);
    
    for numMess = 1:length(wlHP)
        if ~exist([highpowerpath voltages(voltage).name '/' wlHP(numMess).name '/auswertung.mat'])
            display(['Fehler in Datei ' highpowerpath voltages(voltage).name '/' wlHP(numMess).name '/auswertung.mat'])
        else
        load([highpowerpath voltages(voltage).name '/' wlHP(numMess).name '/auswertung.mat'])
        elek400(numMess)=exp(slope(1)*log(400)+slope(2));
        
        if exist('slope_hellig')
            hellig_steigung(numMess) = slope_hellig(1);
        else
            hellig_steigung(numMess) = NaN;
        end
        %         if plotall=='y'
%             fit = exp(slope(1) * log(isorted) + slope(2));
%             figure;
%             loglog(isorted,esorted,'x');
%             xlabel('Intensität [uW]');
%             ylabel('# Elektronen / sec');
%             title([wellenlaenge ' Elektronen']);
%             hold on
%             plot(isorted,fit,'-')
%             hold off
%             legend('Daten',['Fit mit Steigung ' num2str(round(slope(1),2))...
%                   ' ohne die ersten ' num2str(anfangFFit-1) ' Werte'],'Location','northwest')
%         end
       
        steigungen(numMess) = slope(1);
        if exist('ste')
            steigung_fehler(numMess) = ste(1);
        else
            steigung_fehler(numMess) = 0;
            display(['Kein Steigungs-Fehler in Datei ' highpowerpath voltages(voltage).name '/' wlHP(numMess).name])
        end
        wl = regexp(wlHP(numMess).name, '_', 'split');
        if length(wl)==1
            wavelength(numMess) = 580; %wlHP(numMess).name(end-2:end);
        else
            wavelength(numMess) = str2double(regexprep(wl(2),'nm',''));
        end
        end
    end
    
    temp = str2double(regexp(voltages(voltage).name, 'V', 'split'));
    spannungen(voltage) = temp(1); %regexprep(voltages(voltage).name,'V',''));
    [wavelength_s,b] = sort(wavelength);
    steigungen_s = steigungen(b);
    steigung_fehler_s = steigung_fehler(b);
    ph_energy = 1.24./(wavelength_s/1000.0);
    figure(1);
    errorbar(wavelength_s, steigungen_s, max(0.1,steigung_fehler_s), 'o-');
    % spannungen falls gegen angelegte Spannung        errorbar(ph_,steig,,steigung_fehler(b),'o-')
    xlabel('Wellenlänge [nm]')
    ylabel('Nichtlinearität')
    %export_fig(gcf,'-pdf','nichtlinearitaet');
    
    figure(2);
    plot(wavelength_s,ph_energy.*steigungen_s,'o-')
    xlabel('Wellenlänge [nm]')
    ylabel('Gesamtenergie [eV]')
    %export_fig(gcf,'-pdf','ges_Energie');
    
%     loglog(wavelength_s,hellig_steigung(b),'o-')
end
%xlabel('Spannung an Tip und Suppressor [V]')    


clearvars -except wavelength_s steigungen_s steigung_fehler_s spannungen ph_energy highpowerpath
save([highpowerpath 'auswertung']);


% legend(num2str(spannungen(b)))

% ax = get(fig,'CurrentAxes');
% set(ax,'XScale','log','YScale','log')
%legend(['U_T_i_p=U_S_u_p=' voltages(1).name],voltages(2).name,voltages(3).name,voltages(4).name,'Location','northwest')

%legend(voltages.name,'Location','northwest')
