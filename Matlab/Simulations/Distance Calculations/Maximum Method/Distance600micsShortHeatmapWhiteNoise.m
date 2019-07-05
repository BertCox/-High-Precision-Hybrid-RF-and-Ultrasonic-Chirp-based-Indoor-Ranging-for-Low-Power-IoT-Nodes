%parameters
Ta = 0.001; % Awake time of the mobile node
StartAwakeTime = 0.012; % #ms awake after start playing audio. 29 * 340 = 9.86
NumberOfMicrophones = 600;
SNR = 3; %Addition of white noise (in dB)

ref = audioread('chirp45khz25khz196.wav');
%Read Received Audio signals at mobile node 1 (corner) and 6 (near sound
%source) and transmitted audio
[MIC1ABS001,Fs]= audioread('ABS001_mic_1.wav');

size = length(MIC1ABS001);
tijd = 0:(1/Fs):((size-1)/Fs);

%filter that simulates received audio signal at StartAwakeTime
filter1 = zeros(round(StartAwakeTime*Fs),1);
filter2 = ones(round(Ta*Fs),1);
filter = vertcat(filter1,filter2);
filter3 = zeros(size-length(filter),1);
filter = vertcat(filter,filter3);

%---IDEAL DISTANCES--------------------------------------------------------

IdealDistanceMatrix = zeros(20,30);
for col = 1:30
  for row = 1:20
      IdealDistanceMatrix(row, col) = sqrt(((col-1)*0.1+0.05)^2+((row-1)*0.1+0.1)^2);
  end
end

% %---ABSORPTIONCOEFF=0.05---------------------------------------------------

ABS001 = cell(1,NumberOfMicrophones);
for idx=1:NumberOfMicrophones
filename =['ABS005_MIC',int2str(idx),'.wav'];
ABS001{:,idx}=audioread(filename);
end

ABS001Filtered = cell(1,NumberOfMicrophones);
for i=1:NumberOfMicrophones
    ABS001Filtered(1,i) = {filter .* ABS001{:,i}};
end

ABS001Correlation = cell(1,NumberOfMicrophones);
ABS001Lags = cell(1,NumberOfMicrophones);
for ii=1:NumberOfMicrophones
    [ABS001Corr, ABS001La] = xcorr( ABS001Filtered{:,ii}, ref);
    ABS001Correlation(1,ii) = {ABS001Corr};
    ABS001Lags(1,ii) = {ABS001La};
end

ABS001Maximum = zeros(1,NumberOfMicrophones);
ABS001MaximumIndex = zeros(1,NumberOfMicrophones);
for iii=1:NumberOfMicrophones
    [ABS001Maximum(1,iii),  ABS001MaximumIndex(1,iii)] = max(abs(ABS001Correlation{1,iii}));
end

ABS001Distances = zeros(1,NumberOfMicrophones);
for iiii=1:NumberOfMicrophones
    ABS001Distances(1,iiii) = ABS001Lags{1,iiii}(1,ABS001MaximumIndex(iiii))*340/Fs;
end

%---ABSORPTIONCOEFF=0.3----------------------------------------------------

ABS0301db = cell(1,NumberOfMicrophones);
for idx=1:NumberOfMicrophones
filename =['ABS03_MIC',int2str(idx),'.wav'];
ABS0301db{:,idx}= awgn(audioread(filename),SNR);
end

ABS03Filtered01db = cell(1,NumberOfMicrophones);
for i=1:NumberOfMicrophones
    ABS03Filtered01db(1,i) = {filter .* ABS0301db{:,i}};
end

ABS03Correlation01db = cell(1,NumberOfMicrophones);
ABS03Lags01db = cell(1,NumberOfMicrophones);
for ii=1:NumberOfMicrophones
    [ABS03Corr01db, ABS03La01db] = xcorr( ABS03Filtered01db{:,ii}, ref);
    ABS03Correlation01db(1,ii) = {ABS03Corr01db};
    ABS03Lags01db(1,ii) = {ABS03La01db};
end

