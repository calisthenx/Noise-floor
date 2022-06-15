
% #######################
% Information
% #######################
% make sure, txt files have decimal points and not decimal commas like in excel
% make sure, qzfm txt files have no blank character after last column
% .txt and .mat-files
% Zeitdauer --> Frequenzauflösung
% Zeitauflösung --> Frequenzbandbreite
% 'figure' before each plot to put each graph in separate figure window
% 'figure' only once and 'hold on' before each further graphic if display in the same figure window desired
% Select 'View --> plot browser' if graphical adjustments are desired
% #######################

clear

% embed paths
folder = pwd; %Identify local folder
addpath([folder,'\data']);

% % ##### Read Data #####
% % import .txt-file
filename='2022-04-29_qzfm_2.txt';
delimiterIn = '\t';

data_old = importdata(filename, delimiterIn);
data_matrix(:,1:3) = data_old.data;

% QZFM: define x/y-data
% either directly time data from file or define array and get seconds with
% sample rate
x=data_matrix(:,1);
y=data_matrix(:,2);
% ######################

% Sampling rate
N = numel(x); % sample number/Signal length
T = max(abs(x)); % Time_period
fs=1/(x(2) - x(1)); % sample rate
x=(0:1:length(data_matrix(:,1))-1)'/fs; % recalculation of x array, because time data in file have sometimes errors
%fs = N/T; % Sample rate

% % apply notch filter 1
% nfreq = 16.74;
% bw = 2;
% y = filter_notch(y, fs, nfreq, bw);

% % apply notch filter 2
% nfreq = 50.15;
% bw = 2;
% y = filter_notch(y, fs, nfreq, bw);

% % apply notch filter 3
% nfreq = 40;
% bw = 3;
% y = filter_notch(y, fs, nfreq, bw);

% % apply HP filter
% freq = 1;
% y_lp = filter_LP(y, fs, freq);
% y = mean(y)+y-y_lp; % calc. y_hp

% % apply LP filter
% freq = 100;
% y_lp = filter_LP(y, fs, freq);
% y = y_lp;

bin=5; % for data smoothing of psd

% fft/psd-function
[Fplot,w,psd,wn] = fftpsd_fct(y, fs, bin);
sqrt_psd = sqrt(psd);

% #######################
% Signal plot
% #######################
%hold on
figure % signal
plot(x, y, 'LineWidth', 1)
title({'QZFM MMG Signal'},'FontWeight','bold','FontSize',11);
xlabel('Time [s]','FontWeight','bold','FontSize',12)
ylabel('Amplitude [pT]','FontWeight','bold','FontSize',12)
% %legend('20220204 noise QTFM', 'off')
% % axis([0 200 1e-12 1e-7])
% % set(gca, 'YScale', 'log');
% % set(findall(gcf,'-property','FontSize'),'FontSize',14)
% #######################

% #######################
% FFT plot
% #######################
figure
semilogy(w,Fplot, 'LineWidth', 1) % plot fft
title('FFT','FontWeight','bold','FontSize',11);
xlabel('Frequency [Hz]','FontWeight','bold','FontSize',12)
ylabel('Sensitivity [pT]','FontWeight','bold','FontSize',12)
axis([0 100 1e-4 1e3])
% #######################

% #######################
% psd, smoothed out
% #######################
% semilogy(wn,sqrt_psd, 'LineWidth', 1.5)
% title('PSD','FontWeight','bold','FontSize',11);
% xlabel('Frequency [Hz]','FontWeight','bold','FontSize',12)
% ylabel('Sensitivity [pT]','FontWeight','bold','FontSize',12)
% axis([0 100 1e-4 1e3])
% #######################


% #######################
% psd
% #######################
hold on
%figure
semilogy(wn,sqrt_psd, 'LineWidth', 1.5)
% title('PSD','FontWeight','bold','FontSize',18);
xlabel('Frequency [Hz]','FontWeight','bold','FontSize',18)
ylabel('Sensitivity [pT/\surd{Hz}]','FontWeight','bold','FontSize',18)
set(gca,'FontSize',16) 
axis([0 100 1e-4 1e3])
