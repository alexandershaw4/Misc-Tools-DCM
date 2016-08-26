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