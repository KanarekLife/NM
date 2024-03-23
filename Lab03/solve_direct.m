function [A,b,x,time_direct,err_norm,index_number] = solve_direct(N)
    index_number = 193044;
    L1 = mod(index_number, 10);
    [A,b] = generate_matrix(N, L1);
    tic;
    x = A\b;
    time_direct = toc;
    err_norm = norm(A*x - b);
end