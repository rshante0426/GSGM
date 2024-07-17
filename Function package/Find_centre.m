function [centerX, centerY] = Find_centre(rowIndex, colIndex, windowHeight, windowWidth, patchSize, deltaStep, image)
% Get image dimensions
[height, width, ~] = size(image);

% Calculate the range for center points in the vertical direction
verticalSteps = floor((windowHeight - patchSize) / deltaStep);
verticalStartCheck = (rowIndex - verticalSteps * deltaStep - patchSize) > 0;
verticalEndCheck = (rowIndex + verticalSteps * deltaStep + patchSize) < height + 1;

% Calculate the range for center points in the horizontal direction
horizontalSteps = floor((windowWidth - patchSize) / deltaStep);
horizontalStartCheck = (colIndex - horizontalSteps * deltaStep - patchSize) > 0;
horizontalEndCheck = (colIndex + horizontalSteps * deltaStep + patchSize) < width + 1;

% Compute vertical center point coordinates
if verticalStartCheck && verticalEndCheck
    centerX = rowIndex - verticalSteps * deltaStep : deltaStep : rowIndex + verticalSteps * deltaStep;
elseif rowIndex - verticalSteps * deltaStep - patchSize < 1
    tempV = floor((rowIndex - patchSize - 1) / deltaStep);
    centerX = rowIndex - tempV * deltaStep : deltaStep : rowIndex + verticalSteps * deltaStep;
elseif rowIndex + verticalSteps * deltaStep + patchSize > height
    tempV = floor((height - rowIndex - patchSize) / deltaStep);
    centerX = rowIndex - verticalSteps * deltaStep : deltaStep : rowIndex + tempV * deltaStep;
else
    centerX = rowIndex;
end

% Compute horizontal center point coordinates
if horizontalStartCheck && horizontalEndCheck
    centerY = colIndex - horizontalSteps * deltaStep : deltaStep : colIndex + horizontalSteps * deltaStep;
elseif colIndex - horizontalSteps * deltaStep - patchSize < 1
    tempH = floor((colIndex - patchSize - 1) / deltaStep);
    centerY = colIndex - tempH * deltaStep : deltaStep : colIndex + horizontalSteps * deltaStep;
elseif colIndex + horizontalSteps * deltaStep + patchSize > width
    tempH = floor((width - colIndex - patchSize) / deltaStep);
    centerY = colIndex - horizontalSteps * deltaStep : deltaStep : colIndex + tempH * deltaStep;
else
    centerY = colIndex;
end
