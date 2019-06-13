% function file for exercise 6
% Author: Edward J. Xu, Sanaz
% Date: 190613
% ######################################################################################################################
function [cellArraySSpace] = getSampleSpace2(m, nRow)
    % nRow = 6
    cellSampleSpace = getSampleSpace(m);
    nCol = length(cellSampleSpace) / nRow;
    if mod(nCol, 1) ~= 0
        error("nRow is impossible!!!")
    end
    cellArraySSpace = {};
    k = 1;
    for i = 1:nRow
        for j = 1:nCol
            cellArraySSpace(i, j) = cellSampleSpace(k);
            k = k + 1;
        end
    end
end


function [cellSampleSpace] = getSampleSpace(m)
    cellSampleSpace = {};
    for i = 0:m
        for j = 0:m
            if (0 <= i + j) & (i + j <= m)
                cellSampleSpace{end+1} = [i, j];
            end
        end
    end
    cellSampleSpace = cellSampleSpace(randperm(length(cellSampleSpace)));
end
