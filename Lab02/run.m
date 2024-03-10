clear all
close all
format compact

n_max = 200;
a = 10;
r_max = 10;

[circles, index_number, circle_areas, rand_counts, counts_mean] = generate_circles(a, r_max, n_max);
plot_circles(a, circles, index_number);
print -dpng zadanie1.png

plot_circle_areas(circle_areas)
print -dpng zadanie3.png