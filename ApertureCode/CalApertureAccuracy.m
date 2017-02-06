function Acc = CalApertureAccuracy(scores,range, NAP, NPart)

if NAP*NPart~=length(scores)
    error('Score dimension do not match targets');
end

Acc = zeros(NAP, NPart);

for i = 1:Npart
    for j = 1:NAP
        n = (i-1)*NAP:i*NAP;
        id = mappingID(scores(n).id,range);
    end
    if id == i
        Acc(j, i) = 1;
    end
end

end


function slot = mappingID(val, range)
    slot = 0;
    for i = 1:length(range)
        if(val<=range(i).end)
            slot = i;
            break;
        end
    end
    if(slot==0), slot = 27; end
end