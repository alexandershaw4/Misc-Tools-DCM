function L = GetLabels(D)

if ~isstruct(D); try D = D{1}; catch; return; end; end

% labels
try L.nodes      = D.xY.name; end
try L.conditions = D.xY.code; catch; try L.conditions = D.xU.name; end; end
try L.designmat  = D.xU.X;    end

% function handles
try L.fun        = D.M.f;  end % generative model
try L.IS         = D.M.IS; end % integrator + noise
try L.FS         = D.M.FS; end % feature selection
try L.G          = D.M.G;  end % spatial model

% model
try L.mod        = D.options.model;    end
try L.analysis   = D.options.analysis; end
try L.spatial    = D.options.spatial;  end

try L.Tdcm       = D.options.Tdcm; end
try L.Fdcm       = D.options.Fdcm; end

try L.Bdcm       = D.options.Bdcm;   end
try L.Fltdcm     = D.options.Fltdcm; end
