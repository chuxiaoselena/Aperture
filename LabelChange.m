% change the label from 9699 to 26

% Get the upper bound of each global id.
load('../../cache/global_id.mat');
for i = 1:length(global_IDs)
    range(i).end = max(max(max(global_IDs{i})));
end

dir = '../../cache/';
RewriteRang(range, dir, 'val');
RewriteRang(range, dir, 'train');

function RewriteRang(range, dir, type)
fread = fopen([dir, type '.txt']);
fwrite = fopen([dir 'new' type '.txt'],'w');
Cont = textscan(fread,'%s %d');
for i = 1:length(Cont{2})
    Cont{2}(i) = searchRange(Cont{2}(i), range);
    fprintf(fwrite, '%s %d\n',Cont{1}{i},Cont{2}(i));
end
fclose all;
end


function slot = searchRange(val, range)
slot = 0;
for i = 1:length(range)
    if(val<=range(i).end)
        slot = i;
        break;
    end
end
if(slot==0), slot = 27; end
end