function main
clear all;
close all;

global chosen_struct I segments similarity_struct params data_index DATA_NAMES cancer_mask manual_segm

if ~exist('vl_version')
    a=1
    run('./vlfeat/toolbox/vl_setup.m');
end
vl_version verbose
if ~exist('maxflowmex')
    a=2
    mex maxflowmex.cpp maxflow-v3.0/graph.cpp maxflow-v3.0/maxflow.cpp  -largeArrayDims
end

cancer_mask = [];

% DATA_NAMES = {'0034', '0037', '0085', '0137', '0138', '0139', '0141', '0143', '0145', '0147', '0148', '0171', '0173', '0881', '1037', '1459', '1795', '1823', '1825', '2619', '5953', '5954', '5955', '5958', '5959'};
DATA_NAMES = { '0148', '1037', '2619'};
data_index = 1;
data_name = DATA_NAMES{data_index};
chosen_struct.chosen_num = 0;
chosen_struct.chosen = zeros(2,1);

similarity_struct.similarity_vector = zeros(2,1);


[I, params, manual_segm] = GetData(data_name);
[segments] = SuperpixelData(I, params);
h = figure('position',[10,100,1900,830]);
hax = axes('Units','pixels');
DrawResults(I, segments, chosen_struct, similarity_struct, cancer_mask, manual_segm, params);

uicontrol('Style', 'slider',...
    'Min',1,'Max',length(DATA_NAMES),'Value',data_index,...
    'SliderStep', [1/(length(DATA_NAMES)-1) 0.1], ...
    'Position', [20 23 120 20],...
    'Callback', {@set_data_index,hax});   % Uses cell array function handle callback
uicontrol('Style','text',...
    'Position',[20 45 120 20],...
    'String','Index')
uicontrol('Style','text',...
    'Position',[20 2 30 20],...
    'String',sprintf('%d', 1))
uicontrol('Style','text',...
    'Position',[100 2 30 20],...
    'String',sprintf('%d', length(DATA_NAMES)))

end

function [I, params, manual_segm] = GetData(data_name)
params = GetDataParams(data_name);
[I, manual_segm] = ReadData(data_name);
end

function set_data_index(hObj,event,ax)
% Called to set zlim of surface in figure axes
% when user moves the slider control
global data_index params DATA_NAMES I segments chosen_struct similarity_struct cancer_mask manual_segm

data_index = round(get(hObj,'Value'));
data_name = DATA_NAMES{data_index};

chosen_struct.chosen_num = 0;
chosen_struct.chosen = zeros(2,1);

similarity_struct.similarity_vector = zeros(2,1);

[I, params, manual_segm] = GetData(data_name);

[segments] = SuperpixelData(I, params);

DrawResults(I, segments, chosen_struct, similarity_struct, cancer_mask, manual_segm, params);

end

function [segments] = SuperpixelData(I, params)

if or(~params.do_load_superpixels, ~exist(sprintf('./saved/%s/segments.mat', params.data_filename), 'file'))
    
    %run SLIC
    S = size(I);
    regionSize = round( (S(1))/params.SLIC_segment_num); %1000 ;
    regularizer = params.SLIC_regularizer;
    Ilab = single(vl_xyz2lab(vl_rgb2xyz(I)));
    segments = vl_slic(Ilab, regionSize, regularizer) + 1;
    
    
    % compact the segment enumeration:
    ind_seg = 1;
    ind_seg_true = 1;
    max_seg = max(segments(:));
    for ind_seg = 1:max_seg
        inds = find(segments == ind_seg);
        if ~isempty(inds)
            segments(inds) = ind_seg_true;
            ind_seg_true = ind_seg_true+1;
        end
    end
    
    
    save(sprintf('./saved/%s/segments.mat', params.data_filename), 'segments');
else
    load(sprintf('./saved/%s/segments.mat', params.data_filename), 'segments');
end


end

function DrawResults(I, segments, chosen_struct, similarity_struct, cancer_mask, manual_segm,  params)
[Gmag, Gdir] = imgradient(segments,'IntermediateDifference');
Gbin=(Gmag>0);
Gbin=max(max(max(circshift(Gbin, 1, 1), circshift(Gbin, -1, 1)), max(circshift(Gbin, 1, 2), circshift(Gbin, -1, 2))), Gbin);
Ipresent = I;
tmp_img_chan_1 = Ipresent(:,:,1);
tmp_img_chan_2 = Ipresent(:,:,2);
tmp_img_chan_3 = Ipresent(:,:,3);
tmp_img_chan_1(Gbin>0) = 0;
tmp_img_chan_2(Gbin>0) = 0.7;
tmp_img_chan_3(Gbin>0) = 0;

man_segments = GetSegmentsFromPoly(manual_segm, size(I));


if chosen_struct.chosen_num >=1
    tmp_img_chan_2(segments == chosen_struct.chosen(1)) = 1;
    if chosen_struct.chosen_num == 2
        tmp_img_chan_1(segments == chosen_struct.chosen(2)) = 1;
        
        cancer_borders = GetSegmentBorders(cancer_mask);
        Cbin = cancer_borders>0;
        Cbin=max(max(max(circshift(Cbin, 1, 1), circshift(Cbin, -1, 1)), max(circshift(Cbin, 1, 2), circshift(Cbin, -1, 2))), Cbin);
        tmp_img_chan_1(Cbin>0) = 0;
        tmp_img_chan_2(Cbin>0) = 0;
        
        tmp_img_chan_3(Cbin>0) = 0;
    end
end




