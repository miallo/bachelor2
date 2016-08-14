%% Ordner Einlesen
clear;
%close all;
%path = [uigetdir('/Users/Michael/Desktop/16-05-23/16-05-25/',...

path_ohne = [uigetdir('D:\\',...
    'Wähle Datenordner') '\'];
path=[path_ohne '100V_neue_Messung\'];
messungen = dir2(path);

%% Auswertung
rechnen = 'y';
if ~exist([path 'auswertung.mat']) || rechnen == 'y'
    h=waitbar(0,'Initialisiere');
    ROI = [420 420 40 100];
    % ROI = [480 640 0 0];
    ref_path_bg = [path_ohne '#061_Referenzbilder\'];
    ref_path_deadpx = [path_ohne '#046_Referenzbilder_200ms\';

    deadpx2 = region_of_interest(ROI, [480,640]);
    [~, deadpx] = calc_bg_and_deadpx(ref_path_deadpx, deadpx2);
    [bg,~] = calc_bg_and_deadpx(ref_path_bg, deadpx2);
    
    % Anzeige von verschiedenen Sachen (y=true, n=false)
    live_view = 'n';
    
    titleXaxis = 'Intensität [uW]'; titleYaxis = '# Elektronen / sec';
    
    tic
    thresh=12;          % Threshhold für Rauschen im Bild
    thresh_elek_pro_sec=10;   %Unter X Elektronen/sec werden sie nicht im Fit beachtet
    einzel_elec = zeros(length(messungen),20);
    einzel_int = zeros(length(messungen),1);
    messungen = dir2(path);
    elecs = zeros(length(messungen),1);
    helligkeit = zeros(length(messungen),1);
    intensity = zeros(length(messungen),1);
    helligkeit3=zeros(length(messungen),5,20);
    for l=1:(length(messungen))
        waitbar(l/length(messungen),h,[num2str(round(100*l/length(messungen),2)) '% fertig'])
        file_list = dir2([path messungen(l).name]);
        num_elcs=0;
        helligkeit2=zeros(length(file_list),1);

        for k=1:(length(file_list))
            
            num_pcs = size(file_list,1)-2;
            %erate = zeros(num_pcs,1);
            
            I = double(imread([path messungen(l).name '\' file_list(k).name]));
            I = (I-bg).*deadpx;
            [elocs,helligkeit2(k)] = find_electrons(I, thresh);

             
            % erate(ceil(k)) = erate(ceil(k)) + size(elocs,1);
            % display(['Bild ' num2str(k) ' von ' num2str(num_pcs) ... 
            % '# Elektronen: ' num2str(size(elocs,1)) ' Messungen '...
            % num2str(l) ' von ' num2str(length(messungen))])
            num_elcs = num_elcs + size(elocs,1);
            
            einzel_elec(l,k) = size(elocs,1) * 1000.0;
            
            if live_view == 'y' && mod(k-1,10) == 0
                imagesc(I); hold on
                plot(elocs(:,1), elocs(:,2), 'ro','MarkerSize',10)
                drawnow
                pause(1)
                hold off
            end
            
        end
        shutter = file_list(1).name;
        shutter = shutter(1:3);
        shutter = regexprep(shutter,'[m]','');
        einzel_elec(l,:)=einzel_elec(l,:) / str2double(shutter);
        [~,intensitaet] = strtok(file_list(1).name,'P');
        intensitaet = strtrim(intensitaet(2:end));
        [intensitaet,~] = strtok(intensitaet,'#');
        
        helligkeit(l) = sum(helligkeit2)  / (str2double(shutter)/1000);
        elecs(l) = num_elcs / (length(file_list)) / (str2double(shutter)/1000);
        intensity(l) = str2double(intensitaet);
        display([num2str(l) ' von ' num2str(length(messungen)) '     ' intensitaet 'µW'])
    end
    
    [isorted, Inte] = sort(intensity);
    esorted = elecs(Inte);
    
    
    s = regexp(path, '\', 'split');
    wellenlaenge = s(end-1);
    wellenlaenge=regexprep(wellenlaenge,'Intensitaet_','');
    close(h)

    anfangFFit=0; % 6;
    endFFit=0; % 18;
    is_kurz=isorted(1+anfangFFit:end-endFFit);
    es_kurz=esorted(1+anfangFFit:end-endFFit);
    [slope,sdev] = polyfit(log(is_kurz(es_kurz>thresh_elek_pro_sec)),log(es_kurz(es_kurz>thresh_elek_pro_sec)),1);
    ste = sqrt(diag(inv(sdev.R)*inv(sdev.R'))./sdev.normr.^2./sdev.df);
    display(['Elek-Steigung ' num2str(slope(1)) '±' num2str(ste(1))])
    
    clearvars deadpx2 s
    %%%%%%%%%%%% save([path 'auswertung']);
    toc
else
    display('Lade Daten aus File')
    load([path 'auswertung.mat']);
    if ~exist('is_kurz')
        is_kurz = isorted(1+anfangFFit:end-endFFit);
        es_kurz = esorted(1+anfangFFit:end-endFFit);
        thresh_elek_pro_sec=10;
    end
end
%% Plot
einzel = 'n';

%[slope,c] = polyfit(log(isorted),log(esorted),1);
% anfangFFit=10;
% [slope,c] = polyfit(log(isorted(anfangFFit:end)),log(esorted(anfangFFit:end)),1);


fit = exp(slope(1) * log(isorted) + slope(2));
hellig_sort = helligkeit(Inte);
[slope_hellig,~] = polyfit(log(isorted(1:end)),log(hellig_sort(1:end)),1);
fit_hellig = exp(slope_hellig(1) * log(isorted) + slope_hellig(2));
% 
figure;
loglog(isorted,hellig_sort,'x');
xlabel('Intensität [uW]');
ylabel('Helligkeit / sec [a.u.]');
title([strrep(wellenlaenge{1,1},'_',' ') ' Helligkeit']);
hold on
plot(isorted,fit_hellig,'-')
hold off
legend('Helligkeit',['Fit mit Steigung ' num2str(round(slope_hellig(1),2))],'Location','northwest')

figure();
loglog(isorted,esorted,'rx');
xlabel('Intensität [uW]');
ylabel('# Elektronen / sec');
title([strrep(wellenlaenge{1,1},'_',' ') ' Elektronen']);
hold on
plot(is_kurz(es_kurz>thresh_elek_pro_sec), es_kurz(es_kurz>thresh_elek_pro_sec),'bx')
plot(isorted,fit,'-')

% loglog(isorted,hellig_sort/hellig_sort(1),'ro')
% helligkeit3a=mean(helligkeit3,3);
% loglog(intensity,helligkeit3a(:,1)/helligkeit3a(end,1),'go');
% loglog(intensity,helligkeit3a(:,2)/helligkeit3a(end,2),'ko');
% loglog(intensity,helligkeit3a(:,3)/helligkeit3a(end,3),'bo');
% loglog(intensity,helligkeit3a(:,4)/helligkeit3a(end,4),'mo');
% loglog(intensity,helligkeit3a(:,5)/helligkeit3a(end,5),'co');
hold off

if anfangFFit==0
    if endFFit == 0
            legend('Daten ungefittet', 'Daten', ['Fit mit Steigung ' num2str(round(slope(1),2)) '±' num2str(round(ste(1),2))],'Location','northwest')
    else
        legend('Daten ungefittet', 'Daten',sprintf( '%s\n%s', ['Fit mit Steigung ' num2str(round(slope(1),2)) '±' num2str(round(ste(1),2))], ...
            ['ohne die letzten ' num2str(endFFit) ' Werte']),'Location','northwest')
    end
else
    if endFFit == 0
legend('Daten ungefittet', 'Daten',sprintf( '%s\n%s', ['Fit mit Steigung ' num2str(round(slope(1),2)) '±' num2str(round(ste(1),2))], ...
        ['ohne die ersten ' num2str(anfangFFit) ' Werte']),'Location','northwest')
    else
        legend('Daten ungefittet', 'Daten',sprintf( '%s\n%s', ['Fit mit Steigung ' num2str(round(slope(1),2)) '±' num2str(round(ste(1),2))], ...
        ['ohne die ersten ' num2str(anfangFFit) ' und letzten ' num2str(endFFit) ' Werte']),'Location','northwest')
    end
end

export_fig(gcf,'-pdf','elec470nm');

 
display(['Elek-Steigung ' num2str(slope(1)) '±' num2str(ste(1)) ...
    '     Hellig-Steigung ' num2str(slope_hellig(1)) '     Unterschied ' num2str(slope(1)-slope_hellig(1))])


if einzel == 'y'
    figure;
    loglog(intensity,einzel_elec,'.');
    xlabel('Intensität [uW]');
    ylabel('# Elektronen / sec');
    title([wellenlaenge ' Elektronen']);
end


%     figure;
%     loglog(einzel_int,einzel_elec(:,1:end),'x');
%     xlabel('Intensität [uW]');
%     ylabel('Helligkeit / sec');
%     title('840nm Helligkeit');
drawnow

%% Speichern
% a=strsplit(path,'/');
% a=a(end-1);
% clearvars -except isorted esorted slope endFFit anfangFFit a
% save(['/Users/Michael/Desktop/short-' a '.mat']);