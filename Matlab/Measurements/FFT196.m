function [] = FFT196(samples, chirp)
s = inputname(1);
Fs = 83000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 83;             % Length of signal
time = (0:L-1)*T;        % Time vector
Y = fft(samples);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

FigH = figure('Position', get(0, 'Screensize'));
F    = getframe(FigH);
subplot(2,2,2);
plot(time, samples);
ylabel('Amplitude'); xlabel('Time (secs)');
axis tight;
title('Input Signal');

% Plot frequency spectrum
subplot(2,2,4);
plot(f,P1);
xlabel('f (Hz)');
ylabel('PSD');
grid on;
% Get frequency estimate (spectral peak)
[~,loc] = max(P1(3:end));
FREQ_ESTIMATE = f(loc+2);
title(['Frequency estimate = ',num2str(FREQ_ESTIMATE),' Hz in Single-Sided Amplitude of Spectrum of X(t)']);

[xcorrChirp,time] = xcorr(samples, chirp);
[~,I] = max(abs(xcorrChirp));
subplot(2,2,[1 3]);
plot(xcorrChirp(1:1744))
title(['Single side spectrum of Crosscorrelation. Max @' ,num2str(I)]);

saveas(FigH,s,'png');

end