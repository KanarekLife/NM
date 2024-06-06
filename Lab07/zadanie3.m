function [integration_error, Nt, ft_5, integral_1000] = zadanie3()
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

    for i = 1:length(Nt)
        integration_result = integral(@f, Nt(i));
        integration_error(i) = abs(integration_result - reference_value);
    end

    ft_5 = f(5);
    integral_1000 = integral(@f, 1000);
    disp(integral_1000);

    loglog(Nt, integration_error);
    xlabel('N');
    ylabel('Błąd całkowania');
    title('Błąd całkowania metodą prostokątów');

    saveas(gcf, 'zadanie3.png');
end

function result = integral(f, N)
    a = 0;
    b = 5;
    result = 0;
    dx = (b-a)/N;
    for i = 1:N
        x_i = a + (i-1) * dx;
        x_i_next = a + i * dx;
        result = result + f(x_i) + 4*f((x_i + x_i_next)/2) + f(x_i_next);
    end
    result = result * dx / 6;
end

function y = f(t)
    sigma = 3;
    mu = 10;
    y = 1/(sigma*sqrt(2*pi)) * exp((-(t-mu).^2)/(2*sigma^2));
end