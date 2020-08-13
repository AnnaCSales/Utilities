
%Poisson point process - create a random spike train

dt = 0.001;
t = [0 10]; % time interval (length) of spike train to generate
tvec = t(1):dt:t(2);

pspike = 0.01; % probability of generating a spike in bin
rng default; % reset random number generator to reproducible state
spk_poiss = rand(size(tvec)); % random numbers between 0 and 1
spk_poiss_idx = find(spk_poiss < pspike); % index of bins with spike
spk_poiss_t = tvec(spk_poiss_idx)'; % use idxs to get corresponding spike time
figure
line([spk_poiss_t spk_poiss_t],[-1 -0.5],'Color',[0 0 0]); % note, plots all spikes in one command
axis([0 10 -1.5 5]); set(gca,'YTick',[]);

%%

binsize = 0.001; % select a small bin size for good time resolution
tbin_edges = t(1):binsize:t(2);
tbin_centers = tbin_edges(1:end-1)+binsize/2;
spk_count = histc(spk_poiss_t,tbin_edges);
spk_count = spk_count(1:end-1);

binsize = 0.001; % in seconds, so everything else should be seconds too
gauss_window = 1./binsize; % 1 second window
gauss_SD = 0.05./binsize; % 0.02 seconds (50ms) SD
gk = gausskernel(gauss_window,gauss_SD); gk = gk./binsize; % normalize by binsize
gau_sdf = conv2(spk_count,gk,'same'); % convolve with gaussian window
plot(tbin_centers,gau_sdf,'g');

xlim([0,3])
line([spk_poiss_t spk_poiss_t],[-1 -0.5],'Color',[0 0 0]); % note, plots all spikes in one command
