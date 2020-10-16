%Quick script to read in openEphys continuous data files (just the raw
%data), filter it, cut out extreme values, extract spikes. Produces a
%vector of spike times and a matrix of spikes, windowed around the peak (40
%samples). Follows Quiroga (2004, Neural Computation) for details of
%threshold and definitions of noise. 

%Anna Saes April 2017

[data_raw, ts_raw, info] = load_open_ephys_data('D:\Versus\290920\Rec5\126_CH10_5.continuous');   
ts_raw=ts_raw-ts_raw(1);
%% 
%select a time window of interest (optional)

t_start=0     ; 
t_end=1200;
t_range=[t_start, t_end];
[~, start_ind]=min(abs(ts_raw-t_start));
[~, end_ind]=min(abs(ts_raw-t_end));

data_raw=data_raw(start_ind:end_ind);   %cut data according to time selected.
tst=ts_raw(start_ind:end_ind);

fs=info.header.sampleRate; % extract sampling rate

figure
subplot(2, 1, 1)
hold on
title('Raw data')
plot(tst, data_raw) 
xlabel('Time(s)');
ylabel('Voltage (\mu V)');
% ylim([-400, 400]);
% xlim([ts2(1), ts2(end)]);

%% 
%Get rid of the worst extreme values
cutoff=1000;
cut_inds=find(data_raw>cutoff | data_raw<(-1*cutoff));  
data_raw(cut_inds)=[];
tst(cut_inds)=[];

%% 

%Filter data

filterRange=[300 6000];    %freq range to keep
[b,a]=butter(3,[filterRange(1)/(0.5*fs) filterRange(2)/(0.5*fs)], 'bandpass');  %Butterworth filter, with freq limits converted to pi-rads/sample
data=filtfilt(b,a,data_raw);  %filtered data
% data=data_raw; %for data that is already filtered

%%
%Now estimate the noise and set a threshold for spike detection

times_noise=6;
sd_est=median(abs(data)./0.6745) ;   %estimate of the noise, (following Quiroga(2004) )
threshold=-times_noise*sd_est  %negative threshold

subplot(2, 1, 2)
plot(tst, data) 
hold on;
xlabel('Time(s)');
ylabel('Voltage (\mu V)');
title(['Filtered data, with spike threshold shown at ', num2str(times_noise), ' * noise'])
t_small=linspace(tst(1), tst(end), 100);
sd1=ones(100, 1).*threshold;  
sd2=-1.*sd1;

%display the filtered data and the thresholds for spike extraction
figure
plot(tst, data)
hold on;
plot(t_small, sd1, 'k:')
plot(t_small, sd2, 'k:')
%% 
%Extract spikes.
%Look only at points above the threshold, find peaks 

inds_above=find(data<threshold);
data_above=data(inds_above);
[pks,locs] = findpeaks(-1.*data_above);  %find locations of minima

%now pull out the actual spikes.
peak_inds=inds_above(locs(:));  %index of spikes in full dataset
num_spikes=length(peak_inds);

%Pull out a window of data for each spike, centred on the peak and 40 samples
%long. As in openEphys spikesorter, centre the peak 0.3ms into the window.

spike_data=zeros(num_spikes, 40);

for j=1:num_spikes
    spike_data(j,:)=data(peak_inds(j)-8:peak_inds(j)+31);
end

spike_times=tst(inds_above(locs));  %spike timestamps.
spike_tbase=((1:40)./fs).*1000; %spike timebase in ms
%% 
figure
plot(spike_tbase, spike_data)
hold on
title('Plot of all spikes extracted, before clean-up')
xlabel('ms')
ylabel('\mu V')


%% 
%clean up floating voltages (and wrongly windowed spikes), before and after the spike centre
sp_early=spike_data(:, 1:4);
[r_e,~]=find(abs(sp_early)>6*sd_est);  %base the limit on 8*estimate of noise, above.

sp_late=spike_data(:, 22:end);
[r_l,~]=find(abs(sp_late)>6*sd_est);

sp_med=spike_data(:, 15:16);
[r_m,~]=find((sp_med)< -0.2*sd_est) ;  %points at this point should be pos


%artefacts - amend as appropriate for the recording **TAKE THIS BACK
%OUT!**
% sp_val=spike_data(:, 8:9);
% [r_valley, ~]=find((sp_val)<-300);
% killrows=unique([r_e', r_l', r_m', r_valley']); %rows to delete

killrows=unique([r_e', r_l', r_m']); %rows to delete

spike_times(killrows, :)=[];
spike_data(killrows, :)=[];

%% 
spikes=struct;
spikes.times=spike_times;
spikes.data=spike_data;

figure
plot(spike_tbase, spike_data)
hold on
title('Plot of all spikes extracted, final version.')
xlabel('ms')
ylabel('\mu V')

figure
subplot(2,1,1)
plot([spike_times,spike_times], [-1,1], 'k')
ylim([-2, 2])
title('Extracted from raw data')
subplot(2,1,2)
clust_t=spikeStruct.timesSorted{6}
plot([clust_t, clust_t], [-1,1], 'k')
ylim([-2, 2])
title('Cluster 6')
