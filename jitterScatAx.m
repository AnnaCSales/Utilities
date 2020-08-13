function [xs, data_new] = jitterScatAx(Fig,SP,data, varargin)
% Plots on specified figure Fig at specified subplot SP.
% This function takes an array of data ('data') in either cell array format 
% (useful if groups have different numbers of data points) or an array. If
% data is an array, function expects each column to be data for a different
% group.
% It plots a jittered scatter plot, with boxplot over the top showing 
% mean, std, interquartile range etc. 
% NB It is written so 'boxplot' does not show the outliers. The (optional)
% second argument is a cell array providing the labels for the categories
% (these will provide labels on the xaxis)
% Each column is assumed to be a seperate set to
% plot. 
% Function returns the figure - user is left to tidy up the axis labels
% etc - and to do the right ANOVA! Also returns:
%   - the values used for the x-coords, which are useful for adding to the plot
%   - the formatted data as a single row vector, with corresponding group
%   ID vector - for doing v simple ANOVA1 etc.

%Define a whole bunch of colors 
rng('shuffle')
plotcol=[1 0 0; 0 1 0; 0 0 1; 1 0.8 0;0.54 0.17 0.88; 1 0.64 0; 0.46, 0.53, 0.6  ];
plotcol=repmat([0 0 1], 10,1);
if ~length(varargin)  %if user has failed to specify appropriate labels, default to numbers
    cats=string(1:size(data,2));
else
    cats=varargin{1};
end

% sort out what type of data we have.
if iscell(data)
    n_groups=length(data);
else
    n_groups=size(data,2);
end

%open a figure and plot each group
figure(Fig)
subplot(SP)
xs=cell(n_groups,1);
data_all=[];
data_groups=[];

for p=1:n_groups
    
    %get data and pick a colour
    if iscell(data)
        this_data=data{p};
        if size (this_data,2)>1
            this_data=this_data';
        end
    else
        this_data=data(:,p);
    end
    
    if p<=size(plotcol,1)
       this_col=plotcol(p,:);
    else
       this_col=plotcol(mod(p, size(plotcol,1)),:);
    end
    
    %plot
    xs{p}=p*ones(length(this_data),1)+0.2*rand(length(this_data),1)-0.1;
    aa=scatter(xs{p}, this_data, 'o');
    aa.MarkerFaceColor=this_col;
    aa.MarkerFaceAlpha=0.4;
    aa.MarkerEdgeColor='w';
    hold on;
    
    data_all=[data_all; this_data]; %store data in a format useful for the boxplot (and any anova)
    data_groups=[data_groups, repmat(p, 1,length(this_data))];
 
end

% boxplot(data_all, data_groups, 'symbol', '');
xticks(1:n_groups);
xticklabels(cats);
ylabel('Response (edit this)');
xlim([0.5,n_groups+0.5]);

data_new.data=data_all;
data_new.data_groups=data_groups;  %save these to send back.
end

