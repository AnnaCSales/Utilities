function [x, ex_kern ] = exk( win, dec)
%Returns a 1000 value vector giving an exponential kernel. The kernel rises
%to a peak in the middle of the window and then decays exponentially. The
%kernel is normalised. 

%If using binned data, make sure to provide window
%and decay parameter in 'bin-timeframe' e.g. window(#bins)=window(s) /
%binsize. Then divide the kernel through by binsize before convolving.

%Can use to convolve with a spike train or with simulated firing rates etc.

x=linspace(0, win, 1000);
ex_kern=zeros(1000,1);

A=exp(win/(2*dec)) / (dec * (1 - exp(-win/2*dec)) );  %Normalisation constant

x2=x( 501  : end);
ex_kern(501:end)=A.*exp(-x2/dec);

end

