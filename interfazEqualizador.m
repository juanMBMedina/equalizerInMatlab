function varargout = interfazEqualizador(varargin)
%INTERFAZEQUALIZADOR MATLAB code file for interfazEqualizador.fig
%      INTERFAZEQUALIZADOR, by itself, creates a new INTERFAZEQUALIZADOR or raises the existing
%      singleton*.
%
%      H = INTERFAZEQUALIZADOR returns the handle to a new INTERFAZEQUALIZADOR or the handle to
%      the existing singleton*.
%
%      INTERFAZEQUALIZADOR('Property','Value',...) creates a new INTERFAZEQUALIZADOR using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to interfazEqualizador_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      INTERFAZEQUALIZADOR('CALLBACK') and INTERFAZEQUALIZADOR('CALLBACK',hObject,...) call the
%      local function named CALLBACK in INTERFAZEQUALIZADOR.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interfazEqualizador

% Last Modified by GUIDE v2.5 13-Nov-2020 22:55:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interfazEqualizador_OpeningFcn, ...
                   'gui_OutputFcn',  @interfazEqualizador_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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
% --- Executes just before interfazEqualizador is made visible.
function interfazEqualizador_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
% Choose default command line output for interfazEqualizador
handles.output = hObject;
% Update handles structure
clc
handles.Fs = 44100;
handles.signal = [];
handles.filter_signal = [];
handles.Pxx = [];
handles.Frecs = [];
handles.PxxH = []; % Respuestas de filtros
handles.H_frec = [];
handles.plt   = plot(1,1,'Color',[240 255 0]/255);
line1 = line(1,1,'Color',[ 19 146   6]/255,'LineWidth',1.5);
line2 = line(1,1,'Color',[142 255 138]/255,'LineWidth',1.5);
line3 = line(1,1,'Color',[227  59  18]/255,'LineWidth',1.5);
line4 = line(1,1,'Color',[135  18 227]/255,'LineWidth',1.5);
line5 = line(1,1,'Color',[240  59 215]/255,'LineWidth',1.5);
line6 = line(1,1,'Color',[ 61 209 204]/255,'LineWidth',1.5);
line7 = line(1,1,'Color',[  0  35 253]/255,'LineWidth',1.5);
handles.lines = [line1 line2 line3 line4 line5 line6 line7];
mostrar_etiquetas();
handles.audio = audioplayer(0, handles.Fs);
set(handles.grafica, 'GridColor', [1 1 1]);
set(handles.grafica, 'Color', [0 0 0]);
% Reiniciar Botones.
set(handles.checkButFil1 ,'Value',0);
set(handles.checkButFil2 ,'Value',0);
set(handles.checkButFil3 ,'Value',0);
set(handles.checkButFil4 ,'Value',0);
set(handles.checkButFil5 ,'Value',0);
set(handles.checkButFil6 ,'Value',0);
set(handles.checkButFil7 ,'Value',0);
set(handles.audioCompleto,'Value',0);
set(handles.audioFiltrado,'Value',0);
% Filtros Diseñados.
fil1 = load ('Filtros/F20_200_44100.mat');
fil2 = load ('Filtros/F200_500_44100.mat');
fil3 = load ('Filtros/F500_2000_44100.mat');
fil4 = load ('Filtros/F2000_4000_44100.mat');
fil5 = load ('Filtros/F4000_8000_44100.mat');
fil6 = load ('Filtros/F8000_12000_44100.mat');
fil7 = load ('Filtros/F12000_20000_44100.mat');
handles.filters = [fil1.Hd fil2.Hd fil3.Hd fil4.Hd ...
                   fil5.Hd fil6.Hd fil7.Hd ];
guidata(hObject, handles);
% UIWAIT makes interfazEqualizador wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = interfazEqualizador_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in cargarArchivo.
function cargarArchivo_Callback(hObject, eventdata, handles)
% hObject    handle to cargarArchivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
disp('Load data.')
[file,path] = uigetfile('*.wav');
if ~isequal(file,0)
   disp(['User selected ', fullfile(path,file)]);
   [y, Fs] = audioread(fullfile(path,file));
   if Fs == handles.Fs
       [~,cols] = size(y);
       if cols > 1
           y = sum(y,2)/cols; % Suma cada columna y Promedia
       end
       [Pxx,F] = periodogram(y,rectwin(length(y)),...
                          2^nextpow2(length(y)),Fs);
       handles.signal = y;
       handles.Frecs = F;
       handles.Pxx = Pxx;
       % Graficar.
       mostrar_grafica(1, handles.plt, F, Pxx);
       set(handles.grafica,'Xlim', [0 max(F/1e3)]);
       set(handles.grafica,'Ylim', [min(handles.plt.YData) 100]);
       %RTA en frecuencia Filtros.
       handles.H_frec = Fs/2*linspace(0,1,1024);
       handles.PxxH = freqz(handles.filters, length(handles.H_frec));
   else
       msgbox(['Frecuencia: ' num2str(Fs) '[Hz] invalida'],'Fs','error');
   end
