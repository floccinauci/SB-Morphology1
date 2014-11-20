function main_nuclei

clear all;
close all;
addpath('./segment/');
addpath('./matlab_lee/nuclei/');
% addpath('./jsonlab/');

global I nuclei_segmentation_struct params DATA_NAMES data_index nuclei_map nuclei_seg_val pres_params manual_segm manual_segm_nuclei

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



nuclei_segmentation_struct.weights = [1,0,0];
nuclei_segmentation_struct.threshold = [0,0.5];

pres_params.x_point = 10;
pres_params.y_point = 10;
pres_params.do_select_zoom = 1;

DATA_NAMES = {'100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '0034', '0037', '0085', '0137', '0138', '0139', '0141', '0143', '0145', '0147', '0148', '0171', '0173', '0881', '1037', '1459', '1795', '1823', '1825', '5953', '5954', '5955', '5958', '5959', '2619', '4743'};
% DATA_NAMES = { '0148', '1037', '2619'};
data_index = 1;
data_name = DATA_NAMES{data_index};


[I, params, manual_segm, manual_segm_nuclei] = GetData(data_name);

nuclei_map = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
[~,L] = SegmentationProcessImageCooper(im2uint8(I), params);
tmp_map = L; tmp_map(tmp_map>0) = 1;
nuclei_map(:,:,2) = tmp_map;
nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

pres_params.zoom.inds = [1,1];
pres_params.zoom.dims = [size(I,1), size(I,2)];

h = figure('position',[10,100,1900,830]);
hax = axes('Units','pixels');
DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, DATA_NAMES{data_index}, pres_params);

ui_params.data_slider = uicontrol('Style', 'slider',...
    'Min',1,'Max',length(DATA_NAMES),'Value',data_index,...
    'SliderStep', [1/(length(DATA_NAMES)-1) 0.1], ...
    'Units','normalized','Position',[0.88 0.9 0.1 0.02],...
    'Callback', {@set_data_index,hax});   % Uses cell array function handle callback
uicontrol('Style','text',...
    'Units','normalized','Position',[0.9 0.88 0.06 0.02],...
    'String','Index')
uicontrol('Style','text',...
    'Units','normalized','Position',[0.88 0.88 0.02 0.02],...
    'String',sprintf('%d', 1))
uicontrol('Style','text',...
    'Units','normalized','Position',[0.96 0.88 0.02 0.02],...
    'String',sprintf('%d', length(DATA_NAMES)))


min_col_weight = -1;
max_col_weight = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pres_params.red_slider = uicontrol('Style', 'slider',...
    'Min',min_col_weight,'Max',max_col_weight,'Value',nuclei_segmentation_struct.weights(1),...
    'SliderStep', [0.02 0.1], ...
    'Units','normalized','Position',[0.88 0.8 0.1 0.02],...
    'Callback', {@set_nuclei_red_weight,hax});   % Uses cell array function handle callback
uicontrol('Style','text',...
    'Units','normalized','Position',[0.9 0.78 0.06 0.02],...
    'String','Red W.')
uicontrol('Style','text',...
    'Units','normalized','Position',[0.88 0.78 0.02 0.02],...
    'String',sprintf('%d', min_col_weight))
uicontrol('Style','text',...
    'Units','normalized','Position',[0.96 0.78 0.02 0.02],...
    'String',sprintf('%d', max_col_weight))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pres_params.green_slider = uicontrol('Style', 'slider',...
    'Min',min_col_weight,'Max',max_col_weight,'Value',nuclei_segmentation_struct.weights(2),...
    'SliderStep', [0.02 0.1], ...
    'Units','normalized','Position',[0.88 0.7 0.1 0.02],...
    'Callback', {@set_nuclei_green_weight,hax});   % Uses cell array function handle callback
uicontrol('Style','text',...
    'Units','normalized','Position',[0.9 0.68 0.06 0.02],...
    'String','Green W.')
uicontrol('Style','text',...
    'Units','normalized','Position',[0.88 0.68 0.02 0.02],...
    'String',sprintf('%d', min_col_weight))
