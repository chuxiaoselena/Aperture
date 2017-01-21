% This is the test code
startup;
global GLOBAL_OVERRIDER;
GLOBAL_OVERRIDER = @lsp_conf;
conf = global_conf();
pa = conf.pa;
p_no = numel(pa);
cachedir = conf.cachedir;
modeldir = '../../model/LSP_iter_115000.caffemodel';
deploydir = 'proto/highdim/deploy.prototxt';
caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(1);
net = caffe.Net(deploydir, modeldir, 'test');

% net=matcaffe_init(use_gpu, deploydir, modeldir,gpu_id);
Apsize = [24 48 72 96 120, 144];
pos_test = LSP_test_data();
label = 1:26;
label = repmat(label,[length(Apsize), 1]);
label = label(:);

for i = 1:length(pos_test)
    im = imread(pos_test(i).im);
    cpatch = crop_patch_test(pos_test(i), [150 150]);
    for n = 1:length(cpatch)
        for m = 1:length(Apsize)
            id = (n-1)*length(Asize)+m;
            Aperture{id} = MaskPatch(cpatch(n).patch, Apsize(m));
        end
    end
    scores = AperturePredict(Aperture, net);
    Acc{i} = CalApertureAccuracy(scores,label);
end