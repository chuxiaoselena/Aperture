function prepare_aperture(pos_train, pos_val, neg_train, tsize)
conf = global_conf();
cachedir = conf.cachedir;


clusters = learn_clusters(pos_train, pos_val, tsize);
psize = [150 150];

%% validation data
label_val = derive_labels('val', clusters, pos_val, tsize);
val_imdata = num2cell(pos_val);
val_labels = num2cell(label_val);
wt_dir = '../../dataset/patch/';
write_patch(val_imdata, val_labels, wt_dir, psize, 'val');

%% generate dummy labels for negative images
label_train = derive_labels('train', clusters, pos_train, tsize);
dummy_label = struct('mix_id', cell(numel(neg_train), 1), ...
    'global_id', cell(numel(neg_train), 1));
rng(0);     % reproduce results
train_imdata = cat(1, num2cell(pos_train), num2cell(neg_train));
train_labels = cat(1, num2cell(label_train), num2cell(dummy_label));

psize = tsize * conf.step;
% permute training items
perm_idx = randperm(numel(train_imdata));
train_imdata = train_imdata(perm_idx);
train_labels = train_labels(perm_idx);

write_patch(train_imdata, train_labels, wt_dir, 'train');

