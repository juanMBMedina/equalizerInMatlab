%% Respuestas al impuso de los filtros
%% Cargar filtro
clc, clear variables, close all
Fs = 44100;
F = linspace(0,Fs,1024);
f1 = load ('Filtros/F20_200_44100.mat');
f2 = load ('Filtros/F200_500_44100.mat');
f3 = load ('Filtros/F500_2000_44100.mat');
f4 = load ('Filtros/F2000_4000_44100.mat');
f5 = load ('Filtros/F4000_8000_44100.mat');
f6 = load ('Filtros/F8000_12000_44100.mat');
f7 = load ('Filtros/F12000_20000_44100.mat');
filtros = [f1.Hd f2.Hd f3.Hd f4.Hd f5.Hd f6.Hd f7.Hd];
[H,f] = freqz(filtros,1024,Fs);
clear f1 f2 f3 f4 f5 f6 f7;

for i = 1 : length(filtros)
    figure(1)
    subplot(2,1,1)
    plot(f*1/1e3,10*log(abs(H(:,i))),'r','LineWidth',1.5);
 	xlim([f(1) f(end)]*1/1e3)
    ylim([-5 max(10*log(abs(H(:,i))))])
    xlabel('Frecuencia [kHz]')
    ylabel('Ganancia [dB]')
    title('Magnitud')
    grid on
    subplot(2,1,2)
    plot(f*1/1e3,angle(H(:,i)),'LineWidth',1.5);
 	xlim([f(1) f(end)]*1/1e3)
    xlabel('Frecuencia [kHz]')
    ylabel('Fase [Rad]')
    title('Fase')
    grid on
    
    figure(2)
    plt2 = plot(0,0);
    [num,den] = sos2tf(filtros(i).sosMatrix, filtros(i).ScaleValues);
    [h,t] = impz(filtros(i));
    t = 1e3*t/Fs;
    h = 1e3*h;
    set(plt2,'XData', t);
    set(plt2,'YData', h);
    xlim([t(1) t(end)])
    ylim([min(h) max(h)])
    xlabel('Tiempo [ms]')
    ylabel('Ampltud [mV]')
    grid on
    pause;
end