uicontrol('Style','text',...
    'Units','normalized','Position',[0.96 0.68 0.02 0.02],...
    'String',sprintf('%d', max_col_weight))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pres_params.blue_slider = uicontrol('Style', 'slider',...
    'Min',min_col_weight,'Max',max_col_weight,'Value',nuclei_segmentation_struct.weights(3),...
    'SliderStep', [0.02 0.1], ...
    'Units','normalized','Position',[0.88 0.6 0.1 0.02],...
    'Callback', {@set_nuclei_blue_weight,hax});   % Uses cell array function handle callback
uicontrol('Style','text',...
    'Units','normalized','Position',[0.9 0.58 0.06 0.02],...
    'String','Blue W.')
uicontrol('Style','text',...
    'Units','normalized','Position',[0.88 0.58 0.02 0.02],...
    'String',sprintf('%d', min_col_weight))
uicontrol('Style','text',...
    'Units','normalized','Position',[0.96 0.58 0.02 0.02],...
    'String',sprintf('%d', max_col_weight))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pres_params.threshold_up_slider = uicontrol('Style', 'slider',...
    'Min',0,'Max',1,'Value',nuclei_segmentation_struct.threshold(2),...
    'SliderStep', [0.02 0.1], ...
    'Units','normalized','Position',[0.88 0.5 0.1 0.02],...
    'Callback', {@set_nuclei_threshold_up,hax});   % Uses cell array function handle callback
uicontrol('Style','text',...
    'Units','normalized','Position',[0.9 0.48 0.06 0.02],...
    'String','thresh_u')
uicontrol('Style','text',...
    'Units','normalized','Position',[0.88 0.48 0.02 0.02],...
    'String',sprintf('%d', 0))
uicontrol('Style','text',...
    'Units','normalized','Position',[0.96 0.48 0.02 0.02],...
    'String',sprintf('%d', 1))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pres_params.threshold_low_slider = uicontrol('Style', 'slider',...
    'Min',0,'Max',1,'Value',nuclei_segmentation_struct.threshold(1),...
    'SliderStep', [0.02 0.1], ...
    'Units','normalized','Position',[0.88 0.4 0.1 0.02],...
    'Callback', {@set_nuclei_threshold_low,hax});   % Uses cell array function handle callback
uicontrol('Style','text',...
    'Units','normalized','Position',[0.9 0.38 0.06 0.02],...
    'String','thresh_l')
uicontrol('Style','text',...
    'Units','normalized','Position',[0.88 0.38 0.02 0.02],...
    'String',sprintf('%d', 0))
uicontrol('Style','text',...
    'Units','normalized','Position',[0.96 0.38 0.02 0.02],...
    'String',sprintf('%d', 1))

pres_params.zoom_checkbox = uicontrol('style','checkbox','units','pixels','value', pres_params.do_select_zoom,...
                'Units','normalized','Position',[0.88 0.28 0.1 0.02],...
                'string','zoom',...
                'Callback', {@DoZoomCallback,hax});

pres_params.optimize_button = uicontrol('style','pushbutton','units','pixels',...
                'Units','normalized','Position',[0.88 0.18 0.1 0.02],...
                'string','Optimize',...
                'Callback', {@DoOptimizeCallback,hax});

% btn = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
%         'Position', [20 20 50 20],...
%         'Callback', 'cla');  


end

function DoOptimizeCallback(varargin)
global I params nuclei_segmentation_struct nuclei_seg_val nuclei_map manual_segm DATA_NAMES data_index pres_params manual_segm_nuclei
nuclei_segmentation_struct = OptimizeNucleiSegmentor(I, params);
nuclei_map(:,:,1) = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val(1) = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
% [~,L] = SegmentationProcessImageCooper(im2uint8(I));
% tmp_map = L; tmp_map(tmp_map>0) = 1;
% nuclei_map(:,:,2) = tmp_map;
% nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, DATA_NAMES{data_index}, pres_params);

end

