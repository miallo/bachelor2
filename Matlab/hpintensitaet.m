%% Ordner Einlesen
clear;
%close all;

pfad = '/Users/Michael/Desktop/HighPower/';
ordner = dir2(pfad);

%% Auswertung
tic
for var=1:length(ordner)
    path = [pfad ordner(var).name '/'];
    messungen = dir2(path);
    ROI = [420 420 40 100];
    % ROI = [480 640 0 0];
    ref_path = '/Users/Michael/Desktop/#046_Referenzbilder_200ms/';
    
    % [logfile mess_num] = get_log_mess_num(path);
    logfile = [path 'messlog.txt'];
    deadpx = region_of_interest(ROI, [480,640]);
    [bg, deadpx] = calc_bg_and_deadpx(ref_path, deadpx);
    % Anzeige von verschiedenen Sachen (y=true, n=false)
    live_view = 'n';
    
    titleXaxis = 'Intensität [uW]'; titleYaxis = '# Elektronen / sec';
    
    
    thresh=12;          % Threshhold für Rauschen im Bild
    ges_hellig = [];
    ges_elec = [];
    einzel_elec = zeros(length(messungen),20);
    einzel_int = zeros(length(messungen),1);
    messungen = dir2(path);
    elecs = zeros(length(messungen),1);
    helligkeit = zeros(length(messungen),1);
    intensity = zeros(length(messungen),1);
    for l=1:(length(messungen))
        file_list = dir2([path messungen(l).name]);
        num_elcs=0;
        helligkeit2=zeros(length(file_list),1);
        for k=1:(length(file_list))
            
            num_pcs = size(file_list,1)-2;
            %erate = zeros(num_pcs,1);
            
            I = double(imread([path messungen(l).name '/' file_list(k).name]));
            I = (I-bg).*deadpx;
            [elocs,helligkeit2(k)] = find_electrons(I, thresh);
            %erate(ceil(k)) = erate(ceil(k)) + size(elocs,1);
            %display(['Bild ' num2str(k) ' von ' num2str(num_pcs) ' # Elektronen: ' num2str(size(elocs,1)) ' Messungen ' num2str(l) ' von ' num2str(length(messungen))])
            num_elcs = num_elcs + size(elocs,1);
            
            einzel_elec(l,k) = size(elocs,1) * 1000.0;
            
            if live_view == 'y' && mod(k-1,32) == 0
                imagesc(I); hold on
                plot(elocs(:,1), elocs(:,2), 'ro')
                drawnow
                pause(0.1)
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
        display([intensitaet 'µW   ' shutter 'ms   Elektronen/sec:' num2str(elecs(l))])
    end
    
    [isorted, Inte] = sort(intensity);
    esorted = elecs(Inte);
    
    s = regexp(path, '/', 'split');
    wellenlaenge = s(end-1);
    wellenlaenge=regexprep(wellenlaenge,'Intensitaet_','');
    
    anfangFFit=10; % 18;
    endFFit=0; % 18*3;
    [slope,~] = polyfit(log(isorted(anfangFFit:end-endFFit)),log(esorted(anfangFFit:end-endFFit)),1);
    
    save([path 'auswertung']);
    
end
toc
%% Plot
einzel = 'n';

%[slope,c] = polyfit(log(isorted),log(esorted),1);
% anfangFFit=10;
% [slope,c] = polyfit(log(isorted(anfangFFit:end)),log(esorted(anfangFFit:end)),1);


fit = exp(slope(1) * log(isorted) + slope(2));


% figure;
% loglog(intensity,helligkeit,'x');
% xlabel('Intensität [uW]');
% ylabel('Helligkeit / sec');
% title([wellenlaenge ' Helligkeit']);

figure;
loglog(isorted,esorted,'x');
xlabel('Intensität [uW]');
ylabel('# Elektronen / sec');
title([wellenlaenge ' Elektronen']);
hold on
plot(isorted,fit,'-')
hold off
% hold on
% plot(isorted,fun4(A,isorted.*weights))
% hold off
display(['Steigung ' num2str(slope(1))])
legend('Daten',['Fit mit Steigung ' num2str(round(slope(1),2)) ' ohne die ersten ' num2str(anfangFFit-1) ' Werte'],'Location','northwest')
% hold on
% plot(isorted,F(x,isorted))
% hold off

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