function [lags, xc] = myXcorr(y1,y2,nl)
%Home made xcorr function. Takes y1, y2 - the two signals to compare, and
%n_l, the number of lags to consider. If binsize=500ms, then a n_l of 20
%will return xcorrs for 10s either side of zero. Returns a vector of lags
%and the xcorr signal. This version holds y1 constant and fiddles with y2.

k=1;
sig=[];
lags=[];
    n=numel(y2);
%     figure
%     plot(1:n,y2, 'k');
%     hold on
%     plot(y1);
%     hold on
for j= -nl:1:nl
    n=numel(y2);
    
    if j<0
        sig=[zeros(1, abs(j)), y2];
        sig(n+1:end)=[];
    elseif j>0
        sig=[ y2(j+1:end), zeros(1, j)];
    else
        sig=y2;
    end

 %    plot(1:n,sig)
     lags(k)=j;
     xc(k)=sum(sig .*y1);
    k=k+1;
end

% figure
% subplot(2,1,1)
% plot(y1)
% hold on
% plot(y2)
% subplot(2,1,2)
% plot(lags, xc)
end