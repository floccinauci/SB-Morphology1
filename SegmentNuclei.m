function nuclei_indicator = SegmentNuclei(I, nuclei_segmentation_struct, data_param)
epsilon = 0.00001;
% S = sum(abs(nuclei_segmentation_struct.weights));
% if S<epsilon
%     nuclei_segmentation_struct.weights = [1,1,1];    
% end


nuclei_map = I(:,:,1)*nuclei_segmentation_struct.weights(1) + I(:,:,2)*nuclei_segmentation_struct.weights(2) + I(:,:,3)*nuclei_segmentation_struct.weights(3);

M = max(nuclei_map(:));
m = min(nuclei_map(:));
nuclei_map = nuclei_map - m;
if M-m > epsilon
   nuclei_map = nuclei_map / (M-m);
end
nuclei_indicator = ones(size(nuclei_map));
nuclei_indicator(nuclei_map < nuclei_segmentation_struct.threshold(1)) = 0;
nuclei_indicator(nuclei_map > nuclei_segmentation_struct.threshold(2)) = 0;