function DoZoomCallback(hObject, eventdata, handles)
global pres_params

pres_params.do_select_zoom
if (get(hObject,'Value') == get(hObject,'Max'))
    % Checkbox is checked-take appropriate action
    pres_params.do_select_zoom = 1    
else
    % Checkbox is not checked-take appropriate action
    pres_params.do_select_zoom = 0
end

end


function [I, params, manual_segm, manual_segm_nuclei] = GetData(data_name)
params = GetDataParams(data_name);
[I, manual_segm, manual_segm_nuclei] = ReadData(data_name);
end

function set_data_index(hObj,event,ax)
% Called to set zlim of surface in figure axes
% when user moves the slider control
global data_index params DATA_NAMES I manual_segm nuclei_map nuclei_seg_val nuclei_segmentation_struct pres_params manual_segm_nuclei

data_index = round(get(hObj,'Value'));
data_name = DATA_NAMES{data_index};


[I, params, manual_segm, manual_segm_nuclei] = GetData(data_name);
nuclei_map = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
[~,L] = SegmentationProcessImageCooper(im2uint8(I), params);
tmp_map = L; tmp_map(tmp_map>0) = 1;
nuclei_map(:,:,2) = tmp_map;
nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

pres_params.x_point = 10;
pres_params.y_point = 10;
pres_params.zoom.inds = [1,1];
pres_params.zoom.dims = [size(I,1), size(I,2)];

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, data_name, pres_params);

end

function set_nuclei_red_weight(hObj,event,ax)
% Called to set zlim of surface in figure axes
% when user moves the slider control
global data_index params DATA_NAMES  I nuclei_segmentation_struct manual_segm nuclei_map nuclei_seg_val pres_params manual_segm_nuclei

nuclei_segmentation_struct.weights(1) = (get(hObj,'Value'));

nuclei_map(:,:,1) = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val(1) = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
% tmp_map = L; tmp_map(tmp_map>0) = 1;
% nuclei_map(:,:,2) = tmp_map;
% nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, DATA_NAMES{data_index}, pres_params);

end

function set_nuclei_green_weight(hObj,event,ax)
% Called to set zlim of surface in figure axes
% when user moves the slider control
global data_index params DATA_NAMES  I nuclei_segmentation_struct manual_segm nuclei_map nuclei_seg_val pres_params manual_segm_nuclei

nuclei_segmentation_struct.weights(2) = (get(hObj,'Value'));

nuclei_map(:,:,1) = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val(1) = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
% tmp_map = L; tmp_map(tmp_map>0) = 1;
% nuclei_map(:,:,2) = tmp_map;
% nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, DATA_NAMES{data_index}, pres_params);

end

function set_nuclei_blue_weight(hObj,event,ax)
% Called to set zlim of surface in figure axes
% when user moves the slider control
global data_index params DATA_NAMES  I nuclei_segmentation_struct manual_segm nuclei_map nuclei_seg_val pres_params manual_segm_nuclei

nuclei_segmentation_struct.weights(3) = (get(hObj,'Value'));

nuclei_map(:,:,1) = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val(1) = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
% tmp_map = L; tmp_map(tmp_map>0) = 1;
% nuclei_map(:,:,2) = tmp_map;
% nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, DATA_NAMES{data_index}, pres_params);

end


function set_nuclei_threshold_low(hObj,event,ax)
% Called to set zlim of surface in figure axes
% when user moves the slider control
global data_index params DATA_NAMES  I nuclei_segmentation_struct manual_segm nuclei_map nuclei_seg_val pres_params manual_segm_nuclei

nuclei_segmentation_struct.threshold(1) = (get(hObj,'Value'));

nuclei_map(:,:,1) = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val(1) = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
% tmp_map = L; tmp_map(tmp_map>0) = 1;
% nuclei_map(:,:,2) = tmp_map;
% nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, DATA_NAMES{data_index}, pres_params);

end

