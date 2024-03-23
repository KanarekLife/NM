function [A,b,M,bm,x,err_norm,time,iterations,index_number] = solve_Gauss_Seidel(N)
    index_number = 193044;
    L1 = mod(index_number, 10);
    [A,b] = generate_matrix(N, L1);

    x = ones(N, 1);
    tic;
    for iterations=1:100
        M = -1 * ((tril(A,-1)+diag(diag(A)))\triu(A,1));
        bm = (diag(diag(A)) + tril(A, -1))\b;
        x = M*x + bm;
    end
    time = toc;
    err_norm = norm(A*x-b);
end