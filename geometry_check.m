function [d_Probe] = geometry_check()

prompt1='Enter difference between depths for probe/FO: ';
depths_diff = input(prompt1);
prompt2='Enter depth at which pupil responses found: ';
d_FO=input(prompt2); %range of value for probe depth at which pupil responses are found

%x direction=AP, y direction=DV, depth=depth along path of probe/FO
x_FO=d_FO * sind(10);
y_FO=d_FO * cosd(10);
x_probe=(2.1-x_FO+1.4);
y_probe=(y_FO+depths_diff);
d_Probe=x_probe / sind(20);

y_check=y_probe-depths_diff;

%make some points for plotting
fo_entry=[2.1, -depths_diff];
probe_entry=[-1.4, 0];

fo_tip=[2.1-x_FO, -(y_FO+depths_diff)];
probe_tip=[2.1-x_FO, -y_probe];

lambda_line=linspace(depths_diff+0.5, probe_tip(2), 20)

figure
plot(zeros(1,20), lambda_line, 'k');
hold on;
plot([probe_entry(1), probe_tip(1)], [probe_entry(2), probe_tip(2)], 'b')
plot([fo_entry(1), fo_tip(1)], [fo_entry(2), fo_tip(2)], 'r')
plot([0, fo_entry(1)], [-depths_diff, -depths_diff], '--k');
plot([0, probe_entry(1)],[0,0], '--k');
text(0,2,'\leftarrow line through lambda')
text(fo_entry(1), fo_entry(2)+0.3, 'FO entry')
text(probe_entry(1)-0.4, probe_entry(2)+0.3,'Probe entry')
text(probe_entry(1)+0.8, 0.5*probe_tip(2),num2str(d_Probe))
text(fo_entry(1)-0.25, (-depths_diff+0.3*fo_tip(2)),num2str(d_FO))
text(0.03,-depths_diff/2,num2str(depths_diff))
plot([fo_tip(1), fo_tip(1)], [fo_tip(2), -depths_diff], '--k');
text(fo_tip(1)+0.05, 0.5*probe_tip(2), num2str(y_FO));
text(probe_entry(1)*0.65,0.35,'\leftarrow 1.4 \rightarrow');
text(fo_tip(1)-0.35, -depths_diff+0.35, '\leftarrow  2.1  \rightarrow');
text(0.25, -depths_diff-0.35, ['\leftarrow' num2str(2.1-x_FO)  '\rightarrow']);
xlim([-2,3]);
ylim([floor(fo_tip(2)-0.3), 3]);
end