function set_nuclei_threshold_up(hObj,event,ax)
% Called to set zlim of surface in figure axes
% when user moves the slider control
global data_index params DATA_NAMES  I nuclei_segmentation_struct manual_segm nuclei_map nuclei_seg_val pres_params manual_segm_nuclei

nuclei_segmentation_struct.threshold(2) = (get(hObj,'Value'));

nuclei_map(:,:,1) = SegmentNuclei(I, nuclei_segmentation_struct, params);
nuclei_seg_val(1) = EvaluateNucleiSegmentation(nuclei_map(:,:,1), params);

% [~,L] = segmentNucleiCooper(im2uint8(I));
% tmp_map = L; tmp_map(tmp_map>0) = 1;
% nuclei_map(:,:,2) = tmp_map;
% nuclei_seg_val(2) = EvaluateNucleiSegmentation(nuclei_map(:,:,2), params);

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei, params, DATA_NAMES{data_index}, pres_params);

end



function DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei,  params, data_name, pres_params)
global nuclei_seg_val

man_segments = GetSegmentsFromPoly(manual_segm, size(I));

Ipresent = I;

tmp_img_chan_1 = Ipresent(:,:,1);
tmp_img_chan_2 = Ipresent(:,:,2);
tmp_img_chan_3 = Ipresent(:,:,3);

tmp_img_chan_2 = tmp_img_chan_2 + 0.2*man_segments;
tmp_img_chan_2(tmp_img_chan_2>1) = 1;

Ipresent(:,:,1) = tmp_img_chan_1;
Ipresent(:,:,2) = tmp_img_chan_2;
Ipresent(:,:,3) = tmp_img_chan_3;


subplot('Position', [0.05, 0.5, 0.3, 0.5]); 
ih = ImshowData(Ipresent, pres_params);
ylabel(sprintf('data %s', data_name));


set(get(ih,'children'),'hittest','off');
set(ih,'ButtonDownFcn',{@MyButtonDown,ih});

subplot('Position', [0.05, 0, 0.3, 0.5]); 
ih = ImagescData(nuclei_map(:,:,1), pres_params);

sprintf('nuclei segmentation value = %f', nuclei_seg_val(1))
ylabel(sprintf('nuclei segments, rank %f',nuclei_seg_val(1)));
set(ih,'ButtonDownFcn',{@MyButtonDown,ih});

if size(nuclei_map,3)>1
    subplot('Position', [0.4, 0, 0.3, 0.5]);
    ih = ImagescData(nuclei_map(:,:,2), pres_params);    
    sprintf('Cooper nuclei segmentation value = %f', nuclei_seg_val(2))
    ylabel(sprintf('Cooper''s nuclei segments, rank %f',nuclei_seg_val(2)));
    set(ih,'ButtonDownFcn',{@MyButtonDown,ih});
end


subplot('Position', [0.4, 0.5, 0.3, 0.5]);
ih = ImagescData(xor(manual_segm_nuclei,nuclei_map(:,:,2)), pres_params);    
% ylabel(sprintf('Cooper nuclei segmentation reference'));
ylabel(sprintf('Cooper nuclei segmentation comparison'));
set(ih,'ButtonDownFcn',{@MyButtonDown,ih});


% hold on
% plot([pres_params.x_point pres_params.x_point], [1 size(I,1)], ':y');
% plot([1 size(I,2)], [pres_params.y_point pres_params.y_point], ':y');
% hold off


end

function ih = ImshowData(I, pres_params)
ind1_lim = [pres_params.zoom.inds(1), pres_params.zoom.inds(1) + pres_params.zoom.dims(1)];
ind2_lim = [pres_params.zoom.inds(2), pres_params.zoom.inds(2) + pres_params.zoom.dims(2)];

ind1_lim(ind1_lim < 1) = 1;
ind1_lim(ind1_lim > size(I,1)) = size(I,1);

ind2_lim(ind2_lim < 1) = 1;
ind2_lim(ind2_lim > size(I,2)) = size(I,2);

Ipresent = I(ind1_lim(1):ind1_lim(2), ind2_lim(1):ind2_lim(2),:);

