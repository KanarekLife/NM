function [A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Jacobi(N)
    index_number = 193044;
    L1 = mod(index_number, 10);
    [A,b] = generate_matrix(N, L1);

    x = ones(N, 1);
    tic;
    for iterations = 1:100
        M = -1 * (diag(diag(A))\(tril(A, -1) + triu(A, 1)));
        % inv(A) * b == A\b
        bm = diag(diag(A))\ b;
        x = M * x + bm;
    end
    time = toc;
    err_norm = norm(A*x-b);
end