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
caxis([0 7.5])

%---Quadratic Filter ABS=0.05--------------------------------------------------

xQuadFilter= (1:11761);
yQuadNegFilter = (-1/36929929)*xQuadFilter.^2+(11368/36929929)*xQuadFilter+ (4622073/36929929);

ABS005ExpFiltered = cell(1,NumberOfMicrophones);
for aa=1:NumberOfMicrophones
    ABS005ExpFiltered(1,aa) = {abs(ABS005Correlation{1, aa}).* yQuadNegFilter'};
end

ABS005MaximumExpFilter = zeros(1,NumberOfMicrophones);
ABS005MaximumIndexExpFilter = zeros(1,NumberOfMicrophones);
for aaa=1:NumberOfMicrophones
    [ABS005MaximumExpFilter(1,aaa),  ABS005MaximumIndexExpFilter(1,aaa)] = max(ABS005ExpFiltered{1,aaa});
end


ABS005DistancesExpFilter = zeros(1,NumberOfMicrophones);
for aaaa=1:NumberOfMicrophones
    ABS005DistancesExpFilter(1,aaaa) = ABS005Lags{1,aaaa}(1,ABS005MaximumIndexExpFilter(aaaa))*340/Fs;
end

ABS005DistanceMatrixExpFilter = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS005DistanceMatrixExpFilter(row,:) = ABS005DistancesExpFilter(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS005DistanceQuadNegFilterDifferenceMatrix = abs(ABS005DistanceMatrixExpFilter-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS005DistanceQuadNegFilterDifferenceMatrixFull = vertcat(NANarray1,ABS005DistanceQuadNegFilterDifferenceMatrix);
ABS005DistanceQuadNegFilterDifferenceMatrixFull = horzcat(NANarray2,ABS005DistanceQuadNegFilterDifferenceMatrixFull);
figure;
h = pcolor(ABS005DistanceQuadNegFilterDifferenceMatrixFull);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (ABS = 0.05, Negative Quadratic Filtered)')
xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
set(gca,'xticklabel',xt);
yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 5.5])


xQuadFilter= (1:11761);
yQuadPosFilter = (1/36929929)*xQuadFilter.^2-(23522/36929929)*xQuadFilter+ (138321121/36929929);

ABS005ExpFiltered = cell(1,NumberOfMicrophones);
for aa=1:NumberOfMicrophones
    ABS005ExpFiltered(1,aa) = {abs(ABS005Correlation{1, aa}).* yQuadPosFilter'};
end

ABS005MaximumExpFilter = zeros(1,NumberOfMicrophones);
ABS005MaximumIndexExpFilter = zeros(1,NumberOfMicrophones);
for aaa=1:NumberOfMicrophones
    [ABS005MaximumExpFilter(1,aaa),  ABS005MaximumIndexExpFilter(1,aaa)] = max(ABS005ExpFiltered{1,aaa});
end


ABS005DistancesExpFilter = zeros(1,NumberOfMicrophones);
for aaaa=1:NumberOfMicrophones
    ABS005DistancesExpFilter(1,aaaa) = ABS005Lags{1,aaaa}(1,ABS005MaximumIndexExpFilter(aaaa))*340/Fs;
end

ABS005DistanceMatrixExpFilter = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS005DistanceMatrixExpFilter(row,:) = ABS005DistancesExpFilter(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS005DistanceQuadPosFilterDifferenceMatrix = abs(ABS005DistanceMatrixExpFilter-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS005DistanceQuadPosFilterDifferenceMatrixFull = vertcat(NANarray1,ABS005DistanceQuadPosFilterDifferenceMatrix);
ABS005DistanceQuadPosFilterDifferenceMatrixFull = horzcat(NANarray2,ABS005DistanceQuadPosFilterDifferenceMatrixFull);
figure;
h = pcolor(ABS005DistanceQuadPosFilterDifferenceMatrixFull);
set(h, 'edgecolor','none')
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (ABS = 0.05, Quadratic Positive Filter)')
xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
set(gca,'xticklabel',xt);
yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 5.5])

%---ABSORPTIONCOEFF=0.3----------------------------------------------------

ABS03 = cell(1,NumberOfMicrophones);
for idx=1:NumberOfMicrophones
filename =['ABS03_MIC',int2str(idx),'.wav'];
ABS03{:,idx}=audioread(filename);
end

ABS03Filtered = cell(1,NumberOfMicrophones);
for i=1:NumberOfMicrophones
    ABS03Filtered(1,i) = {filter .* ABS03{:,i}};
end

ABS03Correlation = cell(1,NumberOfMicrophones);
ABS03Lags = cell(1,NumberOfMicrophones);
for ii=1:NumberOfMicrophones
    [ABS03Corr, ABS03La] = xcorr( ABS03Filtered{:,ii}, ref);
    ABS03Correlation(1,ii) = {ABS03Corr};
    ABS03Lags(1,ii) = {ABS03La};
end

ABS03Maximum = zeros(1,NumberOfMicrophones);
ABS03MaximumIndex = zeros(1,NumberOfMicrophones);
for iii=1:NumberOfMicrophones
    [ABS03Maximum(1,iii),  ABS03MaximumIndex(1,iii)] = max(abs(ABS03Correlation{1,iii}));
end

ABS03Distances = zeros(1,NumberOfMicrophones);
for iiii=1:NumberOfMicrophones
    ABS03Distances(1,iiii) = ABS03Lags{1,iiii}(1,ABS03MaximumIndex(iiii))*340/Fs;
end


ABS03DistanceMatrix = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS03DistanceMatrix(row,:) = ABS03Distances(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS03DistanceDifferenceMatrix = abs(ABS03DistanceMatrix-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS03DistanceDifferenceMatrixFull = vertcat(NANarray1,ABS03DistanceDifferenceMatrix);
ABS03DistanceDifferenceMatrixFull = horzcat(NANarray2,ABS03DistanceDifferenceMatrixFull);
figure;
h = pcolor(ABS03DistanceDifferenceMatrixFull);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (ABS = 0.3)')
xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
set(gca,'xticklabel',xt);
yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 5.5])

%---Quadratic Filter ABS=0.3--------------------------------------------------

xQuadFilter= (1:11761);
yQuadNegFilter = (-1/36929929)*xQuadFilter.^2+(11368/36929929)*xQuadFilter+ (4622073/36929929);

ABS03ExpFiltered = cell(1,NumberOfMicrophones);
for aa=1:NumberOfMicrophones
    ABS03ExpFiltered(1,aa) = {abs(ABS03Correlation{1, aa}).* yQuadNegFilter'};
end

ABS03MaximumExpFilter = zeros(1,NumberOfMicrophones);
ABS03MaximumIndexExpFilter = zeros(1,NumberOfMicrophones);
for aaa=1:NumberOfMicrophones
    [ABS03MaximumExpFilter(1,aaa),  ABS03MaximumIndexExpFilter(1,aaa)] = max(ABS03ExpFiltered{1,aaa});
end


ABS03DistancesExpFilter = zeros(1,NumberOfMicrophones);
for aaaa=1:NumberOfMicrophones
    ABS03DistancesExpFilter(1,aaaa) = ABS03Lags{1,aaaa}(1,ABS03MaximumIndexExpFilter(aaaa))*340/Fs;
end


ABS03DistanceMatrixExpFilter = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS03DistanceMatrixExpFilter(row,:) = ABS03DistancesExpFilter(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS03DistanceQuadNegFilterDifferenceMatrix = abs(ABS03DistanceMatrixExpFilter-IdealDistanceMatrix);

NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS03DistanceQuadNegFilterDifferenceMatrixFull = vertcat(NANarray1,ABS03DistanceQuadNegFilterDifferenceMatrix);
ABS03DistanceQuadNegFilterDifferenceMatrixFull = horzcat(NANarray2,ABS03DistanceQuadNegFilterDifferenceMatrixFull);
figure;
h = pcolor(ABS03DistanceQuadNegFilterDifferenceMatrixFull);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (ABS = 0.3, Negative Quadratic Filtered)')
xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
set(gca,'xticklabel',xt);
yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 5.5])

ABS03DistanceQuadNegFilterDifferenceMatrixLin = reshape(ABS03DistanceQuadNegFilterDifferenceMatrix,1,[]);

xQuadFilter= (1:11761);
yQuadPosFilter = (1/36929929)*xQuadFilter.^2-(23522/36929929)*xQuadFilter+ (138321121/36929929);

ABS03ExpFiltered = cell(1,NumberOfMicrophones);
for aa=1:NumberOfMicrophones
    ABS03ExpFiltered(1,aa) = {abs(ABS03Correlation{1, aa}).* yQuadPosFilter'};
end

ABS03MaximumExpFilter = zeros(1,NumberOfMicrophones);
ABS03MaximumIndexExpFilter = zeros(1,NumberOfMicrophones);
for aaa=1:NumberOfMicrophones
    [ABS03MaximumExpFilter(1,aaa),  ABS03MaximumIndexExpFilter(1,aaa)] = max(ABS03ExpFiltered{1,aaa});
end


ABS03DistancesExpFilter = zeros(1,NumberOfMicrophones);
for aaaa=1:NumberOfMicrophones
    ABS03DistancesExpFilter(1,aaaa) = ABS03Lags{1,aaaa}(1,ABS03MaximumIndexExpFilter(aaaa))*340/Fs;
end


ABS03DistanceMatrixExpFilter = zeros(20,30);
row = 1;
index1 = 1;
index2 = 30;
for row=1:20
    ABS03DistanceMatrixExpFilter(row,:) = ABS03DistancesExpFilter(index1:index2);
    index1 = index1 + 30;
    index2 = index2 + 30;
end

ABS03DistanceQuadPosFilterDifferenceMatrix = abs(ABS03DistanceMatrixExpFilter-IdealDistanceMatrix);
NANarray1 = nan(20,30);
NANarray2 = nan(40,29);
ABS03DistanceQuadPosFilterDifferenceMatrixFull = vertcat(NANarray1,ABS03DistanceQuadPosFilterDifferenceMatrix);
ABS03DistanceQuadPosFilterDifferenceMatrixFull = horzcat(NANarray2,ABS03DistanceQuadPosFilterDifferenceMatrixFull);
figure;
h = pcolor(ABS03DistanceQuadPosFilterDifferenceMatrixFull);
set(h, 'edgecolor','none')
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (ABS = 0.3, Quadratic Positive Filter)')
xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
set(gca,'xticklabel',xt);
yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 5.5])

ABS03DistanceQuadPosFilterDifferenceMatrixLinRico2 = reshape(ABS03DistanceQuadPosFilterDifferenceMatrix,1,[]);

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
h= pcolor(ABS09DistanceDifferenceMatrixFull);
set(h, 'edgecolor','none')
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (ABS = 0.9)')
xt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4';'4.5';'5';'5.5';'6'}; 
set(gca,'xtick',[5 10 15 20 25 30 35 40 45 50 55 60]); 
set(gca,'xticklabel',xt);
yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 5.5])


