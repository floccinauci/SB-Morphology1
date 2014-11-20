function seg_borders = GetSegmentBorders(seg_det)
% a function that receives a binary image and returns its border (i.e. all
% pixels adjacent to the area marked by ones in the image, but not inside
% it). Uses a 4-neighbor scheme.

seg_det_n = circshift(seg_det,-1, 1);
seg_det_n(end,:) = 0;
seg_det_s = circshift(seg_det,1, 1);
seg_det_s(1,:) = 0;

seg_det_w = circshift(seg_det,-1, 2);
seg_det_w(end,:) = 0;
seg_det_e = circshift(seg_det,1, 2);
seg_det_e(1,:) = 0;

seg_borders = max(max(max(seg_det_n, seg_det_s), max(seg_det_w, seg_det_e)), seg_det);
seg_borders = seg_borders.*(1-seg_det);


end