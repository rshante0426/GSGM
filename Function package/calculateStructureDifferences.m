function [dif_x, dif_y, DI_fw, DI_bw] = calculateStructureDifferences(image_t1, image_t2, opt)
[H,W,B2] = size(image_t2);
dif_x = zeros(H,W);
dif_y = zeros(H,W);
dif_x1 = zeros(H,W);
dif_y1 = zeros(H,W);
dif_x2 = zeros(H,W);
dif_y2 = zeros(H,W);
for i = 1:opt.delt_p:H
    for j = 1:opt.delt_p:W
        % patch_0: the target patch
        % Finds the index of the pixel_location patch of the pixel (i,j)
        [x_location, y_location] = pixel_location(i,j,H,W,opt.p_s);
        patch_tar_t1 = image_t1(x_location,y_location,:);   
        patch_tar_t2 = image_t2(x_location,y_location,:);
        patch_tar_t1 = patch_tar_t1(:)';
        patch_tar_t2 = patch_tar_t2(:)';
        % find the centre for all candidate neighbors
        [centre_x, centre_y]=Find_centre(i,j,opt.w_s_H,opt.w_s_W,opt.p_s,opt.delt_s,image_t1);
        
        % Looking for neighborhood
        [patches_nei_t1, patches_nei_t2] = toneipatches(image_t1, image_t2, centre_x, centre_y, opt.p_s);
        
        % Calculate similarity using ssim
        patch_t1_temp = [patch_tar_t1; patches_nei_t1];
        patch_t2_temp = [patch_tar_t2; patches_nei_t2];
        patches_nei_num = size(patch_t1_temp, 1);
        patch_tar_t1_temp = patch_t1_temp(1,:);  % Target patch
        patch_tar_t2_temp = patch_t2_temp(1,:);
        patches_nei_t1_temp = patch_t1_temp(2:end,:); % Neighborhood patch
        patches_nei_t2_temp = patch_t2_temp(2:end,:);
        ssim_t1 = local_ssim(patch_tar_t1_temp, patches_nei_t1_temp, opt.c1, opt.c2);
        ssim_t2 = local_ssim(patch_tar_t2_temp, patches_nei_t2_temp, opt.c1, opt.c2);
        
        % in descending order, returns the value and index
        [value_t1, rank_t1] = sort(ssim_t1,'descend');
        [value_t2, rank_t2] = sort(ssim_t2,'descend');
        
        patches_nei_t1_temp_sort = patches_nei_t1_temp(rank_t1,:);
        patches_nei_t2_temp_sort = patches_nei_t2_temp(rank_t2,:);
        patches_nei_t1_temp_sort_map = patches_nei_t1_temp(rank_t2,:);
        patches_nei_t2_temp_sort_map = patches_nei_t2_temp(rank_t1,:);
        
        %(the change of blocks with the same time-phase similarity level relative to the center block) 
        % is solved using the global region
        dif_x_beta1_1t2 = exp(opt.lamda .* abs(ssim_t1(rank_t2) - mean(ssim_t1(rank_t2))));
        dif_x_beta1_t1 = exp(opt.lamda .* abs(value_t1 - mean(value_t1)));
        dif_y_beta1_2t1 = exp(opt.lamda .* abs(ssim_t2(rank_t1) - mean(ssim_t2(rank_t1))));
        dif_y_beta1_t2 = exp(opt.lamda .* abs(value_t2 - mean(value_t2)));
        
        dif_x1(i,j) = mean(abs(dif_x_beta1_1t2 .* ssim_t1(rank_t2) - dif_x_beta1_t1 .* value_t1));
        dif_y1(i,j) = mean(abs(dif_y_beta1_2t1 .* ssim_t2(rank_t1) - dif_y_beta1_t2 .* value_t2));
        
        % the change between blocks with the same level of similarity before and after the time)
        % is solved using the global region
        dif_x_beta2 = exp(opt.lamda .* abs(value_t1 - mean(value_t1)));
        dif_y_beta2 = exp(opt.lamda .* abs(value_t2 - mean(value_t2)));
        
        dif_x2(i,j) = exp(opt.lamda) - mean(dif_x_beta2 .* local_ssim(patches_nei_t1_temp_sort, patches_nei_t1_temp_sort_map,opt.c1, opt.c2));
        dif_y2(i,j) = exp(opt.lamda) - mean(dif_y_beta2 .* local_ssim(patches_nei_t2_temp_sort, patches_nei_t2_temp_sort_map,opt.c1, opt.c2));
        
        dif_x(i,j) = dif_x1(i,j) +  dif_x2(i,j);
        dif_y(i,j) = dif_y1(i,j) +  dif_y2(i,j);
    end
end

DI_fw = zeros(H,W);
DI_bw = zeros(H,W);
parfor i = 1:H
    for j = 1:W
        local_i = local_position(i,opt.p_s,opt.delt_p,H);
        local_j = local_position(j,opt.p_s,opt.delt_p,W);
        DI_fw(i,j) = mean(mean(dif_y(local_i,local_j)));
        DI_bw(i,j) = mean(mean(dif_x(local_i,local_j)));
    end
end

fprintf(['\n Forward and backwar DIs  are calculated......' '\n'])
