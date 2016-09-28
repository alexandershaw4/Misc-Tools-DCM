function varargout = dcm_hander_gui(varargin)
% GUI for MEEG DCM objects created using dcm_hander. 
%
% This is a simple toolbox for extracting data (paramters, plots etc) from 
% *GROUP* level MEEG DCM projects (ERP, SSR, CSD flavours).
% 
% - includes parameter extraction [inc. to matlab matrix or csv]
% - includes autoplotting of data, predictions, parameters etc.
% - includes group level stats for parameters
% - includes BMS
%
% 
% Usages:
%
% 1) Load {inverted} DCM.mat files into GROUP1 & GROUP2, then click MAKE. 
% 2) For future, click Save and give name. Next time Load that file.
% 
% 3) Plots are configured to automatically detect n conditions and sensors etc.
% 4) Methods dropdown should be fairly automated.
%  
% 5) For parameter extraction: 
%
% For non-trial specific parameters, try:
%
% -Select from dropdown, select param and press OK.
% -Then click the Plot or Export button. 
%
% For trial specific ('B') parameters, try:
%
% -Select from dropdown, select param and press OK.
% -Now go to dropdown, click MakeDouble
% -Now go to dropdown and click MakeShrink
% -Then click the Export button. 
% -Your variable should be in your base matlab workspace.
% -If it couldnt determine the variable name it will be called x.
% 
% 6) For F values: 
% - Select Get F from methods
% - Click export (&or plot)
% - Note F matrix in base workspace
% 
% 
% -Run whatever other methods you want. Most will store in the object'...
% -Then when finished, click Export Object. OBJ should be in workspace.'
%
% See also: dcm_hander dcm_make dcmgetp
%
% AS2016


% Edit the above text to modify the response to help dcm_hander_gui

% Last Modified by GUIDE v2.5 03-Aug-2016 15:51:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dcm_hander_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @dcm_hander_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dcm_hander_gui is made visible.
function dcm_hander_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dcm_hander_gui (see VARARGIN)

% Choose default command line output for dcm_hander_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dcm_hander_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dcm_hander_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

% GROUP 1 DATA:
try [G1,Pth] = uigetfile('*.mat','MultiSelect','on');
    %handles.G1 = [Pth handles.G1];
    for i = 1:length(G1)
        handles.G1{i,:} = [Pth G1{i}]; % append paths
    end
        
    
catch; return;
end
% Save the handles structure.
guidata(hObject,handles); 

% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2

% GROUP 2 DATA:
try [G2,Pth] = uigetfile('*.mat','MultiSelect','on');
    %handles.G2 = [Pth handles.G2];
    for i = 1:length(G2)
        handles.G2{i,:} = [Pth G2{i}];
    end
catch ; return 
end
% Save the handles structure.
guidata(hObject,handles);

% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3
try handles.G1; handles.G2; catch; return; end %avoid errors

G1 = handles.G1;
G2 = handles.G2;
l = [length(G1) length(G2)];
if l(1) ~= l(2)
   i  = 1:min(l);
   G1 = G1(i);
   G2 = G2(i);
   fprintf(' [cropping larger group so that sizes match] \n');
end

