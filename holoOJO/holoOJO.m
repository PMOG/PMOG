function varargout = holoOJO(varargin)
% HOLOOJO MATLAB code for holoOJO.fig
%
% A GUI for hologram manipulation with Matlab.
%
% To run the GUI just execute this script.
%
% The routine supports phase and complex modulation using a blazed grating.  
% The user can choose the following % types of beams:
% - LAGUERRE-GAUSSIAN
% - BESSEL BEAMS
% - FLAT-TOP
% - USER DEFINED
% 
% Once the type of desired beam is selected, modify the parameters to suit 
% your needs.  The "user defined"  option accepts any matlab function (in 
% the path) with the coordinates X,Y,THETA or RHO.
%
% BP
% Last Modified 30 Dec 2016.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @holoOJO_OpeningFcn, ...
                   'gui_OutputFcn',  @holoOJO_OutputFcn, ...
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


% --- Executes just before holoOJO is made visible.
function holoOJO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to holoOJO (see VARARGIN)

% Choose default command line output for holoOJO
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.VarSlide,'String',get(handles.slider1,'Value'));  % assigns the same initial value of the slider to the textbox
updateAxes(handles);

% UIWAIT makes holoOJO wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = holoOJO_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderVal=get(hObject,'Value');
assignin('base','sliderVal',sliderVal);
set(handles.VarSlide,'String',num2str(sliderVal));
updateAxes(handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function VarSlide_Callback(hObject, eventdata, handles)
% hObject    handle to VarSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of VarSlide as text
%        str2double(get(hObject,'String')) returns contents of VarSlide as a double

VarSlide=get(hObject,'String');
set(handles.slider1,'Value',str2num(VarSlide));
updateAxes(handles);


% --- Executes during object creation, after setting all properties.
function VarSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VarSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Topocharge_Callback(hObject, eventdata, handles)
% hObject    handle to Topocharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Topocharge as text
%        str2double(get(hObject,'String')) returns contents of Topocharge as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function Topocharge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Topocharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
updateAxes(handles)


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
updateAxes(handles)

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
updateAxes(handles)


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
updateAxes(handles)


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
updateAxes(handles)


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
updateAxes(handles)


function BeamWaist_Callback(hObject, eventdata, handles)
% hObject    handle to BeamWaist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BeamWaist as text
%        str2double(get(hObject,'String')) returns contents of BeamWaist as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function BeamWaist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BeamWaist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
updateAxes(handles)


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateAxes(handles)
% SLM dimensions
ResR=1*1080;  % pixels, add +1 for simulation reasons, if you want to generate the hologram change to +0
ResC=1*1920;
Ux=2*7.68E-3; % [m]
Uy=8.64E-3;

% HOLOGRAM PARAMETERS
downScale=1/1;%0.50;          % Scale factor for tests
Nx=ResC*downScale;
Ny=ResR*downScale;

% Spatial sampling at 2*fNyquist, spatial gratings
sx=linspace(-Ux/2,Ux/2,Nx);
sy=linspace(-Uy/2,Uy/2,Ny);
[X,Y]=meshgrid(sx,sy);
[THETA, RHO]=cart2pol(X,Y);

% Grating for the hologram
gratinParam=get(handles.slider1,'Value');

% Field for a Vortex beam
if get(handles.radiobutton3,'Value')
    m=str2num(get(handles.Topocharge,'String'));
    % r0=str2num(get(handles.Topocharge,'string'))/sqrt(abs(m)+1);
    r0=str2num(get(handles.BeamWaist,'String'));
    Field= LG(X,Y,m,r0);
end

% Field for a Bessel
if get(handles.radiobutton4,'Value')
    m=str2num(get(handles.edit4,'String'));
    kt=str2num(get(handles.edit5,'String'));
    delt=1-str2num(get(handles.edit6,'String'));
    Field=BesselRing(X,Y,m,kt,delt);
end

% Field for a flat-top
if get(handles.radiobutton5,'Value')
    bbeta=str2num(get(handles.edit7,'String'));
    r0=str2num(get(handles.edit8,'String'));
    Field=TopHat(bbeta,r0);
end

% User-defined field
if get(handles.radiobutton6,'Value')
    Field=eval(get(handles.edit9,'String'));
end

Phase=angle(Field);
A1=abs(Field);
scale=gratinParam/Ux;
Nxx=ResC*scale;
Nyy=0;

if get(handles.radiobutton1,'Value') % phase only
    g1=1;
end

if get(handles.radiobutton2,'Value') % phase and amplitud
    g1=A1/max(max(A1));
end

HoloU=g1.*(mod(Phase+(Nxx.*X+Nyy.*Y),2*pi)/pi-1)+1;
HoloU=HoloU/max(HoloU(:));

imagesc(HoloU(1:1:end,1:1:end));
colormap gray;
axis off;

%figure(2),
%imagesc(HoloU)
%colormap gray;
%axis equal;
%axis off;

% Fullscreen in the second display... java is preferred.
% if usejava('jvm')
fullscreen(HoloU,2);
colormap gray;
% else
% ResRes=get(0,'screensize');
% P1=ResRes(3);
% P2=ResRes(4);
% 
% fig=figure(2);
% set(fig,'Position',[P1 P2 1920 1080],'menubar','none','Toolbar','none','resize','off')
% set(gca,'Position',[0 0 1 1],'visible','off')
% imagesc(HoloU)
% axis equal;
% colormap gray;
% axis off;

% end
