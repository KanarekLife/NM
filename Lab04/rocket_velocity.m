function velocity_delta = rocket_velocity(t)
    if t <= 0
        error("t must be greater than 0");
    end

    M = 750;
    m0 = 150000;
    u = 2000;
    q = 2700;
    g = 1.622;

    v = u * log(m0/(m0 - (q * t))) - (g * t);

    velocity_delta = v - M;
end