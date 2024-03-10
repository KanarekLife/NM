function [numer_indeksu, Edges, I, B, A, b, r] = page_rank()
    numer_indeksu = 193044;
    L1 = floor(mod(numer_indeksu, 100) / 10);
    L2 = floor(mod(numer_indeksu, 1000) / 100);

    n = 8;
    d = 0.85;

    Edges = [1,1,6,7,6,4,4,5,5,2,2,2,3,3,3,8           ,mod(L2, 7)+1  ;
             6,4,7,6,4,6,5,4,6,4,3,5,5,6,7,mod(L1, 7)+1,8             ];
    
    I = speye(n);
    row_indices = Edges(2,:);
    col_indices = Edges(1,:);
    B = sparse(row_indices, col_indices, 1, n, n);
    L = sum(B).';
    A = spdiags(1./L, 0, n, n);
    b = zeros(n,1) + (1-d)/n;
    M = sparse(I - d*B*A);
    r = M\b;
end