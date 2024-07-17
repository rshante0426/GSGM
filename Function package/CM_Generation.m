function CM = CM_generation(DI_fusion, Ref_gt)
Kappa = [];
Idx = [];
k = 1;
for i = 0.1:0.01:3
    thresh = i * mean(DI_fusion(:));
    CM = DI_fusion;
    CM(DI_fusion>thresh) = 255;
    CM(DI_fusion<=thresh) = 0;
    [fp,fn,oe,oa,kappa_temp,multivalue]=perfor_multivalue(CM, Ref_gt);%Performance evaluation function
    Kappa(k) = kappa_temp;
    Idx(k) = i;
    k = k+1;
end
[Kappa_max, I] = max(Kappa);
i = Idx(I);
thresh = Idx(I) * mean(DI_fusion(:));
fprintf('User-defined parameter i: %4.2f  Threshold thresh: %4.4f \n',i,thresh);

CM = DI_fusion;
CM(DI_fusion<=thresh) = 0;
CM(DI_fusion>thresh) = 255;

end