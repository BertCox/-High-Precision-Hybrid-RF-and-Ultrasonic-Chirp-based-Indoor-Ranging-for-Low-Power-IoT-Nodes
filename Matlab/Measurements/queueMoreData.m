  function queueMoreData(src,event)
       t = 0:1/196000:0.03;
datashort0 = ((chirp(t,45000,0.03,25000)').*2.5)+2.5;
datazeroes = zeros((196000-size(datashort0,1)),1);
data0 = vertcat(datashort0, datazeroes);
datashort1 = 5*ones(1,size(datashort0,1))';
data1 = vertcat(datashort1, datazeroes);
queueOutputData(s,repmat([data0, data1], 1, 1));
  end