function [lake_volume, x, y, z, zmin] = zadanie5()
    % Funkcja zadanie5 wyznacza objętość jeziora metodą Monte Carlo.
    %
    %   lake_volume - objętość jeziora wyznaczona metodą Monte Carlo
    %
    %   x - wektor wierszowy, który zawiera współrzędne x wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   y - wektor wierszowy, który zawiera współrzędne y wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   z - wektor wierszowy, który zawiera współrzędne z wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   zmin - minimalna dopuszczalna wartość współrzędnej z losowanych punktów
    N = 1e6;
    N1 = 0;

    zmin = -60;

    x = 100*rand(1,N); % [m]
    y = 100*rand(1,N); % [m]
    z = zmin * rand(1,N); % [m]

    for i = 1:N
        x_i = x(i);
        y_i = y(i);
        z_i = z(i);
        depth = get_lake_depth(x_i, y_i);
        if z_i >= depth
            N1 = N1 + 1;
        end
    end
    cuboid_volume = 100 * 100 * abs(zmin);
    lake_volume = cuboid_volume * N1 / N;
    disp(lake_volume);
end