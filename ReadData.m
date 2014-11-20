function [img, matlab_coords_cancer, nuclei_map] = ReadData(data_name)
params = GetDataParams(data_name);
img = im2single(imread(sprintf('%s%s.%s', params.data_path, params.data_filename, params.data_extension)));

img = imresize(img, params.init_resize);
img(img>1) = 1;
img(img<0) = 0;

S = size(img);

if exist(sprintf('%s%s_data.txt', params.data_path, params.data_filename), 'file')
    coords = load(sprintf('%s%s_data.txt', params.data_path, params.data_filename));
else
    coords = [];
end
if ~isempty(coords)
    coords = floor(coords*params.init_resize);
    coords(coords<1) = 1;
    
    matlab_coords_cancer = coords;
    matlab_coords_cancer(:,1) = coords(:,1);
    matlab_coords_cancer(:,2) = coords(:,2);
else
    matlab_coords_cancer = [];
end

if ~isempty(params.nuclei_reference_segmentation_path)
    load(sprintf('%s%s.mat', params.nuclei_reference_segmentation_path, params.nuclei_reference_segmentation_filename));
    nuclei_map = Label(1:size(img,1), 1:size(img,2));
else
    nuclei_map = zeros([size(img,1), size(img,2)]);
end
% if exist(sprintf('%s%s.seg.000000.000000.txt.json', params.data_path, params.data_filename), 'file')
%     nuclei_coords = loadjson(sprintf('%s%s.seg.000000.000000.txt.json', params.data_path, params.data_filename));
% else
%     nuclei_coords = {};
% end
% if ~isempty(coords)
%     coords = floor(coords*params.init_resize);
%     coords(coords<1) = 1;
%     
%     matlab_coords_cancer = coords;
%     matlab_coords_cancer(:,1) = coords(:,1);
%     matlab_coords_cancer(:,2) = coords(:,2);
% else
%     matlab_coords_cancer = [];
% end

end