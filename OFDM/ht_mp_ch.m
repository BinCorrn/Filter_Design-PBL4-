function h = ht_mp_ch(max_delay, L, decay_base, t_step)
    delays = sort(rand(1, L) * max_delay); 
    delay_indices = round(delays / t_step);
    amps = (randn(1, L) + 1j * randn(1, L)) .* exp(-decay_base * delays);
    amps = amps / norm(amps); 
    h = zeros(1, delay_indices(end) + 1);
    h(delay_indices + 1) = amps;
end
