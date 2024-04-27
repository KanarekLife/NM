function [matrix_condition_numbers, max_coefficients_difference_1, max_coefficients_difference_2] = zadanie3()
% Zwracane są trzy wektory wierszowe:
% matrix_condition_numbers - współczynniki uwarunkowania badanych macierzy Vandermonde
% max_coefficients_difference_1 - maksymalna różnica między referencyjnymi a obliczonymi współczynnikami wielomianu,
%       gdy b zawiera wartości funkcji liniowej
% max_coefficients_difference_2 - maksymalna różnica między referencyjnymi a obliczonymi współczynnikami wielomianu,
%       gdy b zawiera zaburzone wartości funkcji liniowej

N = 5:40;

%% chart 1
subplot(3, 1, 1);
matrix_condition_numbers = zeros(1, length(N));
for i = 1:length(N)
    ni = N(i);
    V = vandermonde_matrix(ni);
    matrix_condition_numbers(i) = cond(V);
end
semilogy(N, matrix_condition_numbers);
xlabel('Rozmiar macierzy');
ylabel('Współczynnik uwarunkowania');
title('Wzrost współczynnika uwarunkowania macierzy Vandermonde wraz ze wzrostem jej rozmiaru.');

%% chart 2
subplot(3, 1, 2);
a1 = randi([20,30]);
max_coefficients_difference_1 = zeros(1, length(N));
for i = 1:length(N)
    ni = N(i);
    V = vandermonde_matrix(ni);
    
    % Niech wektor b zawiera wartości funkcji liniowej
    b = linspace(0,a1,ni)';
    reference_coefficients = [ 0; a1; zeros(ni-2,1) ]; % tylko a1 jest niezerowy
    
    % Wyznacznie współczynników wielomianu interpolującego
    calculated_coefficients = V \ b;

    max_coefficients_difference_1(i) = max(abs(calculated_coefficients-reference_coefficients));
end
plot(N, max_coefficients_difference_1);
xlabel('Rozmiar macierzy')
ylabel('Błąd wyznaczania wartości współczynników wielomianu')
title('Błąd wyznaczania wartości współczynników wielomianu dla funkcji liniowej b')

%% chart 3
subplot(3, 1, 3);
max_coefficients_difference_2 = zeros(1, length(N));
for i = 1:length(N)
    ni = N(i);
    V = vandermonde_matrix(ni);
    
    % Niech wektor b zawiera wartości funkcji liniowej nieznacznie zaburzone
    b = linspace(0,a1,ni)' + rand(ni,1)*1e-10;
    reference_coefficients = [ 0; a1; zeros(ni-2,1) ]; % tylko a1 jest niezerowy
    
    % Wyznacznie współczynników wielomianu interpolującego
    calculated_coefficients = V \ b;
    
    max_coefficients_difference_2(i) = max(abs(calculated_coefficients-reference_coefficients));
end
plot(N, max_coefficients_difference_2);
xlabel('Rozmiar macierzy')
ylabel('Błąd wyznaczania wartości współczynników wielomianu')
title('Błąd wyznaczania wartości współczynników wielomianu dla funkcji liniowej nieznacznie zaburzonej b')

saveas(gcf, 'zadanie3.png');
end


function V = vandermonde_matrix(N)
    % Generuje macierz Vandermonde dla N punktów równomiernie rozmieszczonych w przedziale [0, 1]
    x_coarse = linspace(0,1,N);
    V = ones(N, N);
    for i = 1:N
        for j = 0:(N-1)
            V(i,j+1) = power(x_coarse(i), j);
        end
    end
end