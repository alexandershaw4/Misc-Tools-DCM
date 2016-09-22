classdef dcm_hander < handle
    % Methods & handling of groups of DCMs. Essentially a class wrapper 
    % around some functions.
    %
    % NEW: Now has gui ! Do: dcm_hander_gui
    %
    % do: methods('dcm_hander') for a list of methods
    %
    % Uses / examples:
    %
    % Use dcm_make:
    %
    % D = dcm_make([cellarray_of_files:sub_by_group]);
    %
    % Or set up a D obj and load your DCMs into it:
    %
    % D   = dcm_hander;
    % D.a = {'DCM_1.mat','DCM_2.mat' ; 'DCM_3.mat','DCM_4.mat'};
    % D.loader;
    %
    %
    % then other things:
    %---------------------------------------------
    % D.plotmean  : plot mean ERP {data + model prediction}
    % D.plotgroup : plot averaged group x condition {data + pred}
    % D.BMS       : do Bayesian model selection {pooled if groups}
    % D.Circle    : plot winning adjacency matrix on circle plot
    %
    % D.GetP('B'): retrieve posterior values for param 'B' for subs and
    %              place in D.p
    %
    % D.Dubble  : turn whatever is input cell (or in D.p) to a full double matrix
    % D.Shrink  : remove empty rows/cols from whatevers in D.p
    % D.GetF    : get fit values
    % D.GetY    : get real [Y] & model [y] ERP data
    % D.CorMat  : correlation matrix for a parameter and condition
    % 
    % NB. D.p is essentially a scratch / dump for transfering data between
    % functions
    %
    % D.saveparams('B'): save the parameter 'B' for each sub into a .mat
    % D.Names          : parameter names using fieldnames & sizes
    % D.anorm(6,1)     : amplitude normalisation mod/real ERF data
    %
    % svmf - svm classifyier 
    %         - inputs: obj.svm.P  = 'B' [= parameter]
    %                   obj.svm.Pc = 80  [= % to use as training]
    %                   obj.svm.f  = @fitNaiveBayes or @svmtrain
    %                   obj.svm.DoPermute = 0/1
    %
    % svmp - svm classifier w/ permutations
    %         - inputs: obj.svm.P  = 'B'     [= parameter]
    %                   obj.svm.Pc = 80      [= % to use as training]
    %                   obj.svm.nperm = 1000 [=number of permutations]
    %
    % AS2016 [clas util]

    
   properties
      info
      a
      f
      bms
      F
      Y
      y
      t
      Hz
      nt
      p
      x
      N
      norm
      stats
      BinarySpace
      svm
      clasif
      reduced
      permBMS
   end
   
   
   methods

       
      function f = loader(obj)
      % load cell array of DCM files
                a = obj.a;
                if      ~iscell(a); return
                elseif   ischar(a{1}); 
                f = loadarraydcm(a);
                end
                obj.f = f;
      end
      
       
      function plotmean(obj)
      % average datasets and plot model + prediction ERPs
                try obj.f; catch obj.f = loader(D); end
                for i = 1:size(obj.f,1)
                    figure,ploterp(obj.f(i,:));
                end

      end
      
      function plotgroup(obj)
      % plot data & prediction averaged, group(s) by condition(s)
                GroupPloterp(obj);
      end
      
      
      function o = BMS(obj)
      % do Bayesian model selection over all subjects
               o = DoBMS(obj.a);
               obj.bms = o;
      end
      
      function po = pBMS(obj)
      % do leave-one-out permutations on BMS
                po = permuterBMS(obj);
                obj.permBMS = po;
      end
      
      function B = ModAct(obj)
      % binary struct version of DCM.Ep with param on/off
                DCM = obj.f{1,1};
                B   = BinaryModel(DCM);
                obj.BinarySpace = B;
      end
      
      function Circle(obj)
      % plot adjacency matrix on a circle grid with connections
               try   W = loadarraydcm({obj.bms.W{1}}); % if bms, this is winning model
                     W = W{1};
               catch W = obj.f{1}; 
               end
               DCM_Graph(W);
      end
      
      function L = GetInfo(obj)
      % get labels (nodes, models, functions etc)
                L = GetLabels(obj.f{1,1});
                obj.info = L;
      end
      
      function S = DoStats(obj)
      % run ttest or anova on a parameter
                S = DStats(obj);
                obj.stats = S;
      end
      
      function p = GetP(obj,P)
      % get parameter, P, from the posterior for everyone: e.g. DCM.Ep.(P)
                %if ~exist('obj.f'); 
                %    obj.f = loader(obj); 
                %end
                if strcmp(P,'J');
                    p = getdcmj(obj.f,P);
                else
                    p = getdcmp(obj.f,P);
                end
                
                obj.p = p; % link
                obj.info.P = P;
      end
      
      
      function x = GetX(obj)
      % get full [hidden] model states, x: (for ERP models only)
      try
                    x = getdcmx(obj.a);
                obj.x = x;
      end
                
      end
                
      
      
      function f = GetF(obj)
      % get F (fit) values from subjects in D.a / D.f
                %if ~exist('obj.f'); 
                %    obj.f = loader(obj); 
                %end
                f = getdcmf(obj.f);
                obj.F = f; % link it
      end
      
      
      function [Y,y,nt,Hz,t] = GetY(obj)
      % get the real data stored for subjects in D.a / D.f
                if ~exist('obj.f'); 
                    obj.f = loader(obj); 
                end
                [Y,y,nt,Hz,t] = getdcmY(obj.f);
                
                % obj links:
                obj.Y  = Y;
                obj.y  = y;
                obj.nt = nt;
                obj.Hz = Hz;
                obj.t  = t;
      end      
      
      
      function saveparams(obj,P)
      % Extract a parameter 'p' for a bunch of DCMs listed in the
      % subject x condition matrix 'f' (and save).
                if ~exist('obj.f'); 
                    obj.f = loader(obj); 
                end
                saveparams(obj.a,P);
      end
      
      
      function p = Dubble(obj,varargin)
      % convert cell of stuff into full n-dim double matrix
      % fully compiled routine for cell->double
                if exist('varargin{1}'); p = innercell(m);
                else           p = innercell(obj.p);
                end
                obj.p = p; % link
      end
      
      
      function p = Shrink(obj)
      % remove empty rows/cols from whatever is in D.p
                p = shrink(obj.p);
                obj.p = p; %link
      end
      
      
      function N = Names(obj)
      % extract names of parameters using fieldnames & sizes
                if ~exist('obj.f'); 
                    obj.f = loader(obj); 
                end
                N = DCMVECNAMES(obj.f{1},1);
                obj.N = N;
      end
      
      
      function [Y,y] = anorm(obj,N1,varargin)
      % amplitude normalisation / centering / scaling
      % do help TSNorm to see norm options
                if ~exist('obj.Y'); 
                    [obj.Y,obj.y]=GetY(obj); 
                end
                s = size(obj.Y);
                for i = 1:(s(1))
                    for j = 1:(s(2))
                        for k = 1:(s(3))
                            Y(i,j,k,:) = TSNorm(squeeze(obj.Y(i,j,k,:)), N1, varargin);
                            y(i,j,k,:) = TSNorm(squeeze(obj.y(i,j,k,:)), N1, varargin);
                        end
                    end
                end
                obj.norm.Y = Y;
                obj.norm.y = y;
      end
      
      
      function clasif = svmf(obj)
         % svm train & classify function, optionally using machine: (f).
         svm = obj.svm;
         try svm.Pc ; catch svm.Pc = 80;  end
         try svm.P  ; catch svm.P  = 'B'; end
         try svm.f  ; catch svm.f  = @fitNaiveBayes; end
         try svm.DoPermute; catch svm.DoPermute = 1; end
         
         clasif = svm_dcm_f(obj.a, svm.Pc, svm.P, svm.DoPermute,svm.f);
         obj.clasif = clasif;
      end
      
      
      function clasif = svmp(obj)
         % permutation wrapper on the above
         svm = obj.svm;
         try svm.Pc ; catch svm.Pc = 80;  end
         try svm.P  ; catch svm.P  = 'B'; end
         try svm.nperm; catch svm.nperm = 1000; end
         
         clasif = svm_dcm_p(obj.a, svm.Pc, svm.P, svm.nperm);
         obj.clasif = clasif;
         
      end
      
      function reduced = reduce(obj)
                P = obj.f(:);
                DCM = spm_dcm_post_hoc(P);
                obj.reduced = DCM;
      end
      
      function CorMat(obj,p,varargin)
      % correlation matrix for a given parameter and condition 
      %(sep plots for each group)
      % e.g. CorMat(D,'B',1) for param B and condition index 1
                DoCorr(obj,p,varargin);
      end

      
   end
end