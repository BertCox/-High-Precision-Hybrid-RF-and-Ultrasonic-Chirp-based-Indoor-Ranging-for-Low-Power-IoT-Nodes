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

%---Delta Envelope---------------------------------------------------------

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

EnvelopeDeltaPeakMeasurement5 = cell(1,NumberOfMeasurementLocations);
MaximumIndexEnvelopeDeltaPeakFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
EnvelopeDeltaPeakMeasurement5Correlation = cell(1,NumberOfMeasurementLocations);


for aa=1:NumberOfMeasurementLocations
    EnvelopeDeltaPeakMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa}))};
    EnvelopeDeltaPeakMeasurement5Correlation(1,aa) = {envelope(abs(EnvelopeDeltaPeakMeasurement5{1, aa}),49,'peak')};
    [pks,locs,widths,proms] = findpeaks(EnvelopeDeltaPeakMeasurement5Correlation{1,aa},xPeakProm,'Annotate','extents', 'MinPeakDistance',196 );
    delta_pks = diff(pks);
    delta_pks = [0; delta_pks];
    sum_pks = pks + delta_pks;
    [MaximumDelta,IndexMaximumdelta] = max(sum_pks);
    MaximumIndexEnvelopeDeltaPeakFilterMeasurement5(1,aa) = locs(IndexMaximumdelta);
end


DistancesEnvelopeDeltaPeakFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
LagsEnvelopeDeltaPeakFilteredMeasurement5 = cell(1,NumberOfMeasurementLocations);
for aaaa=1:NumberOfMeasurementLocations
    LagsEnvelopeDeltaPeakFilteredMeasurement5(1,aaaa) = {fliplr(LagsMeasurement5{1,aaaa})};
    DistancesEnvelopeDeltaPeakFilterMeasurement5(1,aaaa) = abs(LagsEnvelopeDeltaPeakFilteredMeasurement5{1,aaaa}(1,MaximumIndexEnvelopeDeltaPeakFilterMeasurement5(aaaa))*340/Fs);
end

DistanceMatrixEnvelopeDeltaPeakFilteredMeasurement5 = zeros(7,9);
index1 = 1;
index2 = 7;
for column=1:9
    DistanceMatrixEnvelopeDeltaPeakFilteredMeasurement5(:,column) = fliplr(DistancesEnvelopeDeltaPeakFilterMeasurement5(index1:index2));
    index1 = index1 + 7;
    index2 = index2 + 7;
end

DistanceDifferenceMatrixEnvelopeDeltaPeakFilteredMeasurement = flipud(abs(abs(DistanceMatrixEnvelopeDeltaPeakFilteredMeasurement5)-IdealDistanceMatrix));
DistanceDifferenceMatrixEnvelopeDeltaPeakFilteredMeasurement5 = DistanceDifferenceMatrixEnvelopeDeltaPeakFilteredMeasurement;
DistanceDifferenceEnvelopeDeltaPeakFilteredMeasurement5Lin = reshape(DistanceDifferenceMatrixEnvelopeDeltaPeakFilteredMeasurement5,1,[]);
DistanceDifferenceMatrixEnvelopeDeltaPeakFilteredMeasurement5(8,10) = 0;


% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixEnvelopeDeltaPeakFilteredMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)')
ylabel('Vertical Distance (m)')
title('Distance measurement error (Omnidirectional Speaker Envelope Delta Peak)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
title(colorbar,'m','FontSize',12);
caxis([0 2])