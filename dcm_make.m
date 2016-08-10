function D = dcm_make(F)
% initiate an object (D) containing a set of DCM models with some methods.
% 
% input (f) is a cell array of DCM*.mat files, organised subs x groups. 
% If you want to use BMS, include _Mod_n_ somewhere in the file names, where n is the model number. 
%
% e.g. f = {'Sub1_Mod_1_Gr1','Sub2_Mod_2_Gr1' ; 'Sub1_Mod_1_Gr2', 'Sub2_Mod_2_Gr2'};
%      D = dcm_make(f');
%
% do: methods('dcm_hander') to see available methods & plots
%
% or: access the data using D.(fieldname), see "help dcm_hander"
%
% D.f is the full dcm structures in the same order / shape as input
% D.Y / D.y are the  real data and model predictions (resp.) in full double
% format, e.g. if input F was a cell array of filenames: f{32 x 2} which contains 32 subs
% in each of the 2 groups, and for each subject there is 1 source and
% condition [for exmaple a single sensor SSR fitted 1:100Hz] then D.Y will 
% be Y(32 x 2 x 1 x 100).
%
% D.F is the fit [free energy] values
% D.N is a vector of param names for each element of DCM.Ep.(x)
% 
% Extract a parameter easily: D.GetP('G') will return posterior parameter G
% in D.p. To make this a full double n-dim matrix type D.Dubble then check
% D.p again [also, remove empty rows/cols using D.Shrink]
%
% Normalise the real and model timerseries / freq spectra: D.anorm(m,n)
% where m is the normalisation method [see help TSNorm], output will be in
% D.norm.Y / y
%
% Also: (see methods('dcm_hander') for instructions:)
% D.saveparams('B')
% D.plotmean
% D.svmf / D.svmp 
%
% AS2016 

D   = dcm_hander;
D.a = F;

% execute
D.loader; D.GetF; D.Names; D.GetY; D.ModAct; D.GetInfo; D.GetX;

return;