% initialise
D = dcm_make([G1,G2]'); % this makes the object
handles.D = D;          % this stores it in figure handle
msgbox({'Success'});
% Save the handles structure.
guidata(hObject,handles)

% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton4
try D = handles.D;
    D.plotmean;
end

% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5
try D = handles.D;figure,
    D.plotgroup;
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

% METHODS POPUP
str = get(hObject, 'String');
val = get(hObject,'Value');

try  D = handles.D; % avoiding error if not yet loaded
     m = methods(D);
catch; return;
end

% Switchyard for object functions w/ assignment
switch val
    case 1;  D.BMS;
             assignin('base','BMS',D.bms);
    case 2;  D.pBMS;
    case 3;  D.GetInfo;
             assignin('base','info',D.info);
    case 4;  figure,D.Circle;
   %case 5;  D.GetP
    case 6;  x = D.GetX;
             D.x = innercell(x);
             assignin('base','model_states',D.x);
    case 7;  x = D.GetF;
             handles.D.p = x;
             handles.D.info.P = 'F';
    case 8;  [Y,y] = D.GetY;
             assignin('base','RealData',Y);
             assignin('base','ModelData',y);            
    case 9;  x = D.Names;
             assignin('base','Names',x);
   %case 10; x = D.norm;
   %case 11; x = D.CorMat
   %case 12; D.saveparams
   %case 13; x = D.Dubble;
    case 14; x = D.Shrink;
    case 17; D.DoStats;
             assignin('base','Stats',D.stats);
    case 18; D.GetCov;
            
        
end

% special cases (fun inputs)
f = fieldnames(D.f{1}.Ep);

if val == 5 % parameter extract
    [s,v] = listdlg('PromptString','Select param:',...
                'SelectionMode','single',...
                'ListString',f);
    if ~exist('s'); return; end
    x = D.GetP(f{s});
    handles.D.info.P = f{s};
end

if val == 10 % normalise
    mth = {...
        'scale between 0-1. [default]'
        'divide by maximum.'
        'mean correct and divide by std.' 
        'mean correct.'
        'scale approx [-1 1]'
        'scale between [-n and n]*'
        'scale by unit length (./norm(x))'};
    
    [s,v] = listdlg('PromptString','Select param:',...
                'SelectionMode','single',...
                'ListString',mth);
    if ~exist('s'); return; end
    if s ~= 6
        x = D.anorm(s);
    else % otherwise, scale between what?
        s2=inputdlg('Scale to what?','Scale value');
        s2=str2mat(s2);
        x = D.anorm(s,s2);
    end  
end

if val == 11 % correlation matrix
        
        try fj = fieldnames(D.f{1}.Eg); end
        try   nf = [f; fj]; 
        catch nf = f;
        end
            
        [s,v] = listdlg('PromptString','Select param to correl:',...
                'SelectionMode','single',...
                'ListString',nf);
            if ~exist('s'); return; end
        if strcmp(nf{s},'B');   
            s2=inputdlg('Which number condition?','Type value');
            s2=str2num(s2{:})
            D.CorMat(nf{s},s2);
        else
            D.CorMat(nf{s});
        end
end

if val == 12 % save params
        [s,v] = listdlg('PromptString','Select param to correl:',...
                'SelectionMode','single',...
                'ListString',f);
            if ~exist('s'); return; end
        D.saveparams(s{f});
end

if val == 13 % double matrix from cell
    x = D.Dubble; % inherits from D.p (whatever you extracted)
end


if val == 15 % parameter extract
    try       j = fieldnames(D.f{1}.Eg);
    catch try j = fieldnames(D.f{1}.Ep);
        catch return;
        end
    end

    [s,v] = listdlg('PromptString','Select param:',...
                'SelectionMode','single',...
                'ListString',j);
    if ~exist('s'); return; end
    x = D.GetP(j{s});
    handles.D.info.P = j{s};
end

if val == 16 % save csv
    try   x = handles.x;
    catch try x = handles.D.p;
        catch msgbox('Extract parameter first! - see help');
            return;
        end
    end
    
    try if iscell(x); msgbox('please click MakeDouble then MakeShrink first');
            return;
        end
    end
    
    try n = handles.D.info.P; catch n = 'x'; end
    csvwrite(n,x);
    msgbox('Successfully wrote CSV!');
end
% end of methods...

try handles.x = x; end % also inherits to handles.D.p

% Save the handles structure.
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton6

% saver
nm = inputdlg('enter save name','name...');
D  = handles.D;
try x = handles.x; catch x = []; end
save(nm{:},'D','x');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% plot the method extracted data
try x = handles.x; catch try x = handles.D.p; catch; return; end; end

D = handles.D;



try handles.D.info.P; catch handles.D.info.P = 'n'; end
switch handles.D.info.P
    case {'B','A','D'}
        autoplot(x{1,:});
        autoplot(x{2,:});
        
    case {'F'}
        x = x';
        p1 = squeeze(x(:,1,:,:,:));
        p2 = squeeze(x(:,2,:,:,:));
        plot(p1,'bo'); hold on; 
        plot(p2,'ro'); hold off;
        
    case {'G','T','C','S','R'}
        try
        x = x';
        p1 = squeeze(x(:,1));
        p2 = squeeze(x(:,2));
        
        p1 = (mean(cat(3,p1{:}),3));
        p2 = (mean(cat(3,p2{:}),3));
        
        % - new, for spectral x can be 3D:
        catch
            try p1 = squeeze(x(:,1,:));
                p2 = squeeze(x(:,2,:));
            catch; return; 
            end
        end
        
        figure,
        l = D.info.nodes;
        try
        switch handles.D.info.P
            case 'G'
            subplot(121),imagesc(p1);
            set(gca, 'YTick',1:length(l), 'YTickLabel',l);
            subplot(122),imagesc(p2);
            set(gca, 'YTick',1:length(l), 'YTickLabel',l);
            case {'T'}
            M = max(max([(p1);(p2)]));
            m = min(min([(p1);(p2)]));
            subplot(121),bar(p1); ylim([m M]);
            set(gca, 'XTick',1:length(l), 'XTickLabel',l);
            subplot(122),bar(p2); ylim([m M]);
            set(gca, 'XTick',1:length(l), 'XTickLabel',l);
            case {'C','S','R'}
            m = max([exp(p1);exp(p2)]); m = max(m);
            subplot(121), bar(exp(p1));ylim([0 round(m*1.2)]);
            subplot(122), bar(exp(p2));ylim([0 round(m*1.2)]);
        end
        catch
            % new - just hand it to autoplotter!
            try autoplot({p1, p2}); end
        end
        
    case {'M','N'};
    case 'J'
        
        p1 = cat(3,x{1,:});
        p2 = cat(3,x{2,:});
        
        p1 = mean(p1,3);
        p2 = mean(p2,3);
        
        p  = (p1+p2)/2;
        bar(p);
        
        figure;
        M = max(max([p1; p2]));
        subplot(121),bar(p1);ylim([0 M*1.1]);
        subplot(122),bar(p2);ylim([0 M*1.1]);
end
        



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try x = handles.x; catch try x = handles.D.p; catch; return; end; end

try nx = handles.D.info.P; catch nx = 'x'; end

assignin('base',nx,x);


% --- Executes on button press in togglebutton7.
function togglebutton7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton7

% loader
try  [Df,Pth] = uigetfile('*.mat');
catch ; return; 
end
try  load([Pth Df]);
     handles.D = D;
     fprintf('Success!\n');
catch return;%error('couldnt load previous data, sorry');
end
% Save the handles structure.
try guidata(hObject,handles); end

%
% Usages:
% 1) Load .mat's into GROUP1 & GROUP2, then click 'MAKE'. 
% 2) For future, click 'Save' and give name. Next time Load that file.
% 
% 3) Plots are automated to configure conditions and sensors etc.
% 4) Methods dropdown should be fairly automated.
% 
% 5) For parameter extraction: Select from dropdown, select param and press OK.
% Now go to dropdown, click 'MakeDouble' and then click the 'Export' button. 
% Your variable should be in your base matlab workspace. If it couldn't determine 
% the variable name it will be called 'x'.


% --- Executes on button press in togglebutton8.
function togglebutton8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton8

% Help module:
H = {...
    ' Usages:'...
'1) Load .mats into GROUP1 & GROUP2, then click MAKE. '...
'2) For future, click Save and give name. Next time Load that file.'...
 ' '...
'3) Plots are automated to configure conditions and sensors etc.'...
'4) Methods dropdown should be fairly automated.'...
' '... 
'5) For parameter extraction: '...
'-Select from dropdown, select param and press OK.'...
'-Now go to dropdown, click MakeDouble'...
'-Now go to dropdown and click MakeShrink'...
'-Then click the Export button. '...
'-Your variable should be in your base matlab workspace.'...
'-If it couldnt determine the variable name it will be called x.'...
'-Click write CSV to write this variable to a comma seperated txt'...
' '...
' '...
'-Run whatever other methods you want. Most will store in the object'...
'-Then when finished, click Export Object. OBJ should be in workspace.'};

msgbox(H)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% export whole object
assignin('base','OBJ',handles.D);


% --- Executes on button press in togglebutton9.
function togglebutton9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton9


% --- Executes on button press in togglebutton10.
function togglebutton10_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton10


% --- Executes on button press in togglebutton11.
function togglebutton11_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton11
