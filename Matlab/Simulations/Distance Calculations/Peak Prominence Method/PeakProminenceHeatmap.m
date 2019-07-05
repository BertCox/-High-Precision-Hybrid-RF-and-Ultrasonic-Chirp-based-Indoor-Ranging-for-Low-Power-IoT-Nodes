%parameters
Ta = 0.001; % Awake time of the mobile node
StartAwakeTime = 0.029; % #ms awake after start playing audio. 29 * 340 = 9.86
NumberOfMicrophones = 600;


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

%---ABSORPTIONCOEFF=0.05---------------------------------------------------

ABS005 = cell(1,NumberOfMicrophones);
for idx=1:NumberOfMicrophones
filename =['ABS005_MIC',int2str(idx),'.wav'];
ABS005{:,idx}=audioread(filename);
end

ABS005Filtered = cell(1,NumberOfMicrophones);
for i=1:NumberOfMicrophones
    ABS005Filtered(1,i) = {filter .* ABS005{:,i}};
end

ABS005Correlation = cell(1,NumberOfMicrophones);
ABS005Lags = cell(1,NumberOfMicrophones);
for ii=1:NumberOfMicrophones
    [ABS005Corr, ABS005La] = xcorr( ABS005Filtered{:,ii}, ref);
    ABS005Correlation(1,ii) = {ABS005Corr};
    ABS005Lags(1,ii) = {ABS005La};
end

ABS005Maximum = zeros(1,NumberOfMicrophones);
ABS005MaximumIndex = zeros(1,NumberOfMicrophones);
for iii=1:NumberOfMicrophones
    [ABS005Maximum(1,iii),  ABS005MaximumIndex(1,iii)] = max(abs(ABS005Correlation{1,iii}));
end

ABS005Distances = zeros(1,NumberOfMicrophones);
for iiii=1:NumberOfMicrophones
    ABS005Distances(1,iiii) = ABS005Lags{1,iiii}(1,ABS005MaximumIndex(iiii))*340/Fs;
end

ABS005DistanceMatrix = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS005DistanceMatrix(row,:) = ABS005Distances(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS005DistanceDifferenceMatrix = abs(ABS005DistanceMatrix-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS005DistanceDifferenceMatrixFull = vertcat(NANarray1,ABS005DistanceDifferenceMatrix);
ABS005DistanceDifferenceMatrixFull = horzcat(NANarray2,ABS005DistanceDifferenceMatrixFull);
figure;
h = pcolor(ABS005DistanceDifferenceMatrixFull);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (ABS = 0.05)')
xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
set(gca,'xticklabel',xt);
yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 7.3])


%---Peak Prominence---ABS=0.05----------------------------------------------

NumberOfMeasurementLocations = 600;

