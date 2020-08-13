function [wf_feats]=convert_all_figs()
%Converts all the .fig files in a particular folder to an output type of
%your choice. 
% 1 = uncompressed tif
% 2 = svg
% Anna Sales UoB Feb 2019.

%User to select folder:
d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.fig'));

prompt = sprintf(['Enter output type: \n1=uncompressed tif, 2=svg, 3=jpg']);
title = 'Output val';
definput = {'1'};
opts.Interpreter = 'tex';
ans = inputdlg(prompt,title,[1 35],definput);
outtype= str2num(ans{1})
%Setup the output type
switch outtype
    case 1
      out_type='tiffn';  %uncompressed tif
    case 2
      out_type='svg';
    case 3
      out_type='jpg'
end

for k = 1 : length(files)
    this_file=files(k);
    this_fig = openfig([this_file.folder '\' this_file.name]);
    fn=strsplit(this_file.name, '.');
    outname=[fn{1} '.' out_type];   
    filename = [this_file.folder '\' outname];
    saveas(this_fig, filename);
    close all
end

end