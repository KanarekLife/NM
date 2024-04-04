a = 1;
b = 60000;
ytolerance = 1e-12;
max_iterations = 100;

[n_bisection,~,~,xtab_bisection,xdif_bisection] = bisection_method(a,b,max_iterations,ytolerance,@estimate_execution_time);
[n_secant,~,~,xtab_secant,xdif_secant] = secant_method(a,b,max_iterations,ytolerance,@estimate_execution_time);

subplot(2,1,1);
plot(xtab_bisection);
hold on;
plot(xtab_secant);
hold off;
legend('Bisection', 'Secant', 'Location','southeast');
title("Wartość kandydata na miejsce zerowe");
xlabel('Iteracja');
ylabel('Wartość');
subplot(2,1,2);
semilogy(xdif_bisection);
hold on;
semilogy(xdif_secant);
hold off;
legend('Bisection', 'Secant');
title("Bezwzględne wartości pomiędzy kolejnymi kandydatami na miejsce zerowe");
xlabel('Iteracja');
ylabel('Różnica');
saveas(gcf,'z_4_8.png');