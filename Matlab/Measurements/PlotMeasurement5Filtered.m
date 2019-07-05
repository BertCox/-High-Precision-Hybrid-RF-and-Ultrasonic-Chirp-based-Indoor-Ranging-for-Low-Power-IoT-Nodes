NumberOfMeasurementLocations = 63;
Fs = 196000;
t = 0:1/Fs:0.03;
ref = chirp(t,25000,0.03,45000);

%---IDEAL DISTANCES--------------------------------------------------------

XPositionMic = 3.05;
YPositionMic = 2.20;

AbsoluteXDistance = [2.66 2.34 2.04 1.73 1.42 1.13 0.81 0.51 0.20];
AbsoluteYDistance = [2.13 1.83 1.52 1.22 0.92 0.61 0.31];

RelativeXDistance = XPositionMic - AbsoluteXDistance;
RelativeYDistance = YPositionMic - fliplr(AbsoluteYDistance);

IdealDistanceMatrix = zeros(7,9);
for col = 1:9
  for row = 1:7
      IdealDistanceMatrix(row, col) = sqrt((RelativeYDistance(row))^2 + (RelativeXDistance(col))^2);
  end
end
%--------------------------------------------------------------------------

%---Unfiltered-------------------------------------------------------------

DataMeasurement5 = cell(1,NumberOfMeasurementLocations);
for idx=1:NumberOfMeasurementLocations
filename =['datapoint',int2str(idx),'.mat'];
DataMeasurement5{:,idx}=cell2mat(struct2cell(load(filename)));
end

CorrelationMeasurement5 = cell(1,NumberOfMeasurementLocations);
LagsMeasurement5 = cell(1,NumberOfMeasurementLocations);
for ii=1:NumberOfMeasurementLocations
    [CorrMeas5, LaggMeas5] = xcorr(DataMeasurement5{:,ii}, ref);
    CorrelationMeasurement5(1,ii) = {CorrMeas5};
    LagsMeasurement5(1,ii) = {LaggMeas5};
end

MaximumMeasurement5 = zeros(1,NumberOfMeasurementLocations);
MaximumIndexMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for iii=1:NumberOfMeasurementLocations
    [MaximumMeasurement5(1,iii),  MaximumIndexMeasurement5(1,iii)] = max(abs(CorrelationMeasurement5{1,iii}));
end

DistancesMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for iiii=1:NumberOfMeasurementLocations
    DistancesMeasurement5(1,iiii) = abs(LagsMeasurement5{1,iiii}(1,MaximumIndexMeasurement5(iiii))*340/Fs);
end

DistanceMatrixMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixMeasurement5(:,column) = fliplr(DistancesMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixMeasurement = flipud(abs(DistanceMatrixMeasurement5-IdealDistanceMatrix));
DistanceDifferenceMatrixMeasurement5 = DistanceDifferenceMatrixMeasurement;
DistanceDifferenceMatrixMeasurement5(8,10) = 0;
% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 3.2])


xQuadFilter= (1:11761);
yQuadPosFilter = (1/36929929)*xQuadFilter.^2-(23522/36929929)*xQuadFilter+ (138321121/36929929);

QuadPosFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    QuadPosFilteredMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa})).* yQuadPosFilter'};
end

MaximumQuadPosFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
MaximumIndexQuadPosFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for aaa=1:NumberOfMeasurementLocations
    [MaximumQuadPosFilterMeasurement5(1,aaa),  MaximumIndexQuadPosFilterMeasurement5(1,aaa)] = max(QuadPosFilteredMeasurement5{1,aaa});
end


DistancesQuadPosFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
LagsQuadPosFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    LagsQuadPosFilteredMeasurement5(1,aaaa) = {fliplr(LagsMeasurement5{1,aaaa})};
    DistancesQuadPosFilterMeasurement5(1,aaaa) = LagsQuadPosFilteredMeasurement5{1,aaaa}(1,MaximumIndexQuadPosFilterMeasurement5(aaaa))*340/Fs;
end

DistanceMatrixQuadPosFilteredMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixQuadPosFilteredMeasurement5(:,column) = fliplr(DistancesQuadPosFilterMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixQuadPosFilteredMeasurement = flipud(abs(abs(DistanceMatrixQuadPosFilteredMeasurement5)-IdealDistanceMatrix));
DistanceDifferenceMatrixQuadPosFilteredMeasurement5 = DistanceDifferenceMatrixQuadPosFilteredMeasurement;
DistanceDifferenceMatrixQuadPosFilteredMeasurement5(8,10) = 0;


% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixQuadPosFilteredMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker Pos Quad Filtered)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 3.2])



