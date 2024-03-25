function [A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Gauss_Seidel(N)
    index_number = 193044;
    L1 = mod(index_number, 10);
    [A,b] = generate_matrix(N, L1);

    x = ones(N, 1);
    err_norm = Inf;
    iterations = 0;
    tic;
    M = -1 * ((tril(A,-1)+diag(diag(A)))\triu(A,1));
    bm = (diag(diag(A)) + tril(A, -1))\b;
    while err_norm > 10^-10
        x = M*x + bm;
        iterations = iterations + 1;
        err_norm = norm(A*x-b);
    end
    time = toc;
end