%% Ordner Einlesen
clear;
%close all;

path = '/Users/Michael/Desktop/Serienaufnahmen/';
messungen = dir2(path);

%% Auswertung
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

tic
thresh=12;          % Threshhold für Rauschen im Bild
ges_hellig = [];
ges_elec = [];
einzel_int = zeros(length(messungen),1);
messungen = dir2(path);
elecs = zeros(length(messungen),1);
helligkeit = zeros(length(messungen),1);

for l=1:(length(messungen))
    file_list = dir2([path messungen(l).name]);
    num_elcs=0;
    helligkeit2=zeros(length(file_list),1);
    einzel_elec = zeros(length(file_list),1);
    laserint = zeros(length(file_list),1);
    for k=1:(length(file_list))        
        I = double(imread([path messungen(l).name '/' file_list(k).name]));
        I = (I-bg).*deadpx;
        [elocs,helligkeit2(k)] = find_electrons(I, thresh);        
        einzel_elec(k) = size(elocs,1);
        
        [~,intensitaet] = strtok(file_list(k).name,'P');
        intensitaet = strtrim(intensitaet(2:end));
        [intensitaet,~] = strtok(intensitaet,'#');
        laserint(k) = str2double(intensitaet);
        
        if live_view == 'y' && mod(k-1,32) == 0
            imagesc(I); hold on
            plot(elocs(:,1), elocs(:,2), 'ro')
            drawnow
            pause(0.1)
            hold off
        end
    end
    figure;
    plot(einzel_elec);
    hold on
    plot(laserint-mean(laserint));
    hold off
    legend('Elektronen',['Laserint. -' num2str(mean(laserint))])
    drawnow;
end
toc