% Create a mask filter, modified from code of Cheng Qiu.
function [centermask, bkgdmask] = create_mask(currApertureSize)
    % filter info
    L=18; %window width
    r=0.5; %taper ratio of tukey window

    %produce 2d tukey window
    h=tukeywin(L,r)*tukeywin(L,r)';
%     aperturesize = round((6:3:33)*desired_canonical_scale/50);% radius in pixel

    bkgdclr = 127;

    imgsize_x = 150; imgsize_y = 150;
    center_x = (imgsize_x - 1) / 2;
    center_y = (imgsize_y - 1) / 2;
    [xa, ya] = meshgrid(1:imgsize_x,1:imgsize_y);

%     currApertureSize = aperturesize(apertureind);
    centermask = double(sqrt((xa-center_x).^2 + (ya-center_y).^2) < currApertureSize);
    centermask = imfilter(centermask,h);

    % normalize
    centermask = centermask/max(centermask(:));
    bkgdmask = bkgdclr*(1-centermask);

end

% for ich = 1:3
%     masked_patch(:,:,ich) = bkgdmask + double(input_patch(:,:,ich)).*centermask;
% end
