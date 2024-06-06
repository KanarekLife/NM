function [integration_error, Nt, ft_5, xr, yr, yrmax] = zadanie4()
    % Numeryczne całkowanie metodą prostokątów.
    % Nt - wektor zawierający liczby podprzedziałów całkowania
    % integration_error - integration_error(1,i) zawiera błąd całkowania wyznaczony
    %   dla liczby podprzedziałów równej Nt(i). Zakładając, że obliczona wartość całki
    %   dla Nt(i) liczby podprzedziałów całkowania wyniosła integration_result,
    %   to integration_error(1,i) = abs(integration_result - reference_value),
    %   gdzie reference_value jest wartością referencyjną całki.
    % ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    % integral_1000 - całka od 0 do 5 funkcji gęstości prawdopodobieństwa
    %   dla 1000 podprzedziałów całkowania

    reference_value = 0.0473612919396179; % wartość referencyjna całki

    Nt = 5:50:10^4;
    integration_error = zeros(1, length(Nt));

    xr = cell(1, length(Nt));
    yr = cell(1, length(Nt));

    for i = 1:length(Nt)
        [integration_result, xr{i}, yr{i}, yrmax] = integral(@f, Nt(i));
        integration_error(i) = abs(integration_result - reference_value);
    end

    ft_5 = f(5);
    [integral_1000, ~, ~, ~] = integral(@f, 1000);
    disp(integral_1000);

    loglog(Nt, integration_error);
    xlabel('N');
    ylabel('Błąd całkowania');
    title('Błąd całkowania metodą prostokątów');

    saveas(gcf, 'zadanie4.png');
end

function [result, xr, yr, yrmax] = integral(f, N)
    a = 0;
    b = 5;
    xr = zeros(1, N);
    yr = zeros(1, N);
    yrmax = 1.5 * f(5);

    N_1 = 0;
    for i = 1:N
        xr(i) = a + (b-a) * rand(1);
        yr(i) = yrmax * rand(1);
        if yr(i) <= f(xr(i))
            N_1 = N_1 + 1;
        end
    end
    S = (b-a) * yrmax;
    result = S * N_1 / N;
end

function y = f(t)
    sigma = 3;
    mu = 10;
    y = 1/(sigma*sqrt(2*pi)) * exp((-(t-mu).^2)/(2*sigma^2));
end