
function [SpikeDensity, FiringRate] = SDF2(spikes,tb,sigma)
% (c) Aleksander Domanski 2009 a.p.f.domanski@ninds.nih.gov
% 1D Spike Density Estimation with Gaussian Filter. Convolves spike trains with kernal with std. dev.
% Takes MxN spike raster, where M is cell number and N is time
%
% SpikeDensity = SDF2(spikes,tb,kernal_sigma)
%
% Input Args:
% spikes        - Spike timestamps in seconds
% % tb          - timebase in seconds onto which to project spike density
% kernel_sigma  - rate kernel standard deviation in s
%
% Output Args:
% SpikeDensity  - Smoothed kernel estimated firing rate on timebase tb
% FiringRate    - Binned spike rate on timebase tb


% bin spikes onto timebase.
bw           = mean(diff(tb));
FiringRate   = histc(spikes,tb(1):bw:tb(end));

% Make a Gaussian kernel over +/- 3s.d.
edges  = -3*sigma:bw:3*sigma; 
mu_    = 0; 
kernel = exp(-0.5 * ((edges - mu_)./(sigma/bw)).^2) ./ (sqrt(2*pi) .* (sigma/bw));
kernel = kernel*bw; % Scale kernel integral to 1 

% Convolve rate * kernel
PDF    = conv(FiringRate,kernel);

% trim edges off
kernal_center = ceil(length(edges)/2);
SpikeDensity=PDF(kernal_center:length(PDF)-kernal_center);

end
