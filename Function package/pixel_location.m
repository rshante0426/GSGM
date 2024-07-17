function [localXIndices, localYIndices] = pixel_location(x, y, imageHeight, imageWidth, patchSize)
% Determines the local pixel indices surrounding a given point within image boundaries,
% ensuring the patch remains within the image's confines.

% Initialize the local index arrays without boundary consideration
localXIndices = x - patchSize : x + patchSize;
localYIndices = y - patchSize : y + patchSize;

% Adjust for the top and left boundaries
if x - patchSize < 1
    localXIndices = 1 : 1 + 2 * patchSize;
end
if y - patchSize < 1
    localYIndices = 1 : 1 + 2 * patchSize;
end

% Adjust for the bottom and right boundaries
if x + patchSize > imageHeight
    localXIndices = imageHeight - 2 * patchSize : imageHeight;
end
if y + patchSize > imageWidth
    localYIndices = imageWidth - 2 * patchSize : imageWidth;
end
end