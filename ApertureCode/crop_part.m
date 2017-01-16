function patch = crop_part(im,box)

x1 = round(max(1, box(1)));
y1 = round(max(1, box(2)));
x2 = round(min(size(im, 2), box(3)));
y2 = round(min(size(im, 1), box(4)));

w = x2-x1+1;
h = y2-y1+1;

patch = im(y1:y2, x1:x2, :);
if w>h
    dif = w-h;
    padpatch = ones(h, round(dif/2), 3)*128;
    patch = cat(2, padpatch, patch, padpatch);
elseif h>w
    dif = h-w;
    padpatch = ones(round(dif/2), w, 3)*128;
    patch = cat(1, padpatch, patch, padpatch);
end

