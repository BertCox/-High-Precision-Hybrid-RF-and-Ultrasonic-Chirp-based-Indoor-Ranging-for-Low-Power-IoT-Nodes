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
DistanceDifferenceMatrixMeasurement5Lin = reshape(DistanceDifferenceMatrixMeasurement5,1,[]);
DistanceDifferenceMatrixMeasurement5(8,10) = 0;
% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
figure;
h = pcolor(DistanceDifferenceMatrixMeasurement5);
set(h, 'edgecolor','none');
xlabel('Horizontal Distance (m)','FontSize',16)
ylabel('Vertical Distance (m)','FontSize',16)
title('Distance measurement error (Omnidirectional Speaker)','FontSize',16)

xt={'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10]); 
set(gca,'xticklabel',xt,'FontSize',14);
yt={'2.15';'2.45';'2.75';'3.05';'3.35';'3.85';'3.95';'4.25'};
set(gca,'ytick',[1 2 3 4 5 6 7 8]); 
set(gca,'yticklabel',yt,'FontSize',14);
title(colorbar,'m','FontSize',14);
caxis([0 2.0])

figure; cdfplot(DistanceDifferenceMatrixMeasurement5Lin); hold on; cdfplot(DistanceDifferenceMatrixPeakPromFilteredMeasurement5Lin); hold on; cdfplot(DistanceDifferenceMatrixEnvelopeDeltaFilteredMeasurement5Lin);
hold on; cdfplot(DistanceDifferenceEnvelopeDeltaPeakFilteredMeasurement5Lin);