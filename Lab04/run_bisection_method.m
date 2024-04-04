a = 1;
b = 50;
max_iterations = 100;
ytolerance = 10^(-12);

[xsolution,ysolution,iterations,xtab,xdif] = bisection_method(a,b,max_iterations,ytolerance,@impedance_magnitude);