%--------------------------------------------------------------------------

%-------Linear-------------------------------------------------------------

xLinFilter= (1:11761);
yLinfilter = (-1/11761)*xLinFilter+1;

LinearFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    LinearFilteredMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa})).* yLinfilter'};
end

MaximumLinFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
MaximumIndexLinFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for aaa=1:NumberOfMeasurementLocations
    [MaximumLinFilterMeasurement5(1,aaa),  MaximumIndexLinFilterMeasurement5(1,aaa)] = max(LinearFilteredMeasurement5{1,aaa});
end


DistancesLinFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
LagsLinFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    LagsLinFilteredMeasurement5(1,aaaa) = {fliplr(LagsMeasurement5{1,aaaa})};
    DistancesLinFilterMeasurement5(1,aaaa) = LagsLinFilteredMeasurement5{1,aaaa}(1,MaximumIndexLinFilterMeasurement5(aaaa))*340/Fs;
end

DistanceMatrixLinFilteredMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixLinFilteredMeasurement5(:,column) = fliplr(DistancesLinFilterMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixLinFilteredMeasurement = flipud(abs(abs(DistanceMatrixLinFilteredMeasurement5)-IdealDistanceMatrix));
DistanceDifferenceMatrixLinFilteredMeasurement5 = DistanceDifferenceMatrixLinFilteredMeasurement;
DistanceDifferenceMatrixLinFilteredMeasurement5(8,10) = 0;


% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixLinFilteredMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker Lin Filtered -1)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 3.2])

%--------------------------------------------------------------------------

%---Quadratic--------------------------------------------------------------

xQuadFilter= (1:11761);
yQuadNegFilter = (-1/36929929)*xQuadFilter.^2+(11368/36929929)*xQuadFilter+ (4622073/36929929);

QuadNegFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    QuadNegFilteredMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa})).* yQuadNegFilter'};
end

MaximumQuadNegFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
MaximumIndexQuadNegFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for aaa=1:NumberOfMeasurementLocations
    [MaximumQuadNegFilterMeasurement5(1,aaa),  MaximumIndexQuadNegFilterMeasurement5(1,aaa)] = max(QuadNegFilteredMeasurement5{1,aaa});
end


DistancesQuadNegFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
LagsQuadNegFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    LagsQuadNegFilteredMeasurement5(1,aaaa) = {fliplr(LagsMeasurement5{1,aaaa})};
    DistancesQuadNegFilterMeasurement5(1,aaaa) = LagsQuadNegFilteredMeasurement5{1,aaaa}(1,MaximumIndexQuadNegFilterMeasurement5(aaaa))*340/Fs;
end

DistanceMatrixQuadNegFilteredMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixQuadNegFilteredMeasurement5(:,column) = fliplr(DistancesQuadNegFilterMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixQuadNegFilteredMeasurement = flipud(abs(abs(DistanceMatrixQuadNegFilteredMeasurement5)-IdealDistanceMatrix));
DistanceDifferenceMatrixQuadNegFilteredMeasurement5 = DistanceDifferenceMatrixQuadNegFilteredMeasurement;
DistanceDifferenceMatrixQuadNegFilteredMeasurement5(8,10) = 0;


% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixQuadNegFilteredMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker Neg Quad Filtered)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 3.2])


xQuadFilter= (1:11761);
yQuadPosFilter = (1/36929929)*xQuadFilter.^2-(23522/36929929)*xQuadFilter+ (138321121/36929929);

QuadPosFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    QuadPosFilteredMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa})).* yQuadPosFilter'};
end

MaximumQuadPosFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
MaximumIndexQuadPosFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for aaa=1:NumberOfMeasurementLocations
    [MaximumQuadPosFilterMeasurement5(1,aaa),  MaximumIndexQuadPosFilterMeasurement5(1,aaa)] = max(QuadPosFilteredMeasurement5{1,aaa});
end


DistancesQuadPosFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
LagsQuadPosFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    LagsQuadPosFilteredMeasurement5(1,aaaa) = {fliplr(LagsMeasurement5{1,aaaa})};
    DistancesQuadPosFilterMeasurement5(1,aaaa) = LagsQuadPosFilteredMeasurement5{1,aaaa}(1,MaximumIndexQuadPosFilterMeasurement5(aaaa))*340/Fs;