ProminencePercent = 0.63;
xPeakProm= (1:11761);
PeakPromABS005Correlation = cell(1,NumberOfMeasurementLocations);
MaximumIndexPeakPromABS005 = zeros(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    PeakPromABS005Correlation(1,aa) = {abs(ABS005Correlation{1, aa})};
    [pks,locs,widths,proms] = findpeaks(PeakPromABS005Correlation{1,aa},xPeakProm,'MinPeakProminence',1,'Annotate','extents', 'MinPeakDistance',300 );
    maxprom = max(proms);
    [pks,locs,widths,proms] = findpeaks(PeakPromABS005Correlation{1,aa},xPeakProm,'MinPeakProminence',maxprom*ProminencePercent,'Annotate','extents', 'MinPeakDistance',300 );
    MaximumIndexPeakPromABS005(1,aa) = locs(1);
end

DistancesPeakPromABS005 = zeros(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    DistancesPeakPromABS005(1,aaaa) = abs(ABS005Lags{1,aaaa}(1,MaximumIndexPeakPromABS005(aaaa))*340/Fs);
end


DistanceMatrixPeakPromABS005 = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    DistanceMatrixPeakPromABS005(row,:) = DistancesPeakPromABS005(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end


ABS005DistanceDifferenceMatrixPeakProm = abs(DistanceMatrixPeakPromABS005-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS005DistanceDifferenceMatrixFullPeakProm = vertcat(NANarray1,ABS005DistanceDifferenceMatrixPeakProm);
ABS005DistanceDifferenceMatrixFullPeakProm = horzcat(NANarray2,ABS005DistanceDifferenceMatrixFullPeakProm);
figure;
h = pcolor(ABS005DistanceDifferenceMatrixFullPeakProm);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('ABS005 Peak Prominence (PP=0.63)')
title(colorbar,'m','FontSize',12);
caxis([0 7.3])
% % xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% % set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% % set(gca,'xticklabel',xt);
% % yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% % set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% % set(gca,'yticklabel',yt);
% title(colorbar,'m','FontSize',12);
% caxis([0 2])

% %---ABSORPTIONCOEFF=0.3----------------------------------------------------
% 
% ABS03 = cell(1,NumberOfMicrophones);
% for idx=1:NumberOfMicrophones
% filename =['ABS03_MIC',int2str(idx),'.wav'];
% ABS03{:,idx}=audioread(filename);
% end
% 
% ABS03Filtered = cell(1,NumberOfMicrophones);
% for i=1:NumberOfMicrophones
%     ABS03Filtered(1,i) = {filter .* ABS03{:,i}};
% end
% 
% ABS03Correlation = cell(1,NumberOfMicrophones);
% ABS03Lags = cell(1,NumberOfMicrophones);
% for ii=1:NumberOfMicrophones
%     [ABS03Corr, ABS03La] = xcorr( ABS03Filtered{:,ii}, ref);
%     ABS03Correlation(1,ii) = {ABS03Corr};
%     ABS03Lags(1,ii) = {ABS03La};
% end
% 
% ABS03Maximum = zeros(1,NumberOfMicrophones);
% ABS03MaximumIndex = zeros(1,NumberOfMicrophones);
% for iii=1:NumberOfMicrophones
%     [ABS03Maximum(1,iii),  ABS03MaximumIndex(1,iii)] = max(abs(ABS03Correlation{1,iii}));
% end
% 
% ABS03Distances = zeros(1,NumberOfMicrophones);
% for iiii=1:NumberOfMicrophones
%     ABS03Distances(1,iiii) = ABS03Lags{1,iiii}(1,ABS03MaximumIndex(iiii))*340/Fs;
% end
% 
% ABS03DistanceMatrix = zeros(20,30);
% row = 1;
% index1 = 1;
% index2 = 30;
% for row=1:20
%     ABS03DistanceMatrix(row,:) = ABS03Distances(index1:index2);
%     index1 = index1 + 30;
%     index2 = index2 + 30;
% end
% 
% ABS03DistanceDifferenceMatrix = abs(ABS03DistanceMatrix-IdealDistanceMatrix);
% NANarray1 = nan(20,30);
% NANarray2 = nan(40,29);
% ABS03DistanceDifferenceMatrixFull = vertcat(NANarray1,ABS03DistanceDifferenceMatrix);
% ABS03DistanceDifferenceMatrixFull = horzcat(NANarray2,ABS03DistanceDifferenceMatrixFull);
% figure;
% h = pcolor(ABS03DistanceDifferenceMatrixFull);
% set(h, 'edgecolor','none')
% xlabel('Horizontal Distance (m)')
% ylabel('Vertical Distance (m)')
% title('Distance measurement error (ABS = 0.3)')
% xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
% set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
% title(colorbar,'m','FontSize',12);
% caxis([0 7.3])
% 
% %---Peak Prominence---ABS=0.3----------------------------------------------
% 
% ProminencePercent = 0.63;
% xPeakProm= (1:11761);
% PeakPromABS03Correlation = cell(1,NumberOfMeasurementLocations);
% MaximumIndexPeakPromABS03 = zeros(1,NumberOfMeasurementLocations);
% for aa=1:NumberOfMeasurementLocations
%     PeakPromABS03Correlation(1,aa) = {abs(ABS03Correlation{1, aa})};
%     [pks,locs,widths,proms] = findpeaks(PeakPromABS03Correlation{1,aa},xPeakProm,'MinPeakProminence',1,'Annotate','extents', 'MinPeakDistance',300 );
%     maxprom = max(proms);
%     [pks,locs,widths,proms] = findpeaks(PeakPromABS03Correlation{1,aa},xPeakProm,'MinPeakProminence',maxprom*ProminencePercent,'Annotate','extents', 'MinPeakDistance',300 );
%     MaximumIndexPeakPromABS03(1,aa) = locs(1);
% end
% 
% DistancesPeakPromABS03 = zeros(1,NumberOfMeasurementLocations);
% for aaaa=1:NumberOfMeasurementLocations
%     DistancesPeakPromABS03(1,aaaa) = abs(ABS03Lags{1,aaaa}(1,MaximumIndexPeakPromABS03(aaaa))*340/Fs);
% end
% 
% 
% DistanceMatrixPeakPromABS03 = zeros(20,30);
% row = 1;
% index1 = 1;
% index2 = 30;
% for row=1:20
%     DistanceMatrixPeakPromABS03(row,:) = DistancesPeakPromABS03(index1:index2);
%     index1 = index1 + 30;
%     index2 = index2 + 30;
% end
% 
% 
% ABS03DistanceDifferenceMatrix = abs(ABS03DistanceMatrix-IdealDistanceMatrix);
% NANarray1 = nan(20,30);
% NANarray2 = nan(40,29);
% ABS03DistanceDifferenceMatrixFull = vertcat(NANarray1,ABS03DistanceDifferenceMatrix);
% ABS03DistanceDifferenceMatrixFull = horzcat(NANarray2,ABS03DistanceDifferenceMatrixFull);
% figure;
% h = pcolor(ABS03DistanceDifferenceMatrixFull);
% set(h, 'edgecolor','none');
% xlabel('Horizontal Distance (m)')
% ylabel('Vertical Distance (m)')
% title('ABS03 Peak Prominence (PP=0.63)')
% title(colorbar,'m','FontSize',12);
% caxis([0 7.3])
% % % xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% % % set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% % % set(gca,'xticklabel',xt);
% % % yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% % % set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% % % set(gca,'yticklabel',yt);
% % title(colorbar,'m','FontSize',12);
% % caxis([0 2])
% 
% %---ABSORPTIONCOEFF=0.9----------------------------------------------------
% 
% ABS09 = cell(1,NumberOfMicrophones);
% for idx=1:NumberOfMicrophones
% filename =['ABS09_MIC',int2str(idx),'.wav'];
% ABS09{:,idx}=audioread(filename);
% end
% 
% ABS09Filtered = cell(1,NumberOfMicrophones);
% for i=1:NumberOfMicrophones
%     ABS09Filtered(1,i) = {filter .* ABS09{:,i}};
% end
% 
% ABS09Correlation = cell(1,NumberOfMicrophones);
% ABS09Lags = cell(1,NumberOfMicrophones);
% for ii=1:NumberOfMicrophones
%     [ABS09Corr, ABS09La] = xcorr( ABS09Filtered{:,ii}, ref);
%     ABS09Correlation(1,ii) = {ABS09Corr};
%     ABS09Lags(1,ii) = {ABS09La};
% end
% 
% ABS09Maximum = zeros(1,NumberOfMicrophones);
% ABS09MaximumIndex = zeros(1,NumberOfMicrophones);
% for iii=1:NumberOfMicrophones
%     [ABS09Maximum(1,iii),  ABS09MaximumIndex(1,iii)] = max(abs(ABS09Correlation{1,iii}));
% end
% 
% ABS09Distances = zeros(1,NumberOfMicrophones);
% for iiii=1:NumberOfMicrophones
%     ABS09Distances(1,iiii) = ABS09Lags{1,iiii}(1,ABS09MaximumIndex(iiii))*340/Fs;
% end
% 
% ABS09DistanceMatrix = zeros(20,30);
% row = 1;
% index1 = 1;
% index2 = 30;
% for row=1:20
%     ABS09DistanceMatrix(row,:) = ABS09Distances(index1:index2);
%     index1 = index1 + 30;
%     index2 = index2 + 30;
% end
% 
% ABS09DistanceDifferenceMatrix = abs(ABS09DistanceMatrix-IdealDistanceMatrix);
% NANarray1 = nan(20,30);
% NANarray2 = nan(40,29);
% ABS09DistanceDifferenceMatrixFull = vertcat(NANarray1,ABS09DistanceDifferenceMatrix);
% ABS09DistanceDifferenceMatrixFull = horzcat(NANarray2,ABS09DistanceDifferenceMatrixFull);
% figure;
% h = pcolor(ABS09DistanceDifferenceMatrixFull);
% set(h, 'edgecolor','none')
% xlabel('Horizontal Distance (m)')
% ylabel('Vertical Distance (m)')
% title('Distance measurement error (ABS = 0.9)')
% xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
% set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
% title(colorbar,'m','FontSize',12);
% caxis([0 7.3])
% 
% %---Peak Prominence---ABS=0.9----------------------------------------------
% 
% ProminencePercent = 0.63;
% xPeakProm= (1:11761);
% PeakPromABS09Correlation = cell(1,NumberOfMeasurementLocations);
% MaximumIndexPeakPromABS09 = zeros(1,NumberOfMeasurementLocations);
% for aa=1:NumberOfMeasurementLocations
%     PeakPromABS09Correlation(1,aa) = {abs(ABS09Correlation{1, aa})};
%     [pks,locs,widths,proms] = findpeaks(PeakPromABS09Correlation{1,aa},xPeakProm,'MinPeakProminence',1,'Annotate','extents', 'MinPeakDistance',300 );
%     maxprom = max(proms);
%     [pks,locs,widths,proms] = findpeaks(PeakPromABS09Correlation{1,aa},xPeakProm,'MinPeakProminence',maxprom*ProminencePercent,'Annotate','extents', 'MinPeakDistance',300 );
%     MaximumIndexPeakPromABS09(1,aa) = locs(1);
% end
% 
% DistancesPeakPromABS09 = zeros(1,NumberOfMeasurementLocations);
% for aaaa=1:NumberOfMeasurementLocations
%     DistancesPeakPromABS09(1,aaaa) = abs(ABS09Lags{1,aaaa}(1,MaximumIndexPeakPromABS09(aaaa))*340/Fs);
% end
% 
% 
% DistanceMatrixPeakPromABS09 = zeros(20,30);
% row = 1;
% index1 = 1;
% index2 = 30;
% for row=1:20
%     DistanceMatrixPeakPromABS09(row,:) = DistancesPeakPromABS09(index1:index2);
%     index1 = index1 + 30;
%     index2 = index2 + 30;
% end
% 
% 
% ABS09DistanceDifferenceMatrix = abs(ABS09DistanceMatrix-IdealDistanceMatrix);
% NANarray1 = nan(20,30);
% NANarray2 = nan(40,29);
% ABS09DistanceDifferenceMatrixFull = vertcat(NANarray1,ABS09DistanceDifferenceMatrix);
% ABS09DistanceDifferenceMatrixFull = horzcat(NANarray2,ABS09DistanceDifferenceMatrixFull);
% figure;
% h = pcolor(ABS09DistanceDifferenceMatrixFull);
% set(h, 'edgecolor','none');
% xlabel('Horizontal Distance (m)')
% ylabel('Vertical Distance (m)')
% title('ABS09 Peak Prominence (PP=0.63)')
% title(colorbar,'m','FontSize',12);
% caxis([0 7.3])
% % % xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% % % set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% % % set(gca,'xticklabel',xt);
% % % yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% % % set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% % % set(gca,'yticklabel',yt);
% % title(colorbar,'m','FontSize',12);
% % caxis([0 2])
% 

