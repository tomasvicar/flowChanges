function [bg] = bg_fit_iterative_gauss(varargin)

% [bg] = bg_fit_iterative_gauss(signal)
% [bg] = bg_fit_iterative_gauss(signal,iters,sigma)



signal = varargin{1};
if length(varargin)==1
    iters = 5;
    sigma = 40;
    
else
    iters = varargin{2};
    sigma = varargin{3};
end


for k = 1:iters
    mask_half = ceil(3*sigma);
    se = normpdf([-mask_half:mask_half],0,sigma);
    background = conv(asimetricpad(signal,mask_half), se,'valid');
    signal(signal>background) = background(signal>background);
end

bg =background;
end











function [signal] = asimetricpad(signal,pad)


start = signal(1:pad);
start = start(end:-1:1);

start = start(end)-start+start(end);




ending = signal(end-pad+1:end);
ending = ending(end:-1:1);
ending = ending(1)-ending+ending(1);


signal = [start ;signal; ending];

end

