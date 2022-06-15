function signal_LPF = filter_LP(signal, fs, freq)

% N=length(signal);
% t=[0:N-1]/fs;
w=freq/(fs/2);
[num,den]=butter(4,w);
signal_LPF=filtfilt(num,den,signal);