function [bg] = bg_fit_iterative_polynom(varargin)

% [bg] = bg_fit_iterative_polynom(time,signal)
% [bg] = bg_fit_iterative_polynom(time,signal,iters,order)


time = varargin{1};
signal = varargin{2};

if length(varargin)==2
    iters = 3;
    order = 7;
else
    iters = varargin{3};
    order = varargin{4};
end


 

x = time;
for k = 1:iters

    fo = fit(x,signal,['poly' num2str(order)],'Robust','Bisquare');

    background =zeros(size(x));
    for k = 1:(order+1)
        background = background + fo.(['p' num2str(k)])*x.^(order-k+1);
    end

    x(signal>background)=[];
    signal(signal>background)=[];

%             signal(signal>background) = background(signal>background);
end
x = time;
background =zeros(size(x));
for k = 1:(order+1)
    background = background + fo.(['p' num2str(k)])*x.^(order-k+1);
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

