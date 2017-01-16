function Aperture = MaskPatch(patch, Asize)

[centermask, bkgdmask] = create_mask(Asize);

for ich = 1:3
    Aperture(:,:,ich) = bkgdmask + double(patch(:,:,ich)).*centermask;
end
Aperture = uint8(Aperture);

