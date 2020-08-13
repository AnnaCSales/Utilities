function [x, ex_kern ] = exk32( win, dec, binsize)
%Returns a 1000 value vector giving an exponential kernel. The kernel rises
%to a peak in the middle of the window and then decays exponentially. The
%kernel is normalised. 

%If using binned data, make sure to provide window
%and decay parameter in 'bin-timeframe' e.g. window(#bins)=window(s) /
%binsize. Then divide the kernel through by binsize before convolving.

%Can use to convolve with a spike train or with simulated firing rates etc.

x=1:win; %already in units of 'bin'

A=1 / (dec * (1 - exp(-win/dec)) );  %Normalisation constant

ex_kern=A*exp(-x/dec);

end

