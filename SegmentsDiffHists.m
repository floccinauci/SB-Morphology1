function res = SegmentsDiffHists(seg1, seg2, segments, I, params)

hist_bins = 0:1/params.hist_bin_num:1;

% seg1_vals = zeros(3,length(inds1));
% seg2_vals = zeros(3,length(inds2));
seg1_vals = zeros(3,length(hist_bins));
seg2_vals = zeros(3,length(hist_bins));


for chan_ind = 1:3
    tmp_chan = I(:,:,chan_ind);
    tmp =  histc(tmp_chan(segments == seg1), hist_bins);
    s = sum(tmp(:));
    if s>0
        seg1_vals(chan_ind,:) = tmp/s;
    end
    tmp =  histc(tmp_chan(segments == seg2), hist_bins);
    tmp = max(tmp(:)) - tmp;
    s = sum(tmp(:));
    if s>0
        seg2_vals(chan_ind,:) = tmp/s;
    end
end

res = params.hist_color_weights*sum(seg1_vals.*seg2_vals,2);
end