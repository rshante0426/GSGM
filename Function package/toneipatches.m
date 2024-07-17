function [neipatches_t1, neipatches_t2] = toneipatches(image_t1, image_t2, centre_x, centre_y, p_s)
% function: Retrieves all blocks in the search area
% centre_x: The central pixel index of all patches in the image_t1 search area
% centre_y: The central pixel index of all patches in the image_t2 search area
% p_s: patch size
%%
[~,~,d1] = size(image_t1);
[~,~,d2] = size(image_t2);
neipatches_t1 = zeros(length(centre_x) * length(centre_y), (2*p_s+1).^2 * d1);
neipatches_t2 = zeros(length(centre_x) * length(centre_y), (2*p_s+1).^2 * d2);

k = 1;
for t_x = 1:length(centre_x)
    for t_y = 1:length(centre_y)
        x = centre_x(t_x) - p_s : centre_x(t_x) + p_s;
        y = centre_y(t_y) - p_s : centre_y(t_y) + p_s;
        patch_t1 = image_t1(x,y,:);
        patch_t2 = image_t2(x,y,:);
        neipatches_t1(k,:) = patch_t1(:);
        neipatches_t2(k,:) = patch_t2(:);
        k = k+1;
    end
end
end