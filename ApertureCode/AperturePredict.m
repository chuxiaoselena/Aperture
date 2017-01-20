function scores = AperturePredict(Aperture, net)

%-------------   image pre-process  ---------------
for i = 1:length(Aperture)
    im = Aperture{i};
    im = permute(im,[2,1,3]);       % switch dim1 and dim2
    im = im(:,:,3:-1:1);            % RGB to BGR
    mean_pixel = 128;
    mean_pixel = single(mean_pixel);
    mean_pixel = permute(mean_pixel, [3,1,2]);
    im = single(im);
    Aperture{i} = bsxfun(@minus, im, mean_pixel);
end

scores = net.forward(Aperture);  



