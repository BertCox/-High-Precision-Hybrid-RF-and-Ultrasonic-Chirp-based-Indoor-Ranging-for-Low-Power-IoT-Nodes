%parameters
Ta = 0.001; % Awake time of the mobile node
StartAwakeTime = 0.029; % #ms awake after start playing audio. 29 * 340 = 9.86
NumberOfIterations = 10000;
SNR = 6; %Addition of white noise (in dB)

% ReceivedChirp = audioread('ReceivedChirp35khz25khz196.wav');
%  ReceivedChirp = audioread('ReceivedChirp45khz25khz196.wav');
ReceivedChirp = audioread('ReceivedChirp55khz25khz196.wav');
% ReceivedChirp = audioread('ReceivedChirp65khz25khz196.wav');
% ReceivedChirp = audioread('ReceivedChirp75khz25khz196.wav');

% ref = audioread('chirp35khz25khz196.wav');
% ref = audioread('chirp45khz25khz196.wav');
ref = audioread('chirp55khz25khz196.wav');
% ref = audioread('chirp65khz25khz196.wav');
% ref = audioread('chirp75khz25khz196.wav');


size = length(ReceivedChirp);
tijd = 0:(1/Fs):((size-1)/Fs);

%filter that simulates received audio signal at StartAwakeTime
filter1 = zeros(round(StartAwakeTime*Fs),1);
filter2 = ones(round(Ta*Fs),1);
filter = vertcat(filter1,filter2);
filter3 = zeros(size-length(filter),1);
filter = vertcat(filter,filter3);

%--------------------------------------------------------------------------
afstanden35 = zeros(1,NumberOfIterations);
for n = 1:NumberOfIterations 
    
    NoisyReceivedSignal = awgn(ReceivedChirp,SNR);
    NoisyReceivedSignalFiltered = filter .* NoisyReceivedSignal;
    
    [Correlation,lag1] = xcorr(NoisyReceivedSignalFiltered,ref);
    [MAX, MAXindex] = max(abs(Correlation));
    Afstand = lag1(MAXindex)*340/Fs;
        
   afstanden35(n) =   Afstand;
end
 
%Probability distribution

 pd1a = fitdist(afstanden35.','Normal')
 sigma1 = pd1a.sigma;
 mu1 = pd1a.mu;
 pd1b = fitdist(afstanden35.','Kernel','Kernel','epanechnikov')
 
 x_values1 = 1.3:0.001:1.8;
 y1a = pdf(pd1a,x_values1);
 y1b = pdf(pd1b,x_values1);
 
 fig = figure('Name','test');
 
 subplot(1,2,1)
 plot(x_values1,y1a);
 hold on;
 plot( [mu1 - sigma1 mu1 - sigma1],[0 max(y1a)],'--')
 plot( [mu1 + sigma1 mu1 + sigma1],[0 max(y1a)],'--')
 plot( [mu1 mu1],[0 max(y1a)],'--')
 plot( [1.553 1.553],[0 max(y1a)],'--')
 hold off;
 strmu1= ['mu = ', num2str(mu1)];
 strsigma1= ['sigma = ', num2str(sigma1)]; 
 text(1.35,(max(y1a)-1),strmu1);
 text(1.35,(max(y1a)-1.5),strsigma1);
 title('Normal Distribution')
 
 subplot(1,2,2)
 plot(x_values1,y1b);
 hold on;
 plot( [1.553 1.553],[0 max(y1b)],'--')
 hold off;
 title('Epanechikov Kernel Distribution')