%%
%load some data
[spike_dat, spike_t, spike_inf] = load_open_ephys_data('C:\openEphys\Recordings\2016-11-23_15-19-53\SE0_3.spikes');
%[spike_dat, spike_t, spike_inf] = load_open_ephys_data('C:\MATLAB things\2017-02-10_14-53-31\SE0.spikes');

% figure;
% plot(spike_t/60,ones(length(spike_t),1),'.') % Raster (minutes)   %timestamps for each spike - helps to see where recording starts and ends.

t_start= 0
t_end= 600
[~, start_idx]=min(abs(spike_t-t_start));
[~, end_idx]=min(abs(spike_t-t_end));

data_cut=spike_dat(start_idx:end_idx, :);  
timestamps_cut=spike_t(start_idx:end_idx);
timebase_spike =((1:size(spike_dat,2))./spike_inf.header.sampleRate) *1000;

% figure
% plot(timebase_spike, data_cut)
% title('1 Plot of all spikes, raw data')
% xlabel('ms')
% ylabel('\mu V')

%deal with wrongly windowed spikes (really should go back to the raw data
%and window properly.

[~, t_cut]=min(abs(timebase_spike-0.5)); %find index where timebase is at 0.5
data_test=data_cut(:, t_cut:end);
[a,~]=min(data_test,[],2);
exclude=find(a<-200)
data_cut(exclude, :)=[];  %get rid of wrongly windowed spikes.

figure
plot(timebase_spike, data_cut)
title('Plot of all spikes, raw data')
xlabel('ms')
ylabel('\mu V')
%%

%clean up noise - get rid of entries with absurdly high vals (more than
%twice the mean value of the maxima across all entries)
% maxVals= max(abs(data_cut),[], 2);
% data_cut=data_cut(maxVals<(2*mean(maxVals)), :);
% data_cut=data_cut(maxVals<600, :);
% figure
% plot(timebase_spike, data_cut)
% title('3. Plot of all spikes - cleaned')
% xlabel('ms')
% ylabel('\mu V')


%floating, noisy recordings - not spikes. Average value across the entire
%recording will be a long way from zero if the value of the voltage is just
%floating somewhere high or low. Can clean these up - but be careful not to
%exclude the good stuff
%--------------------------------
% av_vals=mean((data_cut), 2);  %mean across all 40 samples.
% limit=abs(5*mean(av_vals));
% figure; 
% hold on;
% plot(av_vals)  %nice to visualise - can pick out when the noisy ones happened
% data_cut=data_cut(abs(av_vals)<limit, :);
%timestamps_cut=timestamps_cut(abs(av_vals)<limit);
% av_vals2=mean((data_cut), 2); 
% plot(av_vals2, 'r')
%----------------------------------


% %plot all the data to see what it looks like
% figure
% plot(timebase_spike, data_cut)
% title('Plot of spikes - artefacts removed')
% xlabel('ms')
% ylabel('\mu V')

%can we do this the old fashioned way?
cov_mat=;
% clims = [-1000 4000];
% 
% imagesc(cov_mat, clims);
% colorbar;

[V,D] = eig(cov(data_cut));

%vectors are in V

PC1=V(:, 40); % should be PC1 - NB order of vectors is backwards!
PC2=V(:,39);

figure
subplot(1, 2, 1)
title('PCA components done the old way')
plot(PC1, 'r');
hold on
plot(PC2, 'g');
weights1=data_cut*PC1;  %project each spike onto PC1 etc
weights2=data_cut*PC2;

subplot(1, 2, 2)
scatter(weights1, weights2)
xlabel('PC1')
ylabel('PC2')


%now do the MATLAB-recommended way
[coeff,score,latent] = pca(data_cut);

%coefficients - each column is a eigenvector, with the highest evalued ones first. Plot the first two principal
%components. 'latent' holds the evalues themselves.

pc1=coeff(:,1);
pc2=coeff(:,2);
pc3=coeff(:,3);

figure
plot(pc1, 'r');
hold on;
plot(pc2, 'b');
plot(pc3, 'g');
xlabel('ms')
ylabel('\mu V')
title('First three principal components')

%scatter plot using the PCA scores - projections along components.
% score holds projection weightings for all 5000 examples, for each of the
% 40 e-vectors. We just want the first two weightings.
figure
twoScores=score(:, 1:2);  
scatter(twoScores(:,1), twoScores(:,2));
xlabel('PC1')
ylabel('PC2')
title('Events plotted by projections onto 2 top PC')

figure
threeScores=score(:, 1:3);  
scatter3(threeScores(:,1), threeScores(:,2), threeScores(:,3));
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')
title('Events plotted by projections onto 3 top PC')

% now we'd need to cluster them - k means will do
% try two groups and three

% use two principal components
idx2 = kmeans(twoScores,2) ; %index of which cluster each example belongs to

group1=data_cut(idx2==1, :);
group2=data_cut(idx2==2, :);

times_group1=timestamps_cut(idx2==1);
times_group2=timestamps_cut(idx2==2);

figure
plot(timebase_spike, group1, 'b');
hold on
plot(timebase_spike, group2, 'r');
xlabel('ms')
ylabel('\mu V')
title('Spike events as clustered by kmeans, 2 groups')

% have a quick look at ISIs
U1_ISI=diff(times_group1);
U2_ISI=diff(times_group2);

U1rate=1/mean(U1_ISI);
U2rate=1/mean(U2_ISI);
fprintf('Grouped into 2 clusters:')
fprintf('Estimate of firing rates for group 1: %f',U1rate )
fprintf('\nEstimate of firing rates for group 2: %f',U2rate)
fprintf('\n')

% %use three principal components
% idx3 = kmeans(threeScores,3);  %index of which cluster each example belongs to
% 
% group1=data_cut(idx3==1, :);
% group2=data_cut(idx3==2, :);
% group3=data_cut(idx3==3, :);
% 
% times_group1=timestamps_cut(idx3==1);
% times_group2=timestamps_cut(idx3==2);
% times_group3=timestamps_cut(idx3==3);
% 
% figure
% plot(timebase_spike, group1, 'r');
% hold on
% plot(timebase_spike, group2, 'b');
% plot(timebase_spike, group3, 'g');
% xlabel('ms')
% ylabel('\mu V')
% title('Spike events as clustered by kmeans, 3 groups')
% 
% U1_ISI=diff(times_group1);
% U2_ISI=diff(times_group2);
% U3_ISI=diff(times_group3);
% 
% U1rate=1/mean(U1_ISI);
% U2rate=1/mean(U2_ISI);
% U3rate=1/mean(U3_ISI);
% fprintf('Grouped into 3 clusters:')
% fprintf('Estimate of firing rates for group 1: %f',U1rate )
% fprintf('\nEstimate of firing rates for group 2: %f',U2rate)
% fprintf('\nEstimate of firing rates for group 3: %f',U3rate)
% fprintf('\n')
% 
% group1_2=data_cut(idx2==1, :);
% group2_2=data_cut(idx2==2, :);
% 
% figure
% plot(timebase_spike, group1_2, 'b');
% hold on
% plot(timebase_spike, group2_2, 'r');
% xlabel('ms')
% ylabel('\mu V')
% title('Spike events as clustered by kmeans, 2 groups')


