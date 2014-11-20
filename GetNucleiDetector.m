function nuclei_det = GetNucleiDetector(I, params)

nuclei_det = I(:,:,1);
nuclei_det(nuclei_det<params.nuclei_thresh_red) = 0;
nuclei_det(nuclei_det>=params.nuclei_thresh_red) = 1;
nuclei_det = 1-nuclei_det;

end