addpath('D:\Code\Janelia Farm\CurrentVersion\MEX\x64');
addpath('D:\Code\Janelia Farm\CurrentVersion\');
%addpath('D:\Code\Janelia Farm\CurrentVersion\Viterbi');
a3bIntersections =fnEllipseEllipseIntersectionMex((X),(Y),(A),(B),(Theta));
[a2iPairToCol,a2iSwapLookup]=fnGenerateLookupsForTransition(iNumMice);
fSwapPenalty = -500;
load('Debug2');
%save('Debug2','a3bIntersections','a2iPairToCol','a2iSwapLookup','fSwapPenalty');

a3fTransitions = fnViterbiTransition(a3bIntersections, a2iPairToCol, a2iSwapLookup, fSwapPenalty);



tic
[a2fLikelihood] = fnViterbiLikelihood(a2iAllStates',a3fClassifiersResult, a2fMu, a2fSig);
toc
% 
 a2fLikelihood = log(bsxfun(@rdivide, exp(a2fLikelihood), sum(exp(a2fLikelihood),1)));
% 
figure;
imagesc(a2fLikelihood)

iNumFrames = size(a3fClassifiersResult,3);
iNumStates = 24;
a2fLikelihood  = zeros(iNumStates,iNumFrames);
for iFrameIter=1:iNumFrames
    a2fLikelihood(:,iFrameIter) = fnViterbiProbObsAllStatesExp(a2iAllStates, ...
        a3fClassifiersResult(:,:,iFrameIter), a2fMu,a2fSig);
end

[a2fLikelihood-a2fLikelihood2]