Fs = 196000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 196;             % Length of signal
t = (0:L-1)*T;        % Time vector
datapointImport=load('datapoint9.mat');
datapointInterest = datapointImport.datapoint(1:end-1);
fftSignal = fft(datapointImport.datapoint);
P2 = abs(fftSignal/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
spectrum = Fs*(0:(L/2))/L;
plot(spectrum,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')