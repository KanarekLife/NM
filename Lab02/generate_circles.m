function [circles, index_number] = generate_circles(a, r_max, n_max)
    index_number = 193044;
    L1 = mod(index_number, 10); % always 4
    if mod(L1, 2) == 0
        circles = zeros(n_max, 3);
        for i = 1:size(circles, 1)
            while true
                r = rand()*r_max;
                x = rand()*a;
                y = rand()*a;

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
                break
            end
        end
    else
        circles = zeros(3, n_max);
        for i = 1:size(circles, 2)
            while true
                r = rand()*r_max;
                x = rand()*a;
                y = rand()*a;

                if x - r < 0 || x + r > a || y - r < 0 || y + r > a
                    continue
                end
                
                is_blocked = false;
                for j = 1:i-1
                    current_column = circles(:,j);
                    if sqrt((current_column(1) - x)^2 + (current_column(2) - y)^2) < r + current_column(3)
                        is_blocked = true;
                        break;
                    end
                end

                if is_blocked
                    continue
                end

                circles(:,i) = [r; x; y];
                break
            end
        end
    end
end