else
    if isempty(handles.signal)
        msgbox('Cargue un archivo .wav','Error','error');
    end
end
guidata(hObject, handles);
% --- Executes on button press in Filtrar.
function Filtrar_Callback(hObject, eventdata, handles)
% hObject    handle to Filtrar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1 : length(handles.lines)
    handles.lines(i).XData = 1;
    handles.lines(i).YData = 1;
end
if ~isempty(handles.signal)
    vCheck = [get(handles.checkButFil1, 'Value') ...
              get(handles.checkButFil2, 'Value') ...
              get(handles.checkButFil3, 'Value') ...
              get(handles.checkButFil4, 'Value') ...
              get(handles.checkButFil5, 'Value') ...
              get(handles.checkButFil6, 'Value') ...
              get(handles.checkButFil7, 'Value') ...
              ];
    cantFiltros = length(vCheck);
	y = handles.signal * ones(1,cantFiltros);
    clc;
    for i = 1 : cantFiltros
        if vCheck(i)
            y(:,i) = filter(handles.filters(i),y(:,i));
            disp(['Filtro ' num2str(i) ' Aplicado...'])
        else
            y(:,i) = 0;
        end
    end
    y = sum(y,2)/sum(vCheck);
    [Pxx,F] = periodogram(y,rectwin(length(y)),...
                          2^nextpow2(length(y)),handles.Fs);
	mostrar_grafica(1, handles.plt, F, Pxx);
	set(handles.grafica,'XLim', [0 max(F/1e3)]);
    handles.filter_signal = y;
else
    msgbox('Cargue un archivo .wav','Error','error')
end
guidata(hObject, handles);
% --- Executes on button press in repAudio.
function repAudio_Callback(hObject, eventdata, handles)
% hObject    handle to repAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.signal)
    if get(handles.audioFiltrado, 'Value') && ~isempty(handles.filter_signal)
        msgbox('Reproduciendo audio Filtrado.')
        y = handles.filter_signal;
    else
        msgbox('Reproduciendo audio Original.')
        y = handles.signal;
    end
    handles.audio = audioplayer(y, handles.Fs);
    set(handles.audio,'TimerPeriod', 0.1);
    set(handles.audio,'TimerFcn', @(~,~)espectroTiempoReal(y, ...
        handles.Fs, handles.audio, handles.plt))
    mostrar_etiquetas();
    if get(handles.audioCompleto,'Value')
        play(handles.audio);
    else
        play(handles.audio, [1 15*handles.Fs]);
    end
else
    msgbox('Cargue un archivo .wav o Filtre el audio.','Error','error');
end
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function grafica_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grafica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate grafica

% --- Executes on button press in reinicio.
function reinicio_Callback(hObject, eventdata, handles)
% hObject    handle to reinicio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plt.XData = 1;
handles.plt.YData = 1;
for i = 1 : length(handles.lines)
    handles.lines(i).XData = 1;
    handles.lines(i).YData = 1;
end
% % Borra los datos.
handles.signal = [];
handles.filter_signal = [];
handles.Pxx = [];
handles.Frecs = [];
handles.PxxH = []; % Respuestas de filtros
handles.H_frec = [];
% Reiniciar Botones.
set(handles.checkButFil1 ,'Value',0);
set(handles.checkButFil2 ,'Value',0);
set(handles.checkButFil3 ,'Value',0);
set(handles.checkButFil4 ,'Value',0);
set(handles.checkButFil5 ,'Value',0);
set(handles.checkButFil6 ,'Value',0);
set(handles.checkButFil7 ,'Value',0);
set(handles.audioCompleto,'Value',0);
set(handles.audioFiltrado,'Value',0);
guidata(hObject, handles);
% --- Executes on button press in mostrarFiltros.
function mostrarFiltros_Callback(hObject, eventdata, handles)
% hObject    handle to mostrarFiltros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plt.XData = handles.Frecs/1e3;
handles.plt.YData = 10*log( abs(handles.Pxx) );
if ~isempty(handles.signal)
    vCheck = [get(handles.checkButFil1, 'Value') ...
              get(handles.checkButFil2, 'Value') ...
              get(handles.checkButFil3, 'Value') ...
              get(handles.checkButFil4, 'Value') ...
              get(handles.checkButFil5, 'Value') ...
              get(handles.checkButFil6, 'Value') ...
              get(handles.checkButFil7, 'Value') ...
              ];
    for i = 1 : length(vCheck)
        if vCheck(i)
            handles.lines(i).XData = handles.H_frec/1e3;
            handles.lines(i).YData = 10*log( abs(handles.PxxH(:,i)) );
        else
            handles.lines(i).XData = 1;
            handles.lines(i).YData = 1;
        end
    end
else
    msgbox('Cargue un archivo .wav','Error','error');
end    