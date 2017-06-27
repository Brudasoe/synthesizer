function varargout = synth(varargin)
% SYNTH MATLAB code for synth.fig
%      SYNTH, by itself, creates a new SYNTH or raises the existing
%      singleton*.
%
%      H = SYNTH returns the handle to a new SYNTH or the handle to
%      the existing singleton*.
%
%      SYNTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNTH.M with the given input arguments.
%
%      SYNTH('Property','Value',...) creates a new SYNTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before synth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to synth_OpeningFcn via varargin.
%f
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help synth

% Last Modified by GUIDE v2.5 16-Mar-2017 23:12:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @synth_OpeningFcn, ...
                   'gui_OutputFcn',  @synth_OutputFcn, ...
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


% --- Executes just before synth is made visible.
function synth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to synth (see VARARGIN)

% Choose default command line output for synth
handles.output = hObject;
handles.fs=16384;

set (handles.target1,'String',0.8)
set (handles.target2,'String',0.25)
set (handles.target3,'String',0)

set (handles.gain1,'String',0.0010)
set (handles.gain2,'String',0.0010)
set (handles.gain3,'String',0.00075)

set (handles.duration1,'String',100)
set (handles.duration2,'String',200)
set (handles.duration3,'String',100)





handles.target=[str2double(get(handles.target1,'String')); str2double(get(handles.target2,'String'));str2double(get(handles.target3,'String'))];
handles.gain=[str2double(get(handles.gain1,'String')); str2double(get(handles.gain2,'String'));str2double(get(handles.gain3,'String'))];
handles.duration=[str2double(get(handles.duration1,'String')); str2double(get(handles.duration2,'String'));str2double(get(handles.duration3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes synth wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = synth_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in A.
function A_Callback(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];

handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
amp=[str2double(get(handles.amp,'String'))];

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};

firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');

note_freq=55.0;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in C.
function C_Callback(hObject, eventdata, handles)
% hObject    handle to C (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};

firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=32.70;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in B.
function B_Callback(hObject, eventdata, handles)
% hObject    handle to B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=61.74;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));

% --- Executes on button press in D.
function D_Callback(hObject, eventdata, handles)
% hObject    handle to D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=36.71;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in E.
function E_Callback(hObject, eventdata, handles)
% hObject    handle to E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=41.20;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in F.
function F_Callback(hObject, eventdata, handles)
% hObject    handle to F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=43.65;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in G.
function G_Callback(hObject, eventdata, handles)
% hObject    handle to G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=49;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));

% --- Executes on button press in Csharp.
function Csharp_Callback(hObject, eventdata, handles)
% hObject    handle to Csharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=34.65;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in Eb.
function Eb_Callback(hObject, eventdata, handles)
% hObject    handle to Eb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=38.89;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));



% --- Executes on button press in Fsharp.
function Fsharp_Callback(hObject, eventdata, handles)
% hObject    handle to Fsharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=46.25;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in Gsharp.
function Gsharp_Callback(hObject, eventdata, handles)
% hObject    handle to Gsharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=51.91;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));


