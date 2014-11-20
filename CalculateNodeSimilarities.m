function similarity_struct = CalculateNodeSimilarities(I, segments, chosen_struct, params)
if chosen_struct.chosen_num<2
    similarity_struct.similarity_vector = [];
else
    n_segments = max(segments(:));
    similarity_vector1 = CalculateNodeSimilaritiesHists(I, segments, chosen_struct, params);
    similarity_vector2 = CalculateNodeSimilaritiesNuclei(I, segments, chosen_struct, params);
    
    similarity_struct.similarity_vector = similarity_vector1 .* similarity_vector2;
%     similarity_struct.similarity_vector =  similarity_vector2;
    
    similarity_struct.adjacency_indicator = GetAdjacencyIndicator(segments, params);
    similarity_struct.similarity_matrix = GetSimilarityMatrix(I, segments, similarity_struct.adjacency_indicator, params);
%     similarity_struct.dissimilarity_matrix = GetDissimilarityMatrix(I, segments, similarity_struct.adjacency_indicator, params);
end
end

function similarity_vector1 = CalculateNodeSimilaritiesHists(I, segments, chosen_struct, params)
n_segments = max(segments(:));
similarity_vector1 = zeros(2,n_segments);

for seg_ind = 1:n_segments
    similarity_vector1(1,seg_ind) = CompareSegmentsHists(seg_ind, chosen_struct.chosen(1), segments, I, params);
    similarity_vector1(2,seg_ind) = CompareSegmentsHists(seg_ind, chosen_struct.chosen(2), segments, I, params);    
end
%     similarity_struct.similarity_vector = similarity_vector1 .* similarity_vector2;
end

function similarity_vector2 = CalculateNodeSimilaritiesNuclei(I, segments, chosen_struct, params)
n_segments = max(segments(:));
similarity_vector2 = zeros(2,n_segments);



for seg_ind = 1:n_segments
    similarity_vector2(1,seg_ind) = CompareSegmentsNuclei(seg_ind, chosen_struct.chosen(1), segments, I, params);
    similarity_vector2(2,seg_ind) = CompareSegmentsNuclei(seg_ind, chosen_struct.chosen(2), segments, I, params);
end
%     similarity_struct.similarity_vector = similarity_vector1 .* similarity_vector2;
end

