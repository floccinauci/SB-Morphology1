function res = SegmentsDiffNuclei(seg1, seg2, segments, I, params)
epsilon = 0.00001;
nuclei_det = I(:,:,1);
nuclei_det(nuclei_det<params.nuclei_thresh_red) = 0;
nuclei_det(nuclei_det>=params.nuclei_thresh_red) = 1;
nuclei_det = 1-nuclei_det;
blank = ones(size(nuclei_det));

% CC = bwconncomp(nuclei_det);
% labels = labelmatrix(CC);
s1 = sum(blank(segments == seg1));
if s1 > 0
    fraction1 = sum(nuclei_det(segments == seg1))/sum(blank(segments == seg1));
else
    fraction1 = 0;
end
if fraction1<epsilon
    fraction1 = epsilon;
end

s2 = sum(blank(segments == seg2));
if s2>0
    fraction2 = sum(nuclei_det(segments == seg2))/s2;
else
    fraction2 = 0;
end
if fraction2<epsilon
    fraction2 = epsilon;
end

if min(fraction1, fraction2) < epsilon
    res = 10;
else
    res = max(fraction1/fraction2, fraction1/fraction1)-1;
end
end