function prepare_aperture(pos_train, pos_val, neg_train, tsize)
conf = global_conf();
cachedir = conf.cachedir;

try
    load([cache 'cluster_label.mat']);
catch
    clusters = learn_clusters(pos_train, pos_val, tsize);
    label_train = derive_labels('train', clusters, pos_train, tsize);
    label_val = derive_labels('val', clusters, pos_val, tsize);
    save([cache 'cluster_label.mat'],'label_train','label_val');
end

% generate dummy labels for negative images
dummy_label = struct('mix_id', cell(numel(neg_train), 1), ...
    'global_id', cell(numel(neg_train), 1));
rng(0);     % reproduce results
% trainining data
train_imdata = cat(1, num2cell(pos_train), num2cell(neg_train));
train_labels = cat(1, num2cell(label_train), num2cell(dummy_label));

psize = tsize * conf.step;
% permute training items
perm_idx = randperm(numel(train_imdata));
train_imdata = train_imdata(perm_idx);
train_labels = train_labels(perm_idx);
if ~exist([cachedir, 'LMDB_train'], 'dir')
    store_patch(train_imdata, train_labels, psize, [cachedir, 'LMDB_train']);
end
% validation data
val_imdata = num2cell(pos_val);
val_labels = num2cell(label_val);
psize = tsize * conf.step;
% if ~exist([cachedir, 'LMDB_val'], 'dir')
%     store_patch(val_imdata, val_labels, psize, [cachedir, 'LMDB_val']);
% end
val_wt = '/data1/Apert/dataset/patch/val/';
