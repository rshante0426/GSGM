function localIndices = local_position(index, patchStart, deltaPatch, imageHeight)
% Calculates the local indices around a given index within an image boundary.
% Ensures that the patch does not exceed the image boundaries.

% Adjust index for the start of the patch
adjustedIndex = index - patchStart;

% Determine the start and end of the local indices based on the image boundaries
startBound = max(1, adjustedIndex);
endBound = min(imageHeight, adjustedIndex + 2*patchStart);

% Calculate the starting point for the sequence
startSeq = ceil(startBound / deltaPatch) * deltaPatch + 1;

% Calculate the ending point for the sequence, ensuring it stays within bounds
endSeq = floor(endBound / deltaPatch) * deltaPatch;

% Generate the sequence of local indices
localIndices = startSeq:deltaPatch:endSeq;
end

