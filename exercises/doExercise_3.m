
function doExercise_3()

    % 2,  Simulate Distributions
    rng(2); vecRanNumNorm_2 = rand(10000, 1);
    rng(3); vecRanNumNorm_3 = rand(10000, 1);
    [vecX, vecProbClass] = distGeoPDF(vecRanNumNorm_2, 0.25, 100, 'figHistGeoPDF.png');
    vecX_dice = distDicePDF(vecRanNumNorm_2, 6, 'figHistDice.png');
    [vecX, vecProbClass] = distCrudePDF(vecRanNumNorm_2, [0 0.1 0.3 0.6 1], 'figHistCrudePDF.png');  % [0:0.1:1]
    [vecX, vecProbClass] = distExpPdf(vecRanNumNorm_2, 0.5, 100, 'figHistExp.png');
    vecTriU2 = cos(2 * pi * vecRanNumNorm_3);
    [vecSimNorm, vecProbClass] = distNormPdf(vecRanNumNorm_2, vecTriU2, 100, 'figHistNorm.png');
    [vecX, vecProbClass] = distParetoPdf(vecRanNumNorm_2, 1, 2.3, 100, 'figHistPareto1.png');
    [vecX, vecProbClass] = distParetoPdf(vecRanNumNorm_2, 1, 4, 100, 'figHistPareto2.png');
        
    h = lillietest(vecXx, 'Alpha', 0.05, 'Distribution','exponential');
end
