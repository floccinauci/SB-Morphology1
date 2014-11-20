function res = EvaluateNucleiSegmentation(nuclei_ind, params)
epsilon = 1;
do_regionprops = 0;
thresh = 0.4;

tic

[gr_x, gr_y] = imgradient(nuclei_ind, 'CentralDifference');
gr_bin = abs(gr_x) + abs(gr_y);
gr_bin(gr_bin<thresh) = 0;
gr_bin(gr_bin>=thresh) = 1;
gr_bin = gr_bin.*nuclei_ind;

CC = bwconncomp(nuclei_ind,4);
sizes = cat(1,CC.PixelIdxList);

if do_regionprops
    
    % properties = {'Area','ConvexArea', 'Eccentricity', 'FilledArea', 'Perimeter', 'MajorAxisLength'};
    properties = {'FilledArea', 'Perimeter'};
    tic
    RegProps = regionprops(CC,properties);
    rprop_time = toc
    areas = cat(1,RegProps.FilledArea);
    Ra = sqrt(areas/pi);
    perimeters = cat(1,RegProps.Perimeter);
    Rp = perimeters/(2*pi);
    Rp(Rp < epsilon) = epsilon;
    
    res = mean(Ra./Rp);
    
else
    
    
    L = labelmatrix(CC);
    [sorted_labels, sort_indices] = sort(L(L>0),'ascend'); %labels of different regions sorted by lebel.
    sorted_edges = gr_bin(L>0);
    sorted_edges = sorted_edges(sort_indices); %an array containing for each element in sorted_labels '1' if that element is on an edge of a region.
    tmp = circshift(sorted_labels,1);
    area_indicators = abs(int16(tmp) - int16(sorted_labels));
    region_start_indices = find(area_indicators);
    areas = ones(sorted_labels(end),1);
    perimeters = ones(sorted_labels(end),1);
    for region_ind = 2:length(region_start_indices)
        region_ind1 =  region_start_indices(region_ind - 1);
        region_ind2 =  region_start_indices(region_ind);
        areas(region_ind-1) = region_ind2 - region_ind1;
        perimeters(region_ind-1) = sum(sorted_edges(region_ind1:region_ind2));
    end
    
    
    Ra = sqrt(areas/pi);
    Rp = perimeters/(2*pi);
    Rp(Rp < epsilon) = epsilon;
    res = mean(Ra./Rp);
    
end

sort_time = toc




