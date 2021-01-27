function mostrar_grafica(check, linea, xData, yData)
    if check
        linea.XData = xData/1e3;
        linea.YData = 10*log( abs(yData) );
    else
        linea.XData = 1;
        linea.YData = 1;
    end

end