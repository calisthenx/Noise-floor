
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
% Umrechnung, qzfm: % 1au = 1709.0257675082753pT;
% Umrechnung, QTFM: % 1au = 0.006295443685725651pT;
% #######################

clear all

% embed paths
folder = pwd; %Identify local folder
addpath([folder,'\data']);

% Set Parameter (for psd)
rec_time = 60; %[s]

% % ##### Read Data #####
% open .mat-file
load('2022-03-04_qzfm_analog_noisefloor.mat')
x=double(time_data_stack(1,:))/1e3; % make sure that time unit is in [s]
% x=linspace(1,30,length(analog_in_1_stack(1,:)));
y=analog_in_1_stack(1,:);
% y=analog_in_0_stack(1,:);

% Calibration of magnetic field (regarding digital output)
% y=y*10.75909648611139;
y=y*306.9525;
% ######################

% V --> pT (QZFM)
% also consider data-integration: 1/'number of integration (noi)'
% noi = 1;
% y=abs(y)/8.1e-3/noi; % [0.33x]: 1V=8.1e-3V/pT, [1x]: 1V=2.7e-3V/pT

% % V --> pT (QTFM)
% % also consider data-integration: 1/'number of integration (noi)'
% noi = 1;
% g = 1; % Gain factor, max gain = 1, min gain = 16
% y=y/(2.66252105615*2^g)/noi;

% Sampling rate
N = numel(x); % sample number/Signal length
% T = max(abs(x)); % Time_period
fs = 1000; % Sample rate

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


% fft/psd-function
bin=5;
[Fplot,w,psd,wn] = fftpsd_fct(y, fs, bin);
sqrt_psd = sqrt(psd);

% #######################
% Signal plot
% #######################
figure
plot(x, y, 'LineWidth', 1)
title({'Signal'},'FontWeight','bold','FontSize',11);
xlabel('Time [s]','FontWeight','bold','FontSize',12)
ylabel('Amplitude [pT]','FontWeight','bold','FontSize',12)
legend('20220204 noise QTFM', 'off')

% #######################
% fft plot
% #######################
figure
semilogy(w,Fplot, 'LineWidth', 1) % plot fft
title('FFT','FontWeight','bold','FontSize',11);
xlabel('Frequency [Hz]','FontWeight','bold','FontSize',12)
ylabel('Sensitivity [pT]','FontWeight','bold','FontSize',12)
% legend('20220106 noise qzfm', 'off')
% axis([0 100 1e-4 1e3])


% #######################
% psd plot
% #######################
% figure % psd
% semilogy(wn,psd, 'LineWidth', 1.5)
% title('Noise Floor / PSD','FontWeight','bold','FontSize',11);
% xlabel('Frequency [Hz]','FontWeight','bold','FontSize',12)
% ylabel('Sensitivity [pT]','FontWeight','bold','FontSize',12)
% axis([0 100 1e-4 1e3])

% #######################
% sqrt(psd) plot
% #######################
figure % psd
semilogy(wn,sqrt(psd), 'LineWidth', 1.5)
title('PSD','FontWeight','bold','FontSize',11);
xlabel('Frequency [Hz]','FontWeight','bold','FontSize',12)
ylabel('Sensitivity [pT/\sqrt{Hz}]','FontWeight','bold','FontSize',12)
% axis([0 100 1e-4 1e3])



