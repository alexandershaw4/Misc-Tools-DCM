% README
%
% GUI dcm_hander_gui 
%
% A simple parameter extraction and plotting tool for group level MEEG DCMs 
%
% AS2016
%
%
%
% TO RUN GUI:
%------------------------------------------
% 
% in matlab:
% addpath(genpath('~/Downloads/dcmgrouptools'))
%
% to run:
% dcm_hander_gui
%
% see:
% HELP button on gui
%
%
%
%
% FOR NON-GUI, just return object with associated funcs:
%------------------------------------------
%
% opt1:
% G1 = {'sub1_Mod_1.mat','sub2_Mod_1.mat','sub1_Mod_2.mat' ... };
% G2 = {'sub1_Mod_1.mat','sub2_Mod_1.mat','sub1_Mod_2.mat' ... };
% D  = dcm_make([G1; G2])
%
% opt2:
% D   = dcm_hander;
% G1  = {'sub1_Mod_1.mat','sub2_Mod_1.mat','sub1_Mod_2.mat' ... };
% G2  = {'sub1_Mod_1.mat','sub2_Mod_1.mat','sub1_Mod_2.mat' ... };
%
% D.a = [G1;G2];
% D.loader;
%
%
% see:
% methods('dcm_hander')
%
% and
%
% help dcm_hander        for some example command line usages
%
%
%
%
% Methods:
% -----------------------------------------
% 
% D.GetF        : get F values, stores in D.F
% D.GetX        : get model states, stores in D.x
% D.GetP('B')   : get model parameter 'n', stores in D.p and name in D.info.P
% D.GetY        : get real and predicted data [ERPs or SSR/CSD], saves real in D.Y and prediction in D.y
% D.GetCov      : get poterior covariances, stores in D.cov
% 
% D.GetInfo     : extracts stored information about the models, stores in D.info
% 
% 
% D.anorm       : normalise / scale / centre model and predicted data 
% D.CorMat('B') : Correlation matrix on parameter 'n' e.g. 'G','T','A','D','B' etc
% D.DoStats     : [pop up options] t-test or anova on a parameter, stores in D.stats
%
%
% Plots:
%--------
% D.plotmean    : plot group means [diff figs for each group]
% D.plotgroup   : plot group averages [groups on same plot]
% D.Circle      : plot adjacency matrix on circular plot
%
%
% other:
%---------
%
% D.BMS       : Bayesian model selection - models should include _Mod_n_ in file name, where n is the model number. Stores in D.bms
% D.reduce    : post-hoc reduction of model parameters [using spm_dcm_post_hoc]
%
%