% --- Executes on button press in Bb.
function Bb_Callback(hObject, eventdata, handles)
% hObject    handle to Bb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;
oct=round(get(handles.octaveSlider,'Value'));
time=[str2double(get(handles.time,'String'))];
amp=[str2double(get(handles.amp,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);

pop_string= get(handles.SelectWave,'String');
pop_val = get(handles.SelectWave, 'Value');
waveType=pop_string{pop_val};


firstharmonic=get(handles.firstHarmonic,'Value');
secondharmonic=get(handles.secondHarmonic,'Value');
thirdharmonic=get(handles.thirdHarmonic,'Value');
fourthharmonic=get(handles.fourthHarmonic,'Value');
fifthharmonic=get(handles.fifthHarmonic,'Value');
note_freq=58.27;
f0=oct*note_freq;
x = amp*singen(f0,handles.fs,time-1/handles.fs,firstharmonic,secondharmonic,thirdharmonic,fourthharmonic,fifthharmonic,waveType);
y = handles.adsr .* x;  % Modulate
sound(y,handles.fs);
axes(handles.axes1);
plot(y)

N=length(y);
dt=1/handles.fs;
Xc=fft(y);
df=1/(N*dt);
f=df*(0:N-1);
axes(handles.axes2);
plot(f(1:N/2+1),abs(Xc(1:N/2+1))/(N/2));







% --- Executes on slider movement.
function firstHarmonic_Callback(hObject, eventdata, handles)
% hObject    handle to firstHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function firstHarmonic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function secondHarmonic_Callback(hObject, eventdata, handles)
% hObject    handle to secondHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function secondHarmonic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function thirdHarmonic_Callback(hObject, eventdata, handles)
% hObject    handle to thirdHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function thirdHarmonic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thirdHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target1_Callback(hObject, eventdata, handles)
% hObject    handle to target1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target1 as text
%        str2double(get(hObject,'String')) returns contents of target1 as a double
handles.output = hObject;
handles.target=[str2double(get(handles.target1,'String')); str2double(get(handles.target2,'String'));str2double(get(handles.target3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function target1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target2_Callback(hObject, eventdata, handles)
% hObject    handle to target2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target2 as text
%        str2double(get(hObject,'String')) returns contents of target2 as a double
handles.output = hObject;
handles.target=[str2double(get(handles.target1,'String')); str2double(get(handles.target2,'String'));str2double(get(handles.target3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function target2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target3_Callback(hObject, eventdata, handles)
% hObject    handle to target3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target3 as text
%        str2double(get(hObject,'String')) returns contents of target3 as a double
handles.output = hObject;
handles.target=[str2double(get(handles.target1,'String')); str2double(get(handles.target2,'String'));str2double(get(handles.target3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function target3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gain1_Callback(hObject, eventdata, handles)
% hObject    handle to gain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain1 as text
%        str2double(get(hObject,'String')) returns contents of gain1 as a double
handles.output = hObject;
handles.gain=[str2double(get(handles.gain1,'String')); str2double(get(handles.gain2,'String'));str2double(get(handles.gain3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function gain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gain2_Callback(hObject, eventdata, handles)
% hObject    handle to gain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain2 as text
%        str2double(get(hObject,'String')) returns contents of gain2 as a double
handles.output = hObject;
handles.gain=[str2double(get(handles.gain1,'String')); str2double(get(handles.gain2,'String'));str2double(get(handles.gain3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function gain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gain3_Callback(hObject, eventdata, handles)
% hObject    handle to gain3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gain3 as text
%        str2double(get(hObject,'String')) returns contents of gain3 as a double
handles.output = hObject;
handles.gain=[str2double(get(handles.gain1,'String')); str2double(get(handles.gain2,'String'));str2double(get(handles.gain3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function gain3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration1_Callback(hObject, eventdata, handles)
% hObject    handle to duration1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration1 as text
%        str2double(get(hObject,'String')) returns contents of duration1 as a double
handles.output = hObject;
handles.duration=[str2double(get(handles.duration1,'String')); str2double(get(handles.duration2,'String'));str2double(get(handles.duration3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function duration1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration2_Callback(hObject, eventdata, handles)
% hObject    handle to duration2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration2 as text
%        str2double(get(hObject,'String')) returns contents of duration2 as a double
handles.output = hObject;
handles.duration=[str2double(get(handles.duration1,'String')); str2double(get(handles.duration2,'String'));str2double(get(handles.duration3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function duration2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duration3_Callback(hObject, eventdata, handles)
% hObject    handle to duration3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration3 as text
%        str2double(get(hObject,'String')) returns contents of duration3 as a double
handles.output = hObject;
handles.duration=[str2double(get(handles.duration1,'String')); str2double(get(handles.duration2,'String'));str2double(get(handles.duration3,'String'))];
time=[str2double(get(handles.time,'String'))];
handles.adsr = adsr_gen(handles.target,handles.gain,handles.duration,time);
axes(handles.axes3);
plot(handles.adsr);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function duration3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function octaveSlider_Callback(hObject, eventdata, handles)
% hObject    handle to octaveSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles=guidata(hObject);
 octave_value = round(get(handles.octaveSlider,'Value'));
set(handles.octave,'String',num2str(octave_value));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function octaveSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to octaveSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function amp_Callback(hObject, eventdata, handles)
% hObject    handle to amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amp as text
%        str2double(get(hObject,'String')) returns contents of amp as a double


% --- Executes during object creation, after setting all properties.
function amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
 keyPressed = eventdata.Key;

 if strcmpi(keyPressed,'q')
     % set focus to the button
     uicontrol(handles.C);

     % call the callback
     C_Callback(handles.C,[],handles);
 end
 
  if strcmpi(keyPressed,'w')
     % set focus to the button
     uicontrol(handles.Csharp);

     % call the callback
     Csharp_Callback(handles.Csharp,[],handles);
  end
  
   if strcmpi(keyPressed,'e')
     % set focus to the button
     uicontrol(handles.D);

     % call the callback
     D_Callback(handles.D,[],handles);
   end
  
   if strcmpi(keyPressed,'r')
     % set focus to the button
     uicontrol(handles.Eb);

     % call the callback
     Eb_Callback(handles.Eb,[],handles);
   end
   
    if strcmpi(keyPressed,'t')
     % set focus to the button
     uicontrol(handles.E);

     % call the callback
     E_Callback(handles.E,[],handles);
    end
  
      if strcmpi(keyPressed,'y')
     % set focus to the button
     uicontrol(handles.F);

     % call the callback
     F_Callback(handles.F,[],handles);
      end
 
    if strcmpi(keyPressed,'u')
     % set focus to the button
     uicontrol(handles.Fsharp);

     % call the callback
     Fsharp_Callback(handles.Fsharp,[],handles);
  end
 
     if strcmpi(keyPressed,'i')
     % set focus to the button
     uicontrol(handles.G);

     % call the callback
     G_Callback(handles.G,[],handles);
  end
 
     if strcmpi(keyPressed,'o')
     % set focus to the button
     uicontrol(handles.Gsharp);

     % call the callback
     Gsharp_Callback(handles.Gsharp,[],handles);
     end
 
      if strcmpi(keyPressed,'p')
     % set focus to the button
     uicontrol(handles.A);

     % call the callback
     A_Callback(handles.A,[],handles);
  end
 
    if strcmpi(keyPressed,'g')
     % set focus to the button
     uicontrol(handles.Bb);

     % call the callback
     Bb_Callback(handles.Bb,[],handles);
    end
 
      if strcmpi(keyPressed,'h')
     % set focus to the button
     uicontrol(handles.B);

     % call the callback
     B_Callback(handles.B,[],handles);
  end
 


% --- Executes on slider movement.
function fourthHarmonic_Callback(hObject, eventdata, handles)
% hObject    handle to fourthHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function fourthHarmonic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fourthHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fifthHarmonic_Callback(hObject, eventdata, handles)
% hObject    handle to fifthHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function fifthHarmonic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fifthHarmonic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in SelectWave.
function SelectWave_Callback(hObject, eventdata, handles)
% hObject    handle to SelectWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelectWave contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectWave


% --- Executes during object creation, after setting all properties.
function SelectWave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
