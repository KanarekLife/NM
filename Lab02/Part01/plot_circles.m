function plot_circles(a, circles, index_number)
    axis equal
    axis([0 a 0 a])
    hold on

    if mod(index_number, 2) == 0
        for i = 1:size(circles, 1)
            current_row = circles(i,:);
            plot_circle(current_row(3), current_row(1), current_row(2))
        end
    end
    hold off
end