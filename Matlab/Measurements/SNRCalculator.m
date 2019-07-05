Fs = 196000;
t = 0:1/Fs:0.03;
ref = chirp(t,25000,0.03,45000);

actualDistance = 0.8006;
sampleNumber = round(actualDistance*196000/340);
chirpPart=ref(sampleNumber:(sampleNumber+196));
datapointImport=load('datapoint9.mat');
figure;
subplot(2,1,1)
plot(datapointImport.datapoint)
title('Measured data');
subplot(2,1,2)
plot(chirpPart);
title('Corresponding chirp part');
SNRCalculated = snr(datapointImport.datapoint);
SNRCalculated2 = snr(datapointImport.datapoint, Fs);
