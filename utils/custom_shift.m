function [sig] = custom_shift(sig,shift)

sig = fraccircshift(sig,[shift,0]);
% sig(1:floor(shift)) = 0;




end
