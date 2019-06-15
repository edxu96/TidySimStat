

function [cellSampleSpace] = getCellSampleSpace2dim(vecData1, vecData2, n1, n2, funcLogic)
    cellSampleSpace = {};
    for i = 1:n1
        for j = 1:n2
            if funcLogic(vecData1(i), vecData2(j))
                cellSampleSpace{end + 1} = [vecData1(i), vecData2(j)];
            end
        end
    end
    cellSampleSpace = cellSampleSpace(randperm(length(cellSampleSpace)));
end
