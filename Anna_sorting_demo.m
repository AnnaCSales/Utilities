%[data, timestamps, info] = load_open_ephys_data('C:\openEphys\Recordings\2016-11-23_15-19-53\SE0_3.spikes');
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
figure;
plot(timestamps/60,ones(length(timestamps),1),'.') % Raster (minutes)   %timestamps for each spike
ylim=[0,2];
1./mean(diff(timestamps)) ;% mean rate (Hz)
%info.header.sampleRate 
% date2time(info.header.date_created)
timebase_spike =(1:size(data,2))./info.header.sampleRate *1000; %sample rate in ms    %timebase for within a spike window


% 1000 spikes
data_ = data(5736:6500,:);
tb_   = timestamps(5736:6500);
figure
plot(timebase_spike,data_,'DisplayName','data(1:2,:)')
% axis([-Inf Inf -1000 200])
figure;
bins =-400:5:0;
plot(bins,histc(min(data_),bins))
IDs = false(size(data_,1),1);
D_=-150; %amp threshold 
IDs( min(data_,[],2)>D_) =true;

figure; hold on
plot(timebase_spike,data_(IDs,:),'r')
plot(timebase_spike,data_(~IDs,:),'b')


U1_times = tb_(IDs);
U2_times = tb_(~IDs);

% raster plot
figure; hold on
plot(U1_times,ones(length(U1_times),1),'.r')
plot(U2_times,ones(length(U2_times),1),'.b')


% ISI distribution
bins =(0:0.001:1);
ISI_U1 = histc(diff(U1_times),bins);
ISI_U2 = histc(diff(U2_times),bins);
figure; 
subplot(1,2,1); hold on
stairs(bins,ISI_U1,'Color','r')
set(gca,'XScale','log')
plot([0.0015 0.0015],[0 10],':k')
subplot(1,2,2); hold on
stairs(bins,ISI_U2,'Color','b')
set(gca,'XScale','log')
plot([0.0015 0.0015],[0 10],':k')




% [a b c] = load_open_ephys_data('all_channels.events');
%% Continuous data
[data, timestamps, info] = load_open_ephys_data('107_CH6_2.continuous');
plot(timestamps,data)



