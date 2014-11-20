function param = GetDataParams(data_name)
param.SLIC_segment_num = 10;
param.SLIC_regularizer = 500;
% param.init_resize = 0.5;
param.init_resize = 1;
param.hist_bin_num = 16;
param.hist_color_weights = [0.4, 0.3, 0.3];
param.nuclei_thresh_red = 0.6;
param.data_extension = 'tif';
param.do_load_cut = 1;
param.do_load_superpixels = 1;
param.do_load_similarity = 1;
param.do_load = 1;
param.retouch_radius = 10;
param.retouch_min_area_portion = 0.1;

param.nuclei_reference_segmentation_path = '';
param.nuclei_reference_segmentation_filename = '';

param.Cooper.M = [-0.154 0.035 0.549 -45.718; -0.057 -0.817 1.170 -49.887]; %color normalization - discriminate tissue/background.
param.Cooper.calib_image_path = '../data/standards/GBM_target1.tiff'; %pathname of color normalization calibration image
param.Jun.T1=5;  % first Red/Green threshold used for stripping red blood cells in JunForeground
param.Jun.T2=4;  % second Red/Green threshold used for stripping red blood cells in JunForeground
param.Jun.G1=80;  
param.Jun.G2=45;


switch data_name
    case {'100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119'}
        param.data_path = '../data/Nuclei Segmentation/Input/training_set1/';
        param.nuclei_reference_segmentation_path = sprintf('../data/Nuclei Segmentation/Output/training_set1/path-image-%s.tif/', data_name);
        param.nuclei_reference_segmentation_filename = sprintf('path-image-%s.000000.000000', data_name);
        param.data_filename = sprintf('path-image-%s', data_name);
    case {'120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134'}
        param.data_path = '../data/Nuclei Segmentation/Input/training_set2/';
        param.nuclei_reference_segmentation_path = sprintf('../data/Nuclei Segmentation/Output/training_set2/path-image-%s.tif/', data_name);
        param.nuclei_reference_segmentation_filename = sprintf('path-image-%s.000000.000000', data_name);
        param.data_filename = sprintf('path-image-%s', data_name);
    case '0034'
        param.data_path = '../data/TCGA-02-0034/';
        param.data_filename = 'TCGA-02-0034-01Z-00-DX1';
    case '0037'
        param.data_path = '../data/TCGA-02-0037/';
        param.data_filename = 'TCGA-02-0037-01Z-00-DX1';
    case '0085'
        param.data_path = '../data/TCGA-02-0085/';
        param.data_filename = 'TCGA-02-0085-01Z-00-DX1';
    case '0137'
        param.data_path = '../data/TCGA-06-0137/';
        param.data_filename = 'TCGA-06-0137-01Z-00-DX4';
    case '0138'
        param.data_path = '../data/TCGA-06-0138/';
        param.data_filename = 'TCGA-06-0138-01Z-00-DX1';
    case '0139'
        param.data_path = '../data/TCGA-06-0139/';
        param.data_filename = 'TCGA-06-0139-01Z-00-DX1';
    case '0141'
        param.data_path = '../data/TCGA-06-0141/';
        param.data_filename = 'TCGA-06-0141-01Z-00-DX4';
    case '0143'
        param.data_path = '../data/TCGA-06-0143/';
        param.data_filename = 'TCGA-06-0143-01Z-00-DX1';
    case '0145'
        param.data_path = '../data/TCGA-06-0145/';
        param.data_filename = 'TCGA-06-0145-01Z-00-DX4';
    case '0147'
        param.data_path = '../data/TCGA-06-0147/';
        param.data_filename = 'TCGA-06-0147-01Z-00-DX1';
    case '0148'
        param.data_path = '../data/TCGA-06-0148/';
        param.data_filename = 'TCGA-06-0148-01Z-00-DX3';
    case '0171'
        param.data_path = '../data/TCGA-06-0171/';
        param.data_filename = 'TCGA-06-0171-01Z-00-DX4';
    case '0173'
        param.data_path = '../data/TCGA-06-0173/';
        param.data_filename = 'TCGA-06-0173-01Z-00-DX2';
    case '0881'
        param.data_path = '../data/TCGA-06-0881/';
        param.data_filename = 'TCGA-06-0881-01Z-00-DX2';
    case '1037'
        param.data_path = '../data/TCGA-14-1037/';
        param.data_filename = 'TCGA-14-1037-01Z-00-DX1';
    case '1459'
        param.data_path = '../data/TCGA-14-1459/';
        param.data_filename = 'TCGA-14-1459-01Z-00-DX2 - no necrosis';
    case '1795'
        param.data_path = '../data/TCGA-14-1795/';
        param.data_filename = 'TCGA-14-1795-01Z-00-DX1';
    case '1823'
        param.data_path = '../data/TCGA-14-1823/';
        param.data_filename = 'TCGA-14-1823-01Z-00-DX4';
    case '1825'
        param.data_path = '../data/TCGA-14-1825/';
        param.data_filename = 'TCGA-14-1825-01Z-00-DX1';
    case '2619'
        param.data_path = '../data/TCGA-19-2619/';
        param.data_filename = 'TCGA-19-2619-01Z-00-DX1';
    case '4743'
        param.data_path = '../data/TCGA-CM-4743/';
        param.data_filename = 'TCGA-CM-4743-01Z-00-DX1-00-DX1_Z0_T0';
    case '5953'
        param.data_path = '../data/TCGA-19-5953/';
        param.data_filename = 'TCGA-19-5953-01Z-00-DX1';
    case '5954'
        param.data_path = '../data/TCGA-19-5954/';
        param.data_filename = 'TCGA-19-5954-01Z-00-DX1';
    case '5955'
        param.data_path = '../data/TCGA-19-5955/';
        param.data_filename = 'TCGA-19-5955-01Z-00-DX1';
    case '5958'
        param.data_path = '../data/TCGA-19-5958/';
        param.data_filename = 'TCGA-19-5958-01Z-00-DX1 - no necrosis';
    case '5959'    
        param.data_path = '../data/TCGA-19-5959/';
        param.data_filename = 'TCGA-19-5959-01Z-00-DX1';
end