%---P50 P95 Mean --------------------------------------------------------



ABS005DistanceDifferenceMatrixLin = reshape(ABS005DistanceDifferenceMatrix,1,[]);
PValuesABS005 = prctile(ABS005DistanceDifferenceMatrixLin,[50 95]);

ABS005DistanceQuadNegFilterDifferenceMatrixLin = reshape(ABS005DistanceQuadNegFilterDifferenceMatrix,1,[]);
PValuesABS005QuadNeg = prctile(ABS005DistanceQuadNegFilterDifferenceMatrixLin,[50 95]);

ABS005DistanceQuadPosFilterDifferenceMatrixLin = reshape(ABS005DistanceQuadPosFilterDifferenceMatrix,1,[]);
PValuesABS005QuadPos = prctile(ABS005DistanceQuadPosFilterDifferenceMatrixLin,[50 95]);

ABS03DistanceDifferenceMatrixLin = reshape(ABS03DistanceDifferenceMatrix,1,[]);
PValuesABS03 = prctile(ABS03DistanceDifferenceMatrixLin,[50 95]);

ABS03DistanceQuadNegFilterDifferenceMatrixLin = reshape(ABS03DistanceQuadNegFilterDifferenceMatrix,1,[]);
PValuesABS03QuadNeg = prctile(ABS03DistanceQuadNegFilterDifferenceMatrixLin,[50 95]);

ABS03DistanceQuadPosFilterDifferenceMatrixLin = reshape(ABS03DistanceQuadPosFilterDifferenceMatrix,1,[]);
PValuesABS03QuadPos = prctile(ABS03DistanceQuadPosFilterDifferenceMatrixLin,[50 95]);

ABS09DistanceDifferenceMatrixLin = reshape(ABS09DistanceDifferenceMatrix,1,[]);
PValuesABS09 = prctile(ABS09DistanceDifferenceMatrixLin,[50 95]);



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
