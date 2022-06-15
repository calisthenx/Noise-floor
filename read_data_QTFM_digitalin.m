
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
filename='QTFA-06V_6.txt';
delimiterIn = '\t';

data_old = importdata(filename, delimiterIn);

data_matrix(:,1) = data_old.data;

% % QTM: define x/y-data
y=data_matrix(:,1);
x=(0:1:length(data_matrix(:,1))-1)';
% ######################

% Sampling rate
N = numel(x); % sample number/Signal length
% T = N/203.439; % max(abs(x)); % Time_period
fs = 406.9; % 203.439; % Sample rate
x = x /406.9;

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

bin=5;
% fft/psd-function
% [Fplot,w,psd,wn] = fftpsd_fct(y, fs, bin);

[Fplot,w,psd,wn] = fftpsd_fct(y, fs, bin);
sqrt_psd = sqrt(psd);

% % ####### Calculate SignalNoiseRatio #######
% Mean signal (40 largest peaks below 20Hz)
idx=find(wn < 20);
idx=idx(end);
pks = sqrt_psd(1:idx);
pks2 = maxk(pks,30);
pks_mean = mean(pks2);
% Mean Noise (average noise above 60Hz)
idx=find(wn > 70);
idx=idx(1);
noise = sqrt_psd(idx:end);
noise_mean = mean(noise);
SNR = pks_mean/noise_mean;

X = sprintf('SNR = %d',SNR);
disp(X);
% % ###########################################



% #######################
% Signal
% #######################
% hold on
figure % signal
plot(x, y, 'LineWidth', 1)
title({'QTFM Signal'},'FontWeight','bold','FontSize',11);
xlabel('Time [s]','FontWeight','bold','FontSize',12)
ylabel('Amplitude [nT]','FontWeight','bold','FontSize',12)
% legend('20220204 QTFM', 'off')

% #######################
% fft
% #######################
figure
semilogy(w,1e3*Fplot, 'LineWidth', 1) % plot fft
title('FFT','FontWeight','bold','FontSize',11);
xlabel('Frequency [Hz]','FontWeight','bold','FontSize',12)
ylabel('Sensitivity [nT]','FontWeight','bold','FontSize',12)
hold on
% legend('20220106 noise qzfm', 'off')
% axis([0 100 1e-4 1e3])

% #######################
%  psd
% #######################
hold on
%figure
semilogy(wn,1e3*sqrt_psd, 'LineWidth', 1.5) % unit conversion factor 1e3: nT --> pT
title('PSD','FontWeight','bold','FontSize',11);
xlabel('Frequency [Hz]','FontWeight','bold','FontSize',12)
ylabel('Sensitivity [pT/\surd{Hz}]','FontWeight','bold','FontSize',12)
% axis([0 100 1e-2 1e3])
