function similarity_matrix = GetSimilarityMatrix(I, segments, adjacency_indicator, params)
% Returns a matrix of nxn, where n is the number of segments. Element (i,j)
% in the matrix holds the similarity value betwee segment i and segment j,
% if they share a common border, and 0 otherwise. Possibly, the similarity
% value should later be multiplied by the shared border length.
seg_num = size(adjacency_indicator,1);
similarity_matrix = zeros(seg_num, seg_num);

for ind_seg1 = 1:seg_num
    for ind_seg2 = ind_seg1:seg_num
        border_len = adjacency_indicator(ind_seg1, ind_seg2);
        if border_len>0
            %
            similarity_matrix(ind_seg1, ind_seg2) = CompareSegmentsHists(ind_seg1, ind_seg2, segments, I, params) * CompareSegmentsNuclei(ind_seg1, ind_seg2, segments, I, params);
        end
    end
end