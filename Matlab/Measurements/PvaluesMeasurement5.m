%---Peak Prominence--------------------------------------------------------

PValue50PeakPromMeasurement5 = zeros(1,51);
PValue95PeakPromMeasurement5 = zeros(1,51);
MeanPeakPromMeasurement5 = zeros(1,51);
index = 1;
for ProminencePercent = 0.50:0.01:1
xPeakProm= (1:11761);
QuadPosPeakPromMeasurement5 = cell(1,NumberOfMeasurementLocations);
MaximumIndexPeakPromFilterMeasurement5 = zeros(1,NumberOfMeasurementLocations);
for aa=1:NumberOfMeasurementLocations
    QuadPosPeakPromMeasurement5(1,aa) = {abs(flipud(CorrelationMeasurement5{1, aa}))};
    [pks,locs,widths,proms] = findpeaks(QuadPosPeakPromMeasurement5{1,aa},xPeakProm,'MinPeakProminence',1,'Annotate','extents', 'MinPeakDistance',300 );
    maxprom = max(proms);
    [pks,locs,widths,proms] = findpeaks(QuadPosPeakPromMeasurement5{1,aa},xPeakProm,'MinPeakProminence',maxprom*ProminencePercent,'Annotate','extents', 'MinPeakDistance',300 );
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

DistanceDifferenceMatrixPeakPromFilteredMeasurementLin = reshape(DistanceDifferenceMatrixPeakPromFilteredMeasurement,1,[]);
PValuesMeasurement5 = prctile(DistanceDifferenceMatrixPeakPromFilteredMeasurementLin,[50 95]);
PValue50PeakPromMeasurement5(index) = PValuesMeasurement5(1);
PValue95PeakPromMeasurement5(index) = PValuesMeasurement5(2);
MeanPeakPromMeasurement5(index) = mean(DistanceDifferenceMatrixPeakPromFilteredMeasurementLin);
%hold on; cdfplot(reshape(DistanceDifferenceMatrixPeakPromFilteredMeasurement(1:(size(DistanceDifferenceMatrixMeasurement5,1)-1),1:(size(DistanceDifferenceMatrixMeasurement5,2)-1)),1,[]));

% NANarray1 = nan(6,9);
% NANarray2 = nan(13,8);
% DistanceDifferenceMatrixFullMeasurement5 = vertcat(NANarray1,DistanceDifferenceMatrixMeasurement5);
% DistanceDifferenceMatrixFullMeasurement5 = horzcat(NANarray2,DistanceDifferenceMatrixFullMeasurement5);
% figure;
% h = pcolor(DistanceDifferenceMatrixPeakPromFilteredMeasurement5);
% set(h, 'edgecolor','none');
% xlabel('Horizontal Distance (m)')
% ylabel('Vertical Distance (m)')
% title('Distance measurement error (Omnidirectional Speaker Peak Prominence 0.50)')

% xt={'0';'0.3';'0.6';'0.9';'1.2';'1.5';'1.8';'2.1';'2.4';'2.7';'3.0';'3.3';'3.6';'3.9';'4.2';'4.5';'4.8';'5.1';'5.4';'5.7';'6'}; 
% set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]); 
% set(gca,'xticklabel',xt);
% yt={'0.5';'1';'1.5';'2';'2.5';'3';'3.5';'4'};
% set(gca,'ytick',[5 10 15 20 25 30 35 40]); 
% set(gca,'yticklabel',yt);
% title(colorbar,'m','FontSize',12);
% caxis([0 2])

index = index + 1;
end
Percentages = 0.5:0.01:1;
overviewPValueMeasurement5 = horzcat(Percentages', MeanPeakPromMeasurement5', PValue50PeakPromMeasurement5', PValue95PeakPromMeasurement5');
