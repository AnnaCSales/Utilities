function [sem] = nansem(data, varargin)
%Takes a matrix of values, calculates standard error of the mean along
%dimension specified (second argument). When there is no second argument,
%just goes along dim 1 (or whichever one exists if it's a 1D matrix)

if length(varargin)
    dim=varargin{1};
else 
    dim=1;
    if numel(size(data)==2) & ismember(1, size(data))
        [v,i]=max(size(data));
        dim=i;
    end
end
   
        
sem=nanstd(data,0,dim)./sqrt(size(data(~isnan(data)), dim));

end

