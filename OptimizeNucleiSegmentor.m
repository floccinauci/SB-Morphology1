function [segmentation_struct, best_res] = OptimizeNucleiSegmentor(I, data_param)
global I_in data_param_in
I_in = I;
data_param_in = data_param;

x = zeros(3,1);
best_res = 0;

x(3) = 0.5;
lb = [-1; -1; 0.1];
ub = [0.5; 0.5; 0.7];

opts = optimoptions(@fmincon,'Algorithm','sqp');
[x,fval] = fmincon(@SegmentationValue, x, [], [], [], [], lb, ub, [], opts);
% problem = createOptimProblem('fmincon','objective',...
%  @SegmentationValue,'x0',x,'lb',lb,'ub',ub,'options',opts);
% gs = GlobalSearch;
% [x,f] = run(gs,problem);

segmentation_struct.weights = [1,x(1),x(2)];
segmentation_struct.threshold = [0,x(3)];
end

function res = SegmentationValue(x)
global I_in data_param_in
nuclei_segmentation_struct.weights = [1,x(1),x(2)];
nuclei_segmentation_struct.threshold = [0,x(3)];
nuc_seg = SegmentNuclei(I_in, nuclei_segmentation_struct, data_param_in);
res = 2 - EvaluateNucleiSegmentation(nuc_seg,data_param_in);
end