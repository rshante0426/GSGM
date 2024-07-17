clear all; close all;
%% Code Introduction
% Title: Global Structure Graph Mapping for Multimodal Change Detection
% Authors: Te Han et al.
% Content Description: This paper introduces a novel approach to Multimodal Change Detection (MCD) 
% named Global Structure Graph Mapping (GSGM). The technique extracts 'comparable' structural features 
% between multimodal datasets and constructs a Global Structure Graph (GSG) representing the structural
% information of each multi-temporal image set, facilitating change detection among multimodal images.
% DOI:10.1080/17538947.2024.2347457
% Please feel free to cite our paper.

%% Load Images --------------------------------------------------------------
% Define types of the two images
imageType_t1 = 'Opt'; % 'SAR' or 'Opt'
imageType_t2 = 'SAR'; % 'SAR' or 'Opt'

% Specify image file paths
basePath = 'filepath';
file_image_t1 = 'filename1.tif';
file_image_t2 = 'filename2.tif';
file_Ref_gt = 'filename_ref.tif';

% Read images
image_t1 = imread(fullfile(basePath, file_image_t1));
image_t2 = imread(fullfile(basePath, file_image_t2));
Ref_gt = imread(fullfile(basePath, file_Ref_gt));

% Apply log transformation based on image type
if strcmpi(imageType_t1, 'SAR')
    fprintf('Image T1 is SAR type, applying log transformation...\n');
    image_t1 = logtrans(image_t1);
end

if strcmpi(imageType_t2, 'SAR')
    fprintf('Image T2 is SAR type, applying log transformation...\n');
    image_t2 = logtrans(image_t2);
end

fprintf(['\nData has been loaded......\n'])
image_t1 = tonorm(image_t1);
image_t2 = tonorm(image_t2);
figure, imshow(image_t1, []);axis on
figure, imshow(image_t2, []);axis on
figure,imshow(Ref_gt,[]),title('Change Reference Map');
fprintf(['\nGSGM is running......\n'])

%% Parameter Settings --------------------------------------------------------------------------------------
[~,~,B1] = size(image_t1);
[H,W,B2] = size(image_t2);
opt.p_s = 3;  % Block size: [2 * opt.p_s + 1, 2 * opt.p_s + 1]
opt.w_s_H = floor(H / 2);
opt.w_s_W = floor(W / 2);
alpha_delt_s = 0.1;
opt.delt_s = floor(alpha_delt_s * min(opt.w_s_H,opt.w_s_W)); % Step size of neighboring blocks
opt.delt_p = opt.p_s; % opt.p_s <= opt.delt_p <= 2 * opt.p_s +1  Step size of central block
opt.c1 = 0.01;
opt.c2 = 0.03;
opt.lamda = 2;
opt.lamda_fusion = 2;

%% Structural Difference Calculation ----------------------------------------------------------------------
[difX, difY, DI_fw, DI_bw] = calculateStructureDifferences(image_t1, image_t2, opt);
DI_fw = tonorm(remove_outlier(DI_fw));
DI_bw = tonorm(remove_outlier(DI_bw));
figure,imshow(DI_fw,[]);title('DIfw');
colormap(parula);
colorbar;
figure,imshow(DI_bw,[]);title('DIbw');
colormap(parula);
colorbar;
fprintf('\nForward and backward DIs calculation completed...\n');

%% Difference Image Fusion ---------------------------------------------------------------------------------
DI_fusion = DI_Fusion(DI_fw, DI_bw);
figure,imshow(DI_fusion,'border','tight');
colormap(parula);
colorbar;
fprintf('\nDI_fusion is completed...\n');

%% Change Detection Map Generation
CM = CM_Generation(DI_fusion, Ref_gt);
figure,imshow(CM,[]);title('Change Map');

%% Accuracy Assessment
[fp,fn,oe,oa,kappa,multivalue,F1]=perfor_multivalue(CM, Ref_gt);
fprintf('Accuracy OA is: %4.4f Kappa coefficient KC is: %4.4f F1 score is: %4.4f \n', oa, kappa, F1);
uni_value = [0;100;180;255];
row_num = size(uni_value, 1);
color = cell(row_num, 1);
color{1} = [255, 250, 236];  %%%  255,235,181
color{2} = [255, 78, 0];
color{3} = [28, 28, 28];
color{4} = [29, 121, 192];
[img_color] = Gray2Color(multivalue, row_num, uni_value, color);
figure, imshow(img_color);
