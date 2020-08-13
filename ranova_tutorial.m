%% repeated measures ANOVA
% Must specify your between subject factors and within subject factors in
% the repeated measures model object.

%Data - one row for each subject, with results for each distinct
%condition. Convert to a table. I have called the responses 'Y1' to 'Y4'
%here. This dataset is self-reports of anxiety from the SAME patients (n=4) under
%4 different conditions - drug/no drug * therapy / no therapy. Results here
%have been checked against SPSS for consistency.

data=   [70,60,81,52;66,52,70,40;56,41,60,31;68,59,77,49 ]
varNames = {'Y1','Y2','Y3','Y4'};
t = array2table(data,'VariableNames',varNames);

%Now create within factors table, describing the within subject
%(measurement on same subjects) factors and how they relate to the columns
%in the data table.
within_labels=[[1;1;2;2], [1;2;1;2]]
within_table=table(within_labels(:,1),within_labels(:,2), 'VariableNames', {'Drug', 'Therapy'})

%NB the factors MUST be converted to 'categorical' if they are categotical
%- otherwise will screw up!!
within2 = within_table;
within2.Drug = categorical(within2.Drug);
within2.Therapy= categorical(within2.Therapy);   

% Calculate some summary stats - mean and std.
sqrt(sum( (data-repmat(mean(data,1),4,1)).^2 ,1)/ size(data,1))
desc_stats=[mean(data, 1); std(data)]

%fit the repeated measures model 
%the second variable you need for fitrm is the modelspec in wilkinson
%notation. Format is responses ~ predictors i.e. Y1, Y2 ~ X1 + X2 * X3 (see
%MATLAB page - predictors are BETWEEN subject factors i.e. if patients were split according to gender,
%age etc).  WITHIN subject factors (i.e. drug/therpay, which is measured repeatedly in each patient)
%are put in the 'WithinDesign' specification.
rm= fitrm(t,'Y1-Y4~1','WithinDesign',within2);

% Now we can run the rm-anova and check for sphericity
[ranova_table, a, c]=ranova(rm, 'WithinModel', 'Drug*Therapy')
mauchly(rm,c) ; %output corresponds to first col of anova table - if there are within subject factors you need to calculate the anova first to get c, then put it back into mauchly

%That gives F values, sum of squares etc - all useful.
%E.g calculate partial eta squared - amount of variance explained by that factor
%(SS_effect / (SS_effect +SS_error)

%Partial eta for DRUG
ranova_table.SumSq(3)/ (ranova_table.SumSq(3)+ranova_table.SumSq(4))

%Partial eta for THERAPY
ranova_table.SumSq(5)/ (ranova_table.SumSq(5)+ranova_table.SumSq(6))

%Partial eta for interaction betewen DRUG and THERAPY
ranova_table.SumSq(7)/ (ranova_table.SumSq(7)+ranova_table.SumSq(8))

%Very little of the variance is explained by drug (33%) - most of it can be
%explained by using the therapy var(99%) or the interaction erm (98%)

%Can run multcompare on the rm object, to look at whether there is a
%difference between the means of the various groups. Can do this WITHIN
%a specified factor, e.g. is there any difference in means of drug/no drug,
%when therapy is held constant:
multcompare(rm, 'Drug', 'By', 'Therapy', 'ComparisonType', 'bonferroni') 
%or vice versa
multcompare(rm, 'Therapy', 'By', 'Drug', 'ComparisonType', 'bonferroni') 
%or just for one
multcompare(rm, 'Therapy',  'ComparisonType', 'bonferroni') 

%Where there is an interaction, explore in more detail by looking at marginal
%means (i.e. mean of Drug1 in either category).
%Good to plot interaction
%plot. This is just a graph showing how one factor changes when the other
%is held constant, where a slope shows what the interaction is

figure('Color', 'w')
errorbar([1,2], desc_stats(1,[1,3]),desc_stats(2,[1,3]), 's-' )
hold on
errorbar([1,2], desc_stats(1,[2,4]),desc_stats(2,[2,4]), 's-' )
ylabel('Reported outcome (lower is better)')
xticks([1,2])
xticklabels({'No Drug', 'Drug'})
legend({'With therapy' 'Without therapy'})
xlim([0,3])

