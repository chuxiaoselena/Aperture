function write_patch(data, label, wt, psize, phase)

Apsize = [24 48 72 96 120, 144];
if ~isdir([wt phase '/']), mkdir([wt phase '/']); end
fid = fopen([wt phase '.txt'],'w');
for i = 1:length(data)
    if mod(i, 100) == 0
        fprintf(1, '%s %d/%d\n', i, length(data));
    end
    cpatch = crop_patch(data{i}, label{i}, psize);
    if strcmp(phase,'train')
        perm_idx = randperm(numel(train_imdata));
        cpatch = cpatch(perm_idx);
    end
    for j = 1:length(cpatch)
        imid = (i-1)*length(cpatch)+j;
        imwt = sprintf('%s%s/%06d.png',wt,phase,imid);
        Asize = Apsize(randi(length(Apsize)));
        Aperture = MaskPatch(cpatch(j).patch, Asize/2);
        imwrite(Aperture, imwt);
        fprintf(fid,'%s %d\n',imwt, label{i}.global_id(j));
    end
end
fclose(fid);