function [xsolution,ysolution,iterations,xtab,xdif] = secant_method(a,b,max_iterations,ytolerance,fun)
    % a - lewa granica przedziału poszukiwań miejsca zerowego (x0=a)
    % b - prawa granica przedziału poszukiwań miejsca zerowego (x1=b)
    % max_iterations - maksymalna liczba iteracji działania metody siecznych
    % ytolerance - wartość abs(fun(xsolution)) powinna być mniejsza niż ytolerance
    % fun - nazwa funkcji, której miejsce zerowe będzie wyznaczane
    %
    % xsolution - obliczone miejsce zerowe
    % ysolution - wartość fun(xsolution)
    % iterations - liczba iteracji wykonana w celu wyznaczenia xsolution
    % xtab - wektor z kolejnymi kandydatami na miejsce zerowe, począwszy od x2
    % xdiff - wektor wartości bezwzględnych z różnic pomiędzy i-tym oraz (i+1)-ym elementem wektora xtab; xdiff(1) = abs(xtab(2)-xtab(1));

    xtab = zeros(max_iterations);
    xdif = zeros(max_iterations);

    for iterations = 1:max_iterations
        c = b - ((fun(b) * (b - a))/(fun(b) - fun(a)));

        xtab(iterations) = c;
        if iterations > 1
            xdif(iterations-1) = abs(xtab(iterations) - xtab(iterations-1));
        end
        
        if abs(fun(c)) < ytolerance
            xsolution = c;
            ysolution = fun(c);
            break;
        end

        a = b;
        b = c;
    end

    xtab = xtab(1:iterations)';
    xdif = xdif(1:iterations-1)';
end