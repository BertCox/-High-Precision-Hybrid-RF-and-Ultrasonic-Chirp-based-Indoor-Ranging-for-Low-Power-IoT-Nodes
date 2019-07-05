%Opening a DAQ-channel
devices = daq.getDevices;
s = daq.createSession('ni');
measuredX = 2.204-1.833;
measuredY = 3.051 - 0.206;
%Adding the 2 channels
addAnalogInputChannel(s,'Dev3',1,'Voltage');
%Changing the rate to 1960000 samples
s.Rate = 196000;
addTriggerConnection(s,'External','Dev3/PFI0','StartTrigger');
s.DurationInSeconds = 0.001;
c = s.Connections(1);
c.TriggerCondition = 'RisingEdge';
[datapoint,time] = s.startForeground;
save datapoint49.mat datapoint;
t = 0:1/196000:0.03;
[ref, Fs] = audioread('filteredWhiteNoise25kHz45kHz.wav');
[Correlation,lag] = xcorr(ref,datapoint);
[MAX, MaxIndex] = max(abs(Correlation));
Distance =  9.86-lag(MaxIndex)*340/196000;
%calculatedDistance = sqrt(measuredX^2 + measuredY^2);  
% figure; 
plot(Correlation);
% figure;
% plot(time,data);
xlabel('Time (secs)');
ylabel('Voltage');