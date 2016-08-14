% %% High Power Auswertung
% 
% highpowerpath = '/Users/Michael/Desktop/HighPower/';%PAutoVolt
% 
% plotall='n';
% voltages=dir2(highpowerpath);
% spannungen=zeros(length(voltages),1);
% for voltage = 1:1 %length(voltages)
%     clearvars ste
%     wlHP = dir2([highpowerpath voltages(voltage).name '/']);
%     steigungen = zeros(length(wlHP),1);
%     steigung_fehler = zeros(length(wlHP),1);
%     wavelength = steigungen;
%     hellig_steigung = zeros(length(wlHP),1);
%     hellig_steigung_fehler = zeros(length(wlHP),1);
%     DATA_Fit=zeros(length(wlHP),100);
%     DATA_INTENS=zeros(length(wlHP),100);
%     DATA_Shutter=zeros(length(wlHP),1);
%     for numMess = 1:length(wlHP)
%         if ~exist([highpowerpath voltages(voltage).name '/'...
%                 wlHP(numMess).name '/auswertung.mat'])
%             display(['Fehler in Datei ' highpowerpath ...
%                 voltages(voltage).name '/' wlHP(numMess).name '/auswertung.mat'])
%         else
%         load([highpowerpath voltages(voltage).name '/'...
%             wlHP(numMess).name '/auswertung.mat'])
%         
%         DATA_Fit(numMess,1:length(fit))=fit;
%         DATA_INTENS(numMess,1:length(isorted))=isorted;
%         DATA_Shutter(numMess)=str2double(shutter);
%         if exist('slope_hellig')
%             hellig_steigung(numMess) = slope_hellig(1);
%         else
%             hellig_steigung(numMess) = NaN;
%         end
%         %         if plotall=='y'
% %fit = exp(slope(1) * log(isorted) + slope(2));
% %figure;
% %loglog(isorted,esorted,'x');
% %xlabel('Intensität [uW]');
% %ylabel('# Elektronen / sec');
% %title([wellenlaenge ' Elektronen']);
% %hold on
% %plot(isorted,fit,'-')
% %hold off
% %legend('Daten',['Fit mit Steigung ' num2str(round(slope(1),2))...
% %' ohne die ersten ' num2str(anfangFFit-1) ' Werte'],'Location','northwest')
% % end
%        
%         steigungen(numMess) = slope(1);
%         if exist('ste')
%             steigung_fehler(numMess) = ste(1);
%         else
%             steigung_fehler(numMess) = 0;
%             display(['Kein Steigungs-Fehler in Datei '...
%                 highpowerpath voltages(voltage).name '/' wlHP(numMess).name])
%         end
%         wl = regexp(wlHP(numMess).name, '_', 'split');
%         wavelength(numMess) = str2double(regexprep(wl(2),'nm',''));
%         end
%     end
%     
%     temp = str2double(regexp(voltages(voltage).name, 'V', 'split'));
%     spannungen(voltage) = temp(1); %regexprep(voltages(voltage).name,'V',''));
%     [wavelength_s,b] = sort(wavelength);
%     steigungen_s = steigungen(b);
%     steigung_fehler_s = steigung_fehler(b);
%     ph_energy = 1.24./(wavelength_s/1000.0);
%     load('Steigung_alt.mat')
%     DATA_INTENS_s=DATA_INTENS(b,:);
%     DATA_Fit_s=DATA_Fit(b,:);
% 
%     
   
    load('/Users/Michael/Desktop/faecher.mat')
    wellenlaengen_ges=zeros(length(wavelength_s)+length(WL_alt),1);
    wellenlaengen_ges(1:length(wavelength_s))=wavelength_s;
    wellenlaengen_ges(length(wavelength_s)+1:end)=WL_alt;
    figure(2);
    color_map=[squeeze(spectrumRGB(wavelength_s)); squeeze(spectrumRGB(WL_alt))];

    I=min(wellenlaengen_ges):max(wellenlaengen_ges);
    Colors = squeeze(spectrumRGB(I));
    NoColors = length(Colors);
    
    Ireduced = (I-min(I))/(max(I)-min(I))*(NoColors-1)+1;
    
    RGB = interp1(1:NoColors,Colors,Ireduced);
    
    set(gcf,'DefaultAxesColorOrder',RGB)
    set(gca, 'ColorOrder', color_map, 'NextPlot', 'replacechildren');
    loglog(DATA_INTENS_s',exp(bsxfun(@times,log(DATA_INTENS_s),steigungen_s))','-','LineWidth',2)
    hold on
    loglog(70:100:750,exp(bsxfun(@times,log(70:100:750),Steigung_alt))','-','LineWidth',2)
    hold off
    colormap(RGB);
    %legend(num2str(wellenlaengen_ges))
    colorbar
    caxis([min(wellenlaengen_ges),max(wellenlaengen_ges)])

    
    xlabel('Laserintensität [µW]')
    ylabel('Elektronenrate [#/s]')

    
    
    %export_fig(gcf,'-pdf','Faecher');
    
%     loglog(wavelength_s,hellig_steigung(b),'o-')
% end
