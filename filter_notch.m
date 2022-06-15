function signal_filted = filter_notch(signal, fs, nfreq, bw)

% N=length(signal);
% t=[0:N-1]/fs;
w=nfreq/(fs/2);
bw=bw/(fs/2);
[num,den]=iirnotch(w,bw);
signal_filted=filtfilt(num,den,signal);