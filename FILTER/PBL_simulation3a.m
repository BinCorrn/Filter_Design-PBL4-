% ----- BƯỚC 1: Tín hiệu liên tục -----
f = 200e6;                      % Tần số tín hiệu: 200 Hz
t_cont = 0:1e-10:1/f*3;         % Trục thời gian liên tục
x_cont = 0.8*sin(2*pi*f*t_cont);  % Tín hiệu analog

% ----- BƯỚC 2: Lấy mẫu -----
fs = 10*f;                   % Tần số lấy mẫu
t_sample = 0:1/fs:1/f*3;
x_sample = 0.8*sin(2*pi*f*t_sample);

% ----- BƯỚC 3: Lượng tử hóa theo ADC 8-bit (1 bit dấu + 7 bit trị tuyệt đối) -----
nbit = 10;
nb_magnitude = nbit - 1;     % Số bit cho magnitude
max_val = 2^(nb_magnitude) - 1;  % Giá trị tối đa của trị tuyệt đối
Vref = 1;

% Scale và lượng tử hóa vào miền [-127, 127]
x_scaled = round((x_sample / Vref) * max_val);

% ----- BƯỚC 4: Biểu diễn mỗi điểm thành chuỗi nhị phân -----
bit_stream = strings(length(x_scaled), 1);  % Chuỗi bit cho mỗi mẫu

for i = 1:length(x_scaled)
    val = x_scaled(i);
    if val < 0
        sign_bit = '0';
        magnitude = dec2bin(abs(val), nb_magnitude);  % 7 bit trị tuyệt đối
    else
        sign_bit = '1';
        magnitude = dec2bin(val, nb_magnitude);
    end
    bit_stream(i) = string(sign_bit) + string(magnitude);
  % Nối lại thành 8-bit chuỗi
end

% ----- Hình 1: Vẽ tín hiệu -----
figure;
plot(t_cont, x_cont, 'k--', 'LineWidth', 1.2); hold on;

legend('Analog signal');
xlabel('Time (s)');
ylabel('Amplitude');
title('Analog');
grid on;

% ----- TẠO CHUỖI BIT LIÊN TỤC -----
full_bitstream = join(bit_stream, "");       % Nối tất cả các chuỗi lại thành một chuỗi
bit_array = double(char(full_bitstream{1}) - '0');  % Chuyển thành mảng số 0/1

% ----- TẠO TRỤC THỜI GIAN CHO MỖI BIT -----
bit_duration = 1e-4;  % Giả sử mỗi bit kéo dài 0.1ms
t_bit = 0:bit_duration:bit_duration * length(bit_array);  % Trục thời gian

% Đảm bảo độ dài t_bit = length(bit_array)+1 để vẽ được stairs
if length(t_bit) > length(bit_array)
    bit_array(end+1) = bit_array(end);  % Lặp lại bit cuối
end

% ----- VẼ SÓNG DIGITAL -----
figure;
stairs(t_bit, bit_array, 'LineWidth', 2);
ylim([-0.2, 1.2]);
xlabel('Time (s)');
ylabel('Digital Level');
title('Digital Bitstream from Quantized Samples');
grid on;


