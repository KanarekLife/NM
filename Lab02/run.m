clear all
close all
format compact

n_max = 200;
a = 10;
r_max = 10;

[circles, index_number, circle_areas] = generate_circles(a, r_max, n_max);
plot_circles(a, circles, index_number);
% print -dpng zadanie1.png
