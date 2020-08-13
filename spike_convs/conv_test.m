 binsize=0.1;
 pe=zeros(1,1000);
 pe(400)=1;
 pe(401)=1;
 pe(410)=1;
%  
%  kern=5*exp(-1.*[1:100]/10);
%  figure
%  plot(kern)
%  tt=conv2(pe, kern)
%  figure
%  subplot(2,1,1)
%  plot(pe)
%  subplot(2,1,2)
%  plot(tt)
%  
  %pe_=[0,0,0,0,0,0,1,0,0,0,0,0,0,];  %1 second timebase
  %pe=repelem(pe_, 1/binsize); %as if binned in 0.1s
  exp_window = 10./binsize; % 1 second window in 'bin' timeframe
  exp_dec = 1./binsize; % decay time in bin time
  [~, ek2] = exk32(exp_window, exp_dec, binsize); 
 % ek2 = ek2./binsize; % normalize by binsize
  spk2= conv2(pe, kern,'same'); % convolve with gaussian window

  figure
  subplot(2, 1, 1)
  plot(pe)
  subplot(2,1,2)
  plot(spk2)
  
  figure
  hold on
  plot(ek2)