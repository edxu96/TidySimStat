

function [cellArraySSpace] = getArraySampleSpace(cellSampleSpace, nRow)
    nCol = length(cellSampleSpace) / nRow;
    if mod(nCol, 1) ~= 0
        error('nRow is impossible!!!')
    end
    cellArraySSpace = cell(nRow, nCol);
    k = 1;
    for i = 1:nRow
        for j = 1:nCol
            cellArraySSpace(i, j) = cellSampleSpace(k);
            k = k + 1;
        end
    end
end
