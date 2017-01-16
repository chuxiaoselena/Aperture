function [pos_trainval, neg_train, neg_val] = MPII_data_Patch(cls)
% conf = global_conf();
pa = [0 1 2 3 4 5 6 2 8 9 10 11 3 13 8 15 14 17 18 19 16 21 22 23];
cachedir = 'cache/mpii_data/';
if ~isdir(cachedir)
    mkdir(cachedir);
end
data_dir ='/data1/Apert/';
try
    load([cachedir cls]);
catch
    load('/data1/Apert/dataset/MPII/pos_trainval.mat','pos_train');
    % load('/data1/Apert/dataset/MPII/pos_trainval2.mat','pos_val');
    d_step = 45;
    degree = [-90:d_step:-d_step,d_step:d_step:90];
    trainval_frs_neg = 615:1832;    % training frames for negative

    ct = 0;
    for ii = 1:length(pos_train)
        for j = 1:length(pos_train(ii).person)
            ct = ct+1;
            all_pos(ct).im = [data_dir pos_train(ii).im];
            all_pos(ct).joints = pos_train(ii).person(j).jt;
            all_pos(ct).scale = pos_train(ii).person(j).scale;
            all_pos(ct).objpos = pos_train(ii).person(j).objpos;
            all_pos(ct).x1 = pos_train(ii).person(j).x1;
            all_pos(ct).y1 = pos_train(ii).person(j).y1;
            all_pos(ct).x2 = pos_train(ii).person(j).x2;
            all_pos(ct).y2 = pos_train(ii).person(j).y2;
            all_pos(ct).r_degree = 0;
            all_pos(ct).isflip = 0;
            ind_visiable = (pos_train(ii).person(j).jt(:,3)==0);
            all_pos(ct).invisiable = ind_visiable;
            ind_outsideIm = (pos_train(ii).person(j).jt(:,3) == -1);
            all_pos(ct).outsideIm = ind_outsideIm;
            check_outside = (pos_train(ii).person(j).jt(:,1) == -1);
            if sum(sum(check_outside-ind_outsideIm))~=0
                keyboard;
            end
        end
    end
    
    %---------------------- interpolated joints ---------------------------
    I = [1  2   3   4   4   5   6   6   7   8   9   9   10  11 11 ...
        12  13  13 14   15  15 16   17  17  18  19  19  20  21  21 ...
        22  23  23  24];
    J = [1  2   4   4   5   5   5   6   6   7   7   8    8   8  9   ...
        9   4   11  11  7   14 14   11  12  12  12  13  13  14  15 ...
        15  15  16  16];
    A = [1  1   1   1/2 1/2 1  1/2 1/2  1   1  1/2  1/2  1   1/2 1/2 ...
        1  1/2  1/2 1   1/2 1/2 1  1/2 1/2  1  1/2 1/2  1  1/2  1/2 ...
        1  1/2 1/2 1];
    Trans = full(sparse(I,J,A,24,16));
    mirror = [1 2 8 9 10 11 12 3 4 5 6 7 15 16 13 14 21 22 23 24 17 18 19 20];
    
    for i = 1:numel(all_pos)
        all_pos(i).joints = Trans * all_pos(i).joints(:,1:2); % linear combination
        
        all_pos(i).invisiable = Trans * all_pos(i).invisiable;
        all_pos(i).invisiable(all_pos(i).invisiable>0) = true;

        all_pos(i).outsideIm = Trans * all_pos(i).outsideIm;
        all_pos(i).outsideIm(all_pos(i).outsideIm>0) = true;
         
        all_pos(i).joints(logical(all_pos(i).outsideIm),:)=-1;
    end
    
    %   list = my_scale(all_pos, pa, 8); 
    % --------- flip and rotate trainval images --------
    try
        load([cachedir cls '_positive.mat']);
    catch
        fprintf(1,'Get train data fliped ...\n');
        all_pos = add_flip(all_pos, mirror);
        [pos_trainval, tsize] = init_scale_withInva(all_pos, pa, 4);
        fprintf(1,'Get train data rotated...\n');
        pos_trainval = add_rotate(pos_trainval,degree);
        for i = 1:length(pos_trainval)
            pos_trainval(i).joints(logical(pos_trainval(i).outsideIm),:)=-1;
        end
        save([cachedir cls '_positive.mat'],'pos_trainval','tsize');
    end
    % -------------------
    
    try 
        load([cachedir cls '_negative.mat']);
    catch
    fprintf(1,'Get negative sample\n');
    % grab neagtive image information
    negims = [data_dir 'dataset/INRIA/%05d.jpg'];
    if ~exist([data_dir 'dataset/INRIA'], 'dir')
        error('Please downlad INRIA dataset');
    end
    num = numel(trainval_frs_neg);
    neg = struct('im', cell(num, 1), 'joints', cell(num, 1), ...
        'r_degree', cell(num, 1), 'isflip', cell(num,1));
    
    for ii = 1:num
        fr = trainval_frs_neg(ii);
        neg(ii).im = sprintf(negims,fr);
        neg(ii).joints = [];
        neg(ii).r_degree = 0;
        neg(ii).isflip = 0;
    end
    % -------- flip negatives ----------
    val_id = randperm(numel(neg), 500);
    train_id = true(numel(neg), 1); train_id(val_id) = false;
    neg_train = neg(train_id); neg_val = neg(val_id);
    
    neg_train = add_flip(neg_train', []);
    neg_val = add_flip(neg_val', []);
    
    
    save([cachedir cls '_negative.mat'],'neg_train','neg_val');
    end
end

