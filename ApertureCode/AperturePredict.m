function scores = AperturePredict(Aperture, net)

%-------------   image pre-process  ---------------
for i = 1:length(Aperture)
    im = Aperture{i};
    im = permute(im,[2,1,3]);       % switch dim1 and dim2
    im = im(:,:,3:-1:1);            % RGB to BGR
    im = imresize(im,[36,36]);
    mean_pixel = 128;
    mean_pixel = single(mean_pixel);
    mean_pixel = permute(mean_pixel, [3,1,2]);
    im = single(im);
    input = bsxfun(@minus, im, mean_pixel);
    score = net.forward({input}); 
    [scores(i).val, scores(i).id] = max(score{1});
end





