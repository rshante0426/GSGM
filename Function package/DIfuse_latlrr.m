function [F ,F_lrr,F_saliency, I_E] = DIfuse_latlrr(DI_fw, DI_bw, lambda)
%%%% Two difference images are fused using the latlrr algorithm
index = 2;

% DI_fw = double(DI_fw);
% DI_bw = double(DI_bw);

% lambda = 2;
% disp('latlrr');

X1 = DI_fw;
[Z1,L1,E1] = latent_lrr(X1,lambda);
X2 = DI_bw;
[Z2,L2,E2] = latent_lrr(X2,lambda);

% disp('latlrr');

I_lrr1 = X1*Z1;
I_saliency1 = L1*X1;
I_lrr1 = max(I_lrr1,0);
I_lrr1 = min(I_lrr1,1);
I_saliency1 = max(I_saliency1,0);
I_saliency1 = min(I_saliency1,1);
I_e1 = E1;

I_lrr2 = X2*Z2;
I_saliency2 = L2*X2;
I_lrr2 = max(I_lrr2,0);
I_lrr2 = min(I_lrr2,1);
I_saliency2 = max(I_saliency2,0);
I_saliency2 = min(I_saliency2,1);
I_e2 = E2;

% lrr part
F_lrr = (I_lrr1+I_lrr2)/2;
% saliency part
% F_saliency = I_saliency1 + I_saliency2;
F_saliency = I_saliency1 .^2 + I_saliency2 .^2;
% F_saliency = (I_saliency1 + I_saliency2) .^ 2;

I_E = I_e1 + I_e2;
F = F_lrr+F_saliency;

end