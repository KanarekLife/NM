N = 1000:1000:8000;
n = length(N);
vtime_direct = ones(1,n);
for i = 1:n
    [A,b,x,time_direct,err_norm,index_number] = solve_direct(N(i));
    vtime_direct(i) = time_direct;
end
plot_direct(N,vtime_direct);