function [circles, index_number, circle_areas, rand_counts, counts_mean] = generate_circles(a, r_max, n_max)
    index_number = 193044;
    L1 = mod(index_number, 10);
    L2 = floor(mod(index_number, 100) / 10);

    if mod(L1, 2) == 0
        circles = zeros(n_max, 3);
        rand_counts = zeros(1, n_max);
        counts_mean = zeros(1, n_max);
        for i = 1:size(circles, 1)
            while true
                r = rand()*r_max;
                x = rand()*a;
                y = rand()*a;
                rand_counts(i) = rand_counts(i) + 1;

                if x - r < 0 || x + r > a || y - r < 0 || y + r > a
                    continue
                end
                
                is_blocked = false;
                for j = 1:i-1
                    current_row = circles(j,:);
                    if sqrt((current_row(1) - x)^2 + (current_row(2) - y)^2) < r + current_row(3)
                        is_blocked = true;
                        break;
                    end
                end

                if is_blocked
                    continue
                end

                circles(i,:) = [x, y, r];
                tmp = cumsum(rand_counts);
                counts_mean(i) = tmp(i) / i;
                break
            end
        end
    else
        % TBD
    end
    if mod(L2, 2) == 0
        circle_areas = zeros(1, n_max);
        ssum = 0;
        for i = 1:size(circles)
            current_row = circles(i,:);
            ssum = ssum + pi * (current_row(3))^2;
            circle_areas(i) = ssum;
        end
    else
        % TBD
    end
end