function ssimValue = local_ssim(centerBlock, neighborBlock, constant1, constant2)
% Computes the Structural Similarity Index (SSIM) between a center block and a neighboring block.
%
% centerBlock: Matrix representing the center block.
% neighborBlock: Matrix representing the neighboring block.
% constant1, constant2: Constants used to stabilize the SSIM computation (usually very small positive numbers).

% Calculate means of blocks
meanCenter = mean(centerBlock, 2);
meanNeighbor = mean(neighborBlock, 2);

% Calculate variances of blocks
varCenter = var(centerBlock, 0, 2); % '0' as the normalization flag is not needed in recent MATLAB versions
varNeighbor = var(neighborBlock, 0, 2);

% Compute SSIM using the formula
ssimValue = ((2 .* meanCenter .* meanNeighbor + constant1) .* ((varCenter .* varNeighbor) .^ 0.5 + constant2)) ./ ...
            ((meanCenter .^ 2 + meanNeighbor .^ 2 + constant1) .* (varCenter + varNeighbor + constant2));
end