if chosen_struct.chosen_num == 2
    segpresent = Ipresent*0;
    tmp_seg_chan_1 = segpresent(:,:,1);
    tmp_seg_chan_2 = segpresent(:,:,2);
    
    for ind_seg = 1:size(similarity_struct.similarity_vector,2)
        tmp_seg_chan_1(segments == ind_seg) = similarity_struct.similarity_vector(1,ind_seg);
        tmp_seg_chan_2(segments == ind_seg) = similarity_struct.similarity_vector(2,ind_seg);
    end
    segpresent(:,:,1) = tmp_seg_chan_1;
    segpresent(:,:,2) = tmp_seg_chan_2;
    segpresent = segpresent/max(segpresent(:));
    subplot('Position',[0.8, 0.27, 0.2, 0.2] )
    image(segpresent);
    
    subplot('Position',[0.8, 0.52, 0.2, 0.2] )
    imagesc(1-cancer_mask);
end

subplot('Position',[0.8, 0.77, 0.2, 0.2] )
imagesc(GetNucleiDetector(I, params));


tmp_img_chan_2 = tmp_img_chan_2 + 0.2*man_segments;
tmp_img_chan_2(tmp_img_chan_2>1) = 1;

Ipresent(:,:,1) = tmp_img_chan_1;
Ipresent(:,:,2) = tmp_img_chan_2;
Ipresent(:,:,3) = tmp_img_chan_3;


subplot('Position',[0.02, 0.2, 0.75, 0.65] )
ih = image(Ipresent);
title(params.data_filename);
set(ih,'ButtonDownFcn',{@MyButtonDown,ih});

subplot('Position',[0.8, 0.02, 0.2, 0.2] )

% imagesc(segments);
imagesc(man_segments);
end


function man_segments = GetSegmentsFromPoly(manual_segm, S)
man_segments = zeros(S(1), S(2));
if ~isempty(manual_segm)
    man_segments = roipoly(man_segments, manual_segm(:,1), manual_segm(:,2));
end
end


function MyButtonDown(varargin)
global I segments chosen_struct similarity_struct params cancer_mask manual_segm
epsilon = 0.0001;
if chosen_struct.chosen_num < 2
    a = get(gca,'CurrentPoint');
    chosen_struct.chosen_num = chosen_struct.chosen_num+1;
    
    chosen_struct.chosen(chosen_struct.chosen_num) = segments(round(a(1,2)), round(a(1,1)));
    
    if chosen_struct.chosen_num == 2
        if or(~params.do_load_similarity, ~exist(sprintf('./saved/%s/sim_struct.mat', params.data_filename), 'file'))
            
            similarity_struct = CalculateNodeSimilarities(I, segments, chosen_struct, params);
            
            save(sprintf('./saved/%s/sim_struct.mat', params.data_filename), 'similarity_struct');
        else
            load(sprintf('./saved/%s/sim_struct.mat', params.data_filename), 'similarity_struct');
        end
        %run the segmentation thing, or just comparison, for now
        if or(~params.do_load_cut, ~exist(sprintf('./saved/%s/cancer_mask.mat', params.data_filename), 'file'))
            tmp_weights = similarity_struct.similarity_matrix;
            tmp_weights = tmp_weights/max(tmp_weights(:));
            %             tmp_weights(tmp_weights>0) = 1-tmp_weights(tmp_weights>0);
            %             V = sparse(tmp_weights .* similarity_struct.adjacency_indicator);
            
            V = sparse(tmp_weights);
            V = V/sum(V(:));
            
            T = similarity_struct.similarity_vector';
            %             T(T<epsilon) = epsilon;
            %             T = 1./T;
            
            tmp1 = T(:,1); tmp1 = 10*tmp1/sum(tmp1(:));
            tmp2 = T(:,2); tmp2 = 10*tmp2/sum(tmp2(:));
            T(:,1) = tmp1;
            T(:,2) = tmp2;
            
            T = sparse(T);
            %             T = T/max(T(:));
            %             V = V/max(V(:));
            [flow, labels] = maxflow(V,T);
            cancer_mask = getInMask(segments, labels);
            save(sprintf('./saved/%s/cancer_mask.mat', params.data_filename), 'cancer_mask', 'labels');
        else
            load(sprintf('./saved/%s/cancer_mask.mat', params.data_filename), 'cancer_mask', 'labels');
        end
        
        cancer_mask = RetouchMask(cancer_mask, params);
        
    end
    
    
    
    
    DrawResults(I, segments, chosen_struct, similarity_struct, cancer_mask, manual_segm, params);
    
end
end


function res = RetouchMask(in_mask, params)

min_size = params.retouch_min_area_portion*size(in_mask,1)*size(in_mask,2);
%eliminate small bright objects
out_mask = in_mask*0;
CC = bwconncomp(in_mask);
for ind_cc = 1:CC.NumObjects
    if length(CC.PixelIdxList{ind_cc}) > min_size
        out_mask(CC.PixelIdxList{ind_cc}) = 1;
    end
end

%eliminate small dark objects
in_mask = 1-out_mask;
out_mask = in_mask*0;
CC = bwconncomp(in_mask);
for ind_cc = 1:CC.NumObjects
    if length(CC.PixelIdxList{ind_cc}) > min_size
        out_mask(CC.PixelIdxList{ind_cc}) = 1;
    end
end
in_mask = 1-out_mask;


SR = strel('disk', params.retouch_radius, 0);
res = imdilate(imerode(imerode(imdilate(in_mask, SR), SR), SR), SR);
% res = imerode(imdilate(imdilate(imerode(in_mask, SR), SR), SR), SR);



end

function res = getInMask(map, labels)
res = zeros(size(map));
for ind = 1:length(labels)
    res(map == ind) = labels(ind);
end
end
