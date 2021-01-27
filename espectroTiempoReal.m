function espectroTiempoReal(y, Fs, audioP, plt)
    persistent currSampAnt
    if isempty(currSampAnt) || currSampAnt > audioP.CurrentSample
        currSampAnt = 0;
    end
    if audioP.CurrentSample >= 2
        vent = currSampAnt+1:audioP.CurrentSample;
        currSampAnt = audioP.CurrentSample;
    else
        vent = currSampAnt+1:length(y);
    end
    y = y(vent);
    [Pxx,F] = periodogram(y,rectwin(length(y)),...
                          2^nextpow2(length(y)),Fs);
    Pxx = 10*log(Pxx);
    F = F/1e3;
    plt.XData = F;
    plt.YData = Pxx;
end