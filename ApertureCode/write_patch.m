function write_patch(data, wt)

if ~isdir(wt), mkdir(wt); end
fid = fopen('/data1/Apert/dataset/patch/val.txt','w');
% tic;
for i = 1:length(test)
    if mod(i, 100) == 0
        %         toc;
        fprintf(1, 'valid %d/%d\n', i, length(data));
        %         tic;
    end
    im = imreadx(data(i));
    patch = crop_part(im,data(i).box);
    patch = imresize(patch, [psize, psize]);
    Aperture = MaskPatch(patch, data(i).Asize/2);
    
    imdir = [wt sprintf('%06d.png',i)];
    imwrite(Aperture,imdir);
    fprintf(fid,'%s %d\n',imdir, data(i).label);
end
fclose(fid);