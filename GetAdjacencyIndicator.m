function [border_lengths] = GetAdjacencyIndicator(segments, params)
% Returns a matrix of nxn where n is the number of segments that contains
% in cell (i,j) the length of a border between segment i and segment j (or
% zero if there's no such border.
seg_num = max(segments(:));
border_lengths = zeros(seg_num, seg_num);
for ind_seg = 1:seg_num
    seg_det = zeros(size(segments));
    seg_det(segments == ind_seg) = 1;
    seg_border = GetSegmentBorders(seg_det);
    neighbors = segments(seg_border > 0);
    neigh_unique = unique(neighbors);
    for ind_neigh = 1:length(neigh_unique)
        ind_seg_neigh = neigh_unique(ind_neigh);
        border_length = length(neighbors(neighbors == ind_seg_neigh));
        border_lengths(ind_seg, ind_seg_neigh) = border_length;
        border_lengths(ind_seg_neigh, ind_seg) = border_length;
    end
end
end