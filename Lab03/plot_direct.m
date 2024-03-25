function plot_direct(N,vtime_direct)
    plot(N, vtime_direct)
    title 'Czas rozwiązywania układów równań metodą bezpośrednią'
    xlabel 'Wielkość macierzy'
    ylabel 'Czas obliczania'
    saveas(gcf, 'zadanie2.png')
end