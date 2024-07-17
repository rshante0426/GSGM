function DI_fusion = DI_Fusion(DI_fw, DI_bw)

DI_fw(isnan(DI_fw)) = 0;
DI_bw(isnan(DI_bw)) = 0;
DI_fw = tonorm(remove_outlier(DI_fw));
DI_bw = tonorm(remove_outlier(DI_bw));

% [DI_fusion ,F_lrr,F_saliency, I_E] = DIfuse_latlrr(DI_fw, DI_bw, opt.lamda_fusion);
% If faster computation is needed, a simple average weighted fusion can be employed.
DI_fusion = 0.5*(DI_fw+DI_bw);
DI_fusion = tonorm(DI_fusion);

end