ABS03Maximum01db = zeros(1,NumberOfMicrophones);
ABS03MaximumIndex01db = zeros(1,NumberOfMicrophones);
for iii=1:NumberOfMicrophones
    [ABS03Maximum01db(1,iii),  ABS03MaximumIndex01db(1,iii)] = max(abs(ABS03Correlation01db{1,iii}));
end

ABS03Distances01db = zeros(1,NumberOfMicrophones);
for iiii=1:NumberOfMicrophones
    ABS03Distances01db(1,iiii) = ABS03Lags01db{1,iiii}(1,ABS03MaximumIndex01db(iiii))*340/Fs;
end

ABS03DistanceMatrix01db = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS03DistanceMatrix01db(row,:) = ABS03Distances01db(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS03DistanceDifferenceMatrix01db = abs(ABS03DistanceMatrix01db-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS03DistanceDifferenceMatrixFull01db = vertcat(NANarray1,ABS03DistanceDifferenceMatrix01db);
ABS03DistanceDifferenceMatrixFull01db = horzcat(NANarray2,ABS03DistanceDifferenceMatrixFull01db);
figure;
pcolor(ABS03DistanceDifferenceMatrixFull01db);
title('ABS03 SNR=01db')
title(colorbar,'m','FontSize',12);
caxis([0 7.3])

%---ABSORPTIONCOEFF=0.9----------------------------------------------------

ABS09 = cell(1,NumberOfMicrophones);
for idx=1:NumberOfMicrophones
filename =['ABS09_MIC',int2str(idx),'.wav'];
ABS09{:,idx}=audioread(filename);
end

ABS09Filtered = cell(1,NumberOfMicrophones);
for i=1:NumberOfMicrophones
    ABS09Filtered(1,i) = {filter .* ABS09{:,i}};
end

ABS09Correlation = cell(1,NumberOfMicrophones);
ABS09Lags = cell(1,NumberOfMicrophones);
for ii=1:NumberOfMicrophones
    [ABS09Corr, ABS09La] = xcorr( ABS09Filtered{:,ii}, ref);
    ABS09Correlation(1,ii) = {ABS09Corr};
    ABS09Lags(1,ii) = {ABS09La};
end

ABS09Maximum = zeros(1,NumberOfMicrophones);
ABS09MaximumIndex = zeros(1,NumberOfMicrophones);
for iii=1:NumberOfMicrophones
    [ABS09Maximum(1,iii),  ABS09MaximumIndex(1,iii)] = max(abs(ABS09Correlation{1,iii}));
end

ABS09Distances = zeros(1,NumberOfMicrophones);
for iiii=1:NumberOfMicrophones
    ABS09Distances(1,iiii) = ABS09Lags{1,iiii}(1,ABS09MaximumIndex(iiii))*340/Fs;
end

ABS09DistanceMatrix = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS09DistanceMatrix(row,:) = ABS09Distances(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS09DistanceDifferenceMatrix = abs(ABS09DistanceMatrix-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS09DistanceDifferenceMatrixFull = vertcat(NANarray1,ABS09DistanceDifferenceMatrix);
ABS09DistanceDifferenceMatrixFull = horzcat(NANarray2,ABS09DistanceDifferenceMatrixFull);
figure;
pcolor(ABS09DistanceDifferenceMatrixFull);
title('Distance Measurement error (ABS = 0.9)')
xlabel('Horizontal Distance (m)','FontSize',16)
ylabel('Vertical Distance (m)','FontSize',16)
title('Distance Measurement error (ABS = 0.9)','FontSize',16)
title(colorbar,'m','FontSize',12);
caxis([0 7.3])

%---IDEAL DISTANCES--------------------------------------------------------




%---PLOT FIGURE------------------------------------------------------------


% figure;
% plot(IdealDistance, IdealDistance,'-o','color','red');
% title('Influence of the absorptioncoefficients on the distance measurements precision')
% xlabel('Real distance (m)')
% ylabel('Measured distance (m)')
% hold on;
% plot(IdealDistance, ABS001Distances,'-o','color',[.3725 .505 .247]);
% hold on;
% plot(IdealDistance, ABS03Distances,'-o','color',[.95 .79 .02]); 
% hold on;
% plot(IdealDistance, ABS09Distances,'-o','color',[.184 .301 .282]);
% 
% 
