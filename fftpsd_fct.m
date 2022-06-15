function [Fplot,w,psd,wn]=fftpsd_fct(dataflow, fs, bin)
% fs: sampling frequency, Frequency bandwidth
% bin: point number / number of samples to be averaged in psd calculation

% Fplot: fft magnitude
% psd: power spectrum density

N=length(dataflow); % number of samples
w=(fs/2*linspace(0,1,floor(N/2+1)))'; % Spektrum, Bandbreite = e.g. 900Hz, halbes Spektrum (e.g. 450Hz): N/2 steps gleichverteilt von 0 bis 450Hz
Fdataflow=abs(fft(dataflow,N)); % Fouriertrafo des ganzen Zeitsignals

Fplot=Fdataflow(1:floor(N/2+1)).*2./N; % Normalization and considering of one half of the spectrum; Normalization regarding N: the longer the time, smaller the noise (averaged out)
Fplot(1)=Fplot(1)/2; % remove factor 2 of frequency 0

psd=2*Fdataflow(1:floor(N/2+1)).^2./N./fs; % ^2 delivers power spectrum, then Normalization and considering one half of spectrum. Additionally using fs as normalization gives a 1Hz normalized psd

wn=w;

% ####################
% Smoothing out
% ####################
% P=Fplot.^2;
% NN=length(P);
% M=floor(NN/bin);
% for i=1:M
%     psd(i)=sqrt(sum(P(1+(i-1)*bin:i*bin))/bin); % Mittelung/Glättung der Werte (im jeweiligen bin)
%     wn(i)=w(floor(bin/2)+(i-1)*bin); % Reduzierung der Frequenzauflösung/der Anzahl der Werte im weiterhin gleichbleibenden Frequenzbereich
% end
