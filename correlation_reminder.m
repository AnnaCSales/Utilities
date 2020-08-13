%% Calculates corrleation with cor and xcor, shows what side of zero the peak is for lags and leads!!
n_t=150;
t=linspace(0,15,n_t);
fs=15/n_t;

signal2=(sin(t)+0.2*rand(1,n_t))'
signal1=(sin(t+1)+0.2*rand(1,n_t))'

figure('Color', 'w','Units' ,'Centimeters', 'Position', [5 5 20 10])
subplot(2,1,1)
plot(t,signal1, 'r')
hold on
plot(t, signal2, 'b')
legend({'Signal 1' 'Signal 2'})
text(1, 1.55 ,['Signal 1 leads signal 2'] )
xticks(0:t(end))
signals=[signal1, signal2]
[acor, lags]=xcorr(signal1, signal2, 20) %calculate xcor, with 10 as the maximum lag to use
subplot(2,1,2)
plot(lags*fs, acor)
hold on
plot([0,0], [-100,100], '--k')
[~,ind]=max(acor);
max_t=lags(ind)*fs;
plot([max_t, max_t], [-100,100], '--r')
text(0.6,65, 'Called xcorr(signal1, signal2)');
text(max_t-0.2,50, ['Max at ' num2str(max_t, 2)]);