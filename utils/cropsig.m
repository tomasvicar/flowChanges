function [sig] = cropsig(sig,crop)

sig = sig(crop(1):end-crop(2)-1);

end