ih = imshow(Ipresent); axis('image');
hold on
if and(pres_params.x_point>ind2_lim(1), pres_params.x_point<ind2_lim(2))
    plot([pres_params.x_point pres_params.x_point]-ind2_lim(1)+1, [1 size(Ipresent,1)], ':y');
end

if and(pres_params.y_point>ind1_lim(1), pres_params.y_point<ind1_lim(2))
    plot([1 size(Ipresent,2)], [pres_params.y_point pres_params.y_point]-ind1_lim(1)+1, ':y');
end

hold off
end

function ih = ImagescData(I, pres_params)
ind1_lim = [pres_params.zoom.inds(1), pres_params.zoom.inds(1) + pres_params.zoom.dims(1)];
ind2_lim = [pres_params.zoom.inds(2), pres_params.zoom.inds(2) + pres_params.zoom.dims(2)];

ind1_lim(ind1_lim < 1) = 1;
ind1_lim(ind1_lim > size(I,1)) = size(I,1);

ind2_lim(ind2_lim < 1) = 1;
ind2_lim(ind2_lim > size(I,2)) = size(I,2);

Ipresent = I(ind1_lim(1):ind1_lim(2), ind2_lim(1):ind2_lim(2),:);

ih = imagesc(Ipresent);  axis('image');
hold on
if and(pres_params.x_point>ind2_lim(1), pres_params.x_point<ind2_lim(2))
    plot([pres_params.x_point pres_params.x_point]-ind2_lim(1)+1, [1 size(Ipresent,1)], ':y');
end

if and(pres_params.y_point>ind1_lim(1), pres_params.y_point<ind1_lim(2))
    plot([1 size(Ipresent,2)], [pres_params.y_point pres_params.y_point]-ind1_lim(1)+1, ':y');
end

hold off
end

function man_segments = GetSegmentsFromPoly(manual_segm, S)
man_segments = zeros(S(1), S(2));
if ~isempty(manual_segm)
    man_segments = roipoly(man_segments, manual_segm(:,1), manual_segm(:,2));
end
end


function MyButtonDown(src, eventdata, handles)
global I nuclei_map manual_segm  params data_name pres_params manual_segm_nuclei DATA_NAMES data_index
a = get(gca,'CurrentPoint');
zoom_factor = 2;

if pres_params.do_select_zoom
    switch get(gcf,'selectiontype')
        case 'normal'%left mouse button click
            size_mult = 1/zoom_factor;
        case 'alt'%right mouse button click
            size_mult = zoom_factor;
        otherwise
            size_mult = 1/zoom_factor;
    end
    pres_params.zoom.inds(1) = pres_params.zoom.inds(1) + a(1,2) - round(pres_params.zoom.dims(1)/(2)*size_mult);
    pres_params.zoom.inds(2) = pres_params.zoom.inds(2) + a(1,1) - round(pres_params.zoom.dims(2)/(2)*size_mult);
    
    pres_params.zoom.inds(pres_params.zoom.inds<1) = 1;
    if (pres_params.zoom.inds(1)>size(I,1))
        pres_params.zoom.inds(1)=size(I,1);
    end
    if (pres_params.zoom.inds(2)>size(I,2))
        pres_params.zoom.inds(2)=size(I,2);
    end
    
    pres_params.zoom.dims = round(pres_params.zoom.dims*size_mult);
    pres_params.zoom.dims(pres_params.zoom.dims<30) = 30;
    if (pres_params.zoom.dims(1)>size(I,1))
        pres_params.zoom.dims(1)=size(I,1);
    end
    if (pres_params.zoom.dims(2)>size(I,2))
        pres_params.zoom.dims(2)=size(I,2);
    end
    
else
    pres_params.x_point = a(1,1)+pres_params.zoom.inds(2);
    pres_params.y_point = a(1,2)+pres_params.zoom.inds(1);
end

DrawResults(I, nuclei_map, manual_segm, manual_segm_nuclei,  params, DATA_NAMES{data_index}, pres_params);
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