

function [cellSampleSpace] = getCellSampleSpace(vecSampleSpace)
    n = length(vecSampleSpace);
    cellSampleSpace = cell(n, 1);
    for i = 1:n
        cellSampleSpace{i} = vecSampleSpace(i);
    end
end
