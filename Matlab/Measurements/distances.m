t = 0:1/196000:0.03;
referentie = ((chirp(t,45000,0.03,25000)').*2.5)+2.5;
[Correlation,lag] = xcorr(data,ref);
[MAX, MaxIndex] = max(abs(Correlation));
Distance = lag(MaxIndex)*340/Fs;

%parameters
Ta = 0.001; % Awake time of the mobile node
StartAwakeTime = 0.029; % #ms awake after start playing audio. 29 * 340 = 9.86

%Read Received Audio signals at mobile node 1 (corner) and 6 (near sound
%source) and transmitted audio
[MIC1ABS001,Fs]= audioread('ABS001_mic_1.wav');
MIC2ABS001 = audioread('ABS001_mic_2.wav');
MIC3ABS001 = audioread('ABS001_mic_3.wav');

MIC1ABS03= audioread('ABS03_mic_1.wav');
MIC2ABS03 = audioread('ABS03_mic_2.wav');
MIC3ABS03 = audioread('ABS03_mic_3.wav');

MIC1ABS09= audioread('ABS09_mic_1.wav');
MIC2ABS09 = audioread('ABS09_mic_2.wav');
MIC3ABS09 = audioread('ABS09_mic_3.wav');

ref = audioread('chirp45khz25khz196.wav');

size = length(MIC1ABS001);
tijd = 0:(1/Fs):((size-1)/Fs);

%filter that simulates received audio signal at StartAwakeTime
filter1 = zeros(round(StartAwakeTime*Fs),1);
filter2 = ones(round(Ta*Fs),1);
filter = vertcat(filter1,filter2);
filter3 = zeros(size-length(filter),1);
filter = vertcat(filter,filter3);

%filter the audio data
MIC1ABS001Filtered = filter .* MIC1ABS001;
MIC2ABS001Filtered = filter .* MIC2ABS001;
MIC3ABS001Filtered = filter .* MIC3ABS001;

MIC1ABS03Filtered = filter .* MIC1ABS03;
MIC2ABS03Filtered = filter .* MIC2ABS03;
MIC3ABS03Filtered = filter .* MIC3ABS03;

MIC1ABS09Filtered = filter .* MIC1ABS09;
MIC2ABS09Filtered = filter .* MIC2ABS09;
MIC3ABS09Filtered = filter .* MIC3ABS09;

%Correlation calculations of filtered audio and transmitted audio
[CORRMIC1ABS001,lag1ABS001] = xcorr(MIC1ABS001Filtered,ref);
[CORRMIC2ABS001,lag2ABS001] = xcorr(MIC2ABS001Filtered,ref);
[CORRMIC3ABS001,lag3ABS001] = xcorr(MIC3ABS001Filtered,ref);

[CORRMIC1ABS03,lag1ABS03] = xcorr(MIC1ABS03Filtered,ref);
[CORRMIC2ABS03,lag2ABS03] = xcorr(MIC2ABS03Filtered,ref);
[CORRMIC3ABS03,lag3ABS03] = xcorr(MIC3ABS03Filtered,ref);

[CORRMIC1ABS09,lag1ABS09] = xcorr(MIC1ABS09Filtered,ref);
[CORRMIC2ABS09,lag2ABS09] = xcorr(MIC2ABS09Filtered,ref);
[CORRMIC3ABS09,lag3ABS09] = xcorr(MIC3ABS09Filtered,ref);

%Index of Maximum calculations

[MAX1ABS001, MAXindex1ABS001] = max(abs(CORRMIC1ABS001));
[MAX2ABS001, MAXindex2ABS001] = max(abs(CORRMIC2ABS001));
[MAX3ABS001, MAXindex3ABS001] = max(abs(CORRMIC3ABS001));

[MAX1ABS03, MAXindex1ABS03] = max(abs(CORRMIC1ABS03));
[MAX2ABS03, MAXindex2ABS03] = max(abs(CORRMIC2ABS03));
[MAX3ABS03, MAXindex3ABS03] = max(abs(CORRMIC3ABS03));

[MAX1ABS09, MAXindex1ABS09] = max(abs(CORRMIC1ABS09));
[MAX2ABS09, MAXindex2ABS09] = max(abs(CORRMIC2ABS09));
[MAX3ABS09, MAXindex3ABS09] = max(abs(CORRMIC3ABS09));

%Distance calculations

Distance1ABS001 = lag1ABS001(MAXindex1ABS001)*340/Fs;
Distance2ABS001 = lag2ABS001(MAXindex2ABS001)*340/Fs;
Distance3ABS001 = lag3ABS001(MAXindex3ABS001)*340/Fs;

Distance1ABS03 = lag1ABS03(MAXindex1ABS03)*340/Fs;
Distance2ABS03 = lag2ABS03(MAXindex2ABS03)*340/Fs;
Distance3ABS03 = lag3ABS03(MAXindex3ABS03)*340/Fs;

Distance1ABS09 = lag1ABS09(MAXindex1ABS09)*340/Fs;
Distance2ABS09 = lag2ABS09(MAXindex2ABS09)*340/Fs;
Distance3ABS09 = lag3ABS09(MAXindex3ABS09)*340/Fs;



%For plotting: only positive time: limit the lags
CORRMIC1ABS001 = CORRMIC1ABS001(lag1ABS001>0);
lag1ABS001 = lag1ABS001(lag1ABS001>0);
CORRMIC2ABS001 = CORRMIC2ABS001(lag2ABS001>0);
lag2ABS001 = lag2ABS001(lag2ABS001>0);
CORRMIC3ABS001 = CORRMIC3ABS001(lag3ABS001>0);
lag3ABS001 = lag3ABS001(lag3ABS001>0);

CORRMIC1ABS03 = CORRMIC1ABS03(lag1ABS03>0);
lag1ABS03 = lag1ABS03(lag1ABS03>0);
CORRMIC2ABS03 = CORRMIC2ABS03(lag2ABS03>0);
lag2ABS03 = lag2ABS03(lag2ABS03>0);
CORRMIC3ABS03 = CORRMIC3ABS03(lag3ABS03>0);
lag3ABS03 = lag3ABS03(lag3ABS03>0);


CORRMIC1ABS09 = CORRMIC1ABS09(lag1ABS09>0);
lag1ABS09 = lag1ABS09(lag1ABS09>0);
CORRMIC2ABS09 = CORRMIC2ABS09(lag2ABS09>0);
lag2ABS09 = lag2ABS09(lag2ABS09>0);
CORRMIC3ABS09 = CORRMIC3ABS09(lag3ABS09>0);
lag3ABS09 = lag3ABS09(lag3ABS09>0);

%For plotting vertical line: search the maximum index with the negative
%lags removed
[MAX1ABS001, MAXindex1ABS001] = max(abs(CORRMIC1ABS001));
[MAX2ABS001, MAXindex2ABS001] = max(abs(CORRMIC2ABS001));
[MAX3ABS001, MAXindex3ABS001] = max(abs(CORRMIC3ABS001));

[MAX1ABS03, MAXindex1ABS03] = max(abs(CORRMIC1ABS03));
[MAX2ABS03, MAXindex2ABS03] = max(abs(CORRMIC2ABS03));
[MAX3ABS03, MAXindex3ABS03] = max(abs(CORRMIC3ABS03));

[MAX1ABS09, MAXindex1ABS09] = max(abs(CORRMIC1ABS09));
[MAX2ABS09, MAXindex2ABS09] = max(abs(CORRMIC2ABS09));
[MAX3ABS09, MAXindex3ABS09] = max(abs(CORRMIC3ABS09));

c = 1.8;
title(['Temperature is ',num2str(c),' C'])
figure;

subplot(3,3,1)
plot(lag1ABS001/Fs, CORRMIC1ABS001,'color',[.95 .79 .02]);
line([MAXindex1ABS001/Fs MAXindex1ABS001/Fs], [-50 50], 'color', 'red');
xlabel('Lag (s)')
ylabel('Correlation index')
title({'Microphone 1 in high reverberent room.';['Distance estimate = ',num2str(Distance1ABS001),'m']})

subplot(3,3,2)
plot(lag2ABS001/Fs, CORRMIC2ABS001,'color',[.3725 .505 .247]);
line([MAXindex2ABS001/Fs MAXindex2ABS001/Fs], [-100 100], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 2 in high reverberent room.';['Distance estimate = ',num2str(Distance2ABS001),'m']})

subplot(3,3,3)
plot(lag3ABS001/Fs, CORRMIC3ABS001,'color',[.184 .301 .282]);
line([MAXindex3ABS001/Fs MAXindex3ABS001/Fs], [-50 50], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 3 in high reverberent room.';['Distance estimate = ',num2str(Distance3ABS001),'m']})

subplot(3,3,4)
plot(lag1ABS03/Fs, CORRMIC1ABS03, 'color',[.95 .79 .02]);
line([MAXindex1ABS03/Fs MAXindex1ABS03/Fs], [-50 50], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 1 in normal reverberent room.';['Distance estimate = ',num2str(Distance1ABS03),'m']})
%Distance estimate = ',num2str(Distance1ABS001),' m'

subplot(3,3,5)
plot(lag2ABS03/Fs, CORRMIC2ABS03,'color',[.3725 .505 .247]);
line([MAXindex2ABS03/Fs MAXindex2ABS03/Fs], [-100 100], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 2 in normal reverberent room.';['Distance estimate = ',num2str(Distance2ABS03),'m']})

subplot(3,3,6)
plot(lag3ABS03/Fs, CORRMIC3ABS03,'color',[.184 .301 .282]);
line([MAXindex3ABS03/Fs MAXindex3ABS03/Fs], [-50 50], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 3 in normal reverberent room.';['Distance estimate = ',num2str(Distance3ABS03),'m']})


subplot(3,3,7)
plot(lag1ABS09/Fs, CORRMIC1ABS09,'color',[.95 .79 .02]);
line([MAXindex1ABS09/Fs MAXindex1ABS09/Fs], [-50 50], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 1 in low reverberent room.';['Distance estimate = ',num2str(Distance1ABS09),'m']})

subplot(3,3,8)
plot(lag2ABS09/Fs, CORRMIC2ABS09,'color',[.3725 .505 .247]);
line([MAXindex2ABS09/Fs MAXindex2ABS09/Fs], [-100 100], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 2 in low reverberent room.';['Distance estimate = ',num2str(Distance2ABS09),'m']})

subplot(3,3,9)
plot(lag3ABS09/Fs, CORRMIC3ABS09,'color',[.184 .301 .282]);
line([MAXindex3ABS09/Fs MAXindex3ABS09/Fs], [-50 50], 'color', 'red');
xlabel('t (s)')
ylabel('Normalized Received Audio')
title({'Microphone 3 in low reverberent room.';['Distance estimate = ',num2str(Distance3ABS09),'m']})