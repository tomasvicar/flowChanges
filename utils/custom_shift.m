function [sig] = custom_shift(sig,shift)

sig = fraccircshift(sig,[0,shift]);
% sig(1:floor(shift)) = 0;




end

