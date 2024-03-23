load("filtr_dielektryczny.mat");

max_iterations = 1000;
accuracy = 1e-12;

% Solve Direct
tic
r = A\b;
time = toc;
err_norm_direct = norm(A*r-b);
fprintf('Direct Method: %fs\n', time);
fprintf('Direct Method error: %.15f\n', err_norm_direct);

% Jacobi
M = -1 * (diag(diag(A))\(tril(A, -1) + triu(A, 1)));
bm = diag(diag(A))\ b;
x = ones(length(b), 1);

err_norm = Inf;
iterations = 0;
jacobi_err_norms = zeros(max_iterations, 1);
tic
for i=1:max_iterations
    x = M * x + bm;
    iterations = iterations + 1;
    err_norm = norm(A*x-b);
    jacobi_err_norms(i) = err_norm;
    if (err_norm < accuracy || isinf(err_norm))
        break
    end
end
time = toc;
jacobi_err_norms = resize(jacobi_err_norms, iterations);
fprintf("Jacobi Method: %fs\n", time);
fprintf("Jacobi Method error: %.15f\n", err_norm);
fprintf("Jacobi Method iter: %d / %d\n", iterations, max_iterations);

plot(jacobi_err_norms);
ylim([-1000 1000])
hold on;

% Gauss-Seidel

x = ones(length(b), 1);
M = -1 * ((tril(A,-1)+diag(diag(A)))\triu(A,1));
bm = (diag(diag(A)) + tril(A, -1))\b;

err_norm = Inf;
iterations = 0;
gs_err_norms = zeros(max_iterations, 1);
tic
for i=1:max_iterations
    x = M*x + bm;
    iterations = iterations + 1;
    err_norm = norm(A*x-b);
    gs_err_norms(i) = err_norm;
    if (err_norm < accuracy || isinf(err_norm))
        break
    end
end
time = toc;
gs_err_norms = resize(gs_err_norms, iterations);
fprintf("GS Method: %fs\n", time);
fprintf("GS Method error: %.15f\n", err_norm);
fprintf("GS Method iter: %d / %d\n", iterations, max_iterations);


plot(gs_err_norms);
ylim([-1000 1000])
hold off;
title 'Normy błędu metod iteracyjnych'
xlabel 'Ilość iteracji'
ylabel 'Norma błędu'
legend({'Jacobi', 'Gauss-Seidel'}, 'Location', 'eastoutside')
saveas(gcf, 'zadanie6.png')
