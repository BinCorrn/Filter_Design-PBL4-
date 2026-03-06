input = [1 1 1 0];
Vref = 5;
n_bits = 4;
decimal_value = input*[8;4;2;1];
Vout = Vref*decimal_value/(2^n_bits-1);
disp("Điện áp đầu ra của bộ DAC là:"); disp(Vout);