end

DistanceMatrixQuadPosFilteredMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixQuadPosFilteredMeasurement5(:,column) = fliplr(DistancesQuadPosFilterMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixQuadPosFilteredMeasurement = flipud(abs(abs(DistanceMatrixQuadPosFilteredMeasurement5)-IdealDistanceMatrix));
DistanceDifferenceMatrixQuadPosFilteredMeasurement5 = DistanceDifferenceMatrixQuadPosFilteredMeasurement;
DistanceDifferenceMatrixQuadPosFilteredMeasurement5(8,10) = 0;


% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixQuadPosFilteredMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker Pos Quad Filtered)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 3.2])
%--------------------------------------------------------------------------

%---Exponential------------------------------------------------------------

xExpFilter= (1:11761);
yExpFilter = 0.9995.^(xExpFilter-5684);

ExpFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    ExpFilteredMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa})).* yExpFilter'};
end

MaximumExpFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
MaximumIndexExpFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for aaa=1:NumberOfMeasurementLocations
    [MaximumExpFilterMeasurement5(1,aaa),  MaximumIndexExpFilterMeasurement5(1,aaa)] = max(ExpFilteredMeasurement5{1,aaa});
end


DistancesExpFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
LagsExpFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    LagsExpFilteredMeasurement5(1,aaaa) = {fliplr(LagsMeasurement5{1,aaaa})};
    DistancesExpFilterMeasurement5(1,aaaa) = LagsExpFilteredMeasurement5{1,aaaa}(1,MaximumIndexExpFilterMeasurement5(aaaa))*340/Fs;
end

DistanceMatrixExpFilteredMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixExpFilteredMeasurement5(:,column) = fliplr(DistancesExpFilterMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixExpFilteredMeasurement = flipud(abs(abs(DistanceMatrixExpFilteredMeasurement5)-IdealDistanceMatrix));
DistanceDifferenceMatrixExpFilteredMeasurement5 = DistanceDifferenceMatrixExpFilteredMeasurement;
DistanceDifferenceMatrixExpFilteredMeasurement5(8,10) = 0;


% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixExpFilteredMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker Exp Filtered 0.9995)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 3.2])

%---Peak Prominence--------------------------------------------------------
ProminencePercent = 0.63;
xPeakProm= (1:11761);
PeakPromMeasurement5 = cell(1,NumberOfMeasurementLocations);
MaximumIndexPeakPromFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    PeakPromMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa}))};
    [pks,locs,widths,proms] = findpeaks(PeakPromMeasurement5{1,aa},xPeakProm,'MinPeakProminence',1,'Annotate','extents', 'MinPeakDistance',300 );
    maxprom = max(proms);
    [pks,locs,widths,proms] = findpeaks(PeakPromMeasurement5{1,aa},xPeakProm,'MinPeakProminence',maxprom*ProminencePercent,'Annotate','extents', 'MinPeakDistance',300 );
    MaximumIndexPeakPromFilterMeasurement5(1,aa) = locs(1);
end
% 
% MaximumPeakPromFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
% MaximumIndexPeakPromFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
% for aaa=1:NumberOfMeasurementLocations
%     [MaximumPeakPromFilterMeasurement5(1,aaa),  MaximumIndexPeakPromFilterMeasurement5(1,aaa)] = max(QuadPosPeakPromMeasurement5{1,aaa});
% end


DistancesPeakPromFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
LagsPeakPromFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    LagsPeakPromFilteredMeasurement5(1,aaaa) = {fliplr(LagsMeasurement5{1,aaaa})};
    DistancesPeakPromFilterMeasurement5(1,aaaa) = abs(LagsPeakPromFilteredMeasurement5{1,aaaa}(1,MaximumIndexPeakPromFilterMeasurement5(aaaa))*340/Fs);
end

DistanceMatrixPeakPromFilteredMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixPeakPromFilteredMeasurement5(:,column) = fliplr(DistancesPeakPromFilterMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixPeakPromFilteredMeasurement = flipud(abs(abs(DistanceMatrixPeakPromFilteredMeasurement5)-IdealDistanceMatrix));
DistanceDifferenceMatrixPeakPromFilteredMeasurement5 = DistanceDifferenceMatrixPeakPromFilteredMeasurement;
DistanceDifferenceMatrixPeakPromFilteredMeasurement5(8,10) = 0;


% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixPeakPromFilteredMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker Peak Prominence 0.63)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 3.2])

