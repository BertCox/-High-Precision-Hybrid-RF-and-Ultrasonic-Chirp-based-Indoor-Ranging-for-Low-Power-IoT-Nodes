%Opening a DAQ-channel
devices = daq.getDevices;
s = daq.createSession('ni');
%Adding the 2 channels
addAnalogOutputChannel(s,'Dev1',0,'Voltage');
addAnalogOutputChannel(s,'Dev1',1,'Voltage');
%Changing the rate to 1960000 samples
s.Rate = 196000;
%Changing the DC value to 0V
outputSingleValue0 = 0;
OutputSingleValue1 = 0;
outputSingleScan(s,[outputSingleValue0 OutputSingleValue1]);
%Setting the output signals
t = 0:1/196000:0.03;
datashort0 = ((chirp(t,45000,0.03,25000)').*2.5)+2.5;
datazeroes = zeros((196000-size(datashort0,1)),1);
data0 = vertcat(datashort0, datazeroes);
datashort1 = 5*ones(1,size(datashort0,1))';
data1 = vertcat(datashort1, datazeroes);
% data0(end) = [];
% data1(end) = [];
s.IsContinuous = true;
queueOutputData(s,repmat([data0, data1], 1, 1));
lh = addlistener(s,'DataRequired', @(src,event) src.queueOutputData([data0, data1]));
queueOutputData(s,repmat([data0, data1], 1, 1));
s.startBackground();
