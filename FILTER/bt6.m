clc; clear; close all;
[x1, R1] = audioread('Piano-G6.wav'); 
[x2, R2] = audioread('Piano-C8.wav'); 

R_factor = 4; 
Y1 = decimate(x1, R_factor); 
fs_new_G6 = R1 / R_factor;

Y2 = decimate(x2, R_factor);
fs_new_C8 = R2 / R_factor;

figure;
subplot(2,2,1);
plot(Y1, 'k'); 
title('Decimated G6.wav'); 
xlabel('Samples'); ylabel('Amplitude'); grid on;

subplot(2,2,2);
plot(Y2, 'b'); 
title('Decimated C8.wav'); 
xlabel('Samples'); ylabel('Amplitude'); grid on;

if ~isempty(audiodevinfo(0))
    soundsc(Y1, fs_new_G6);
    pause(length(Y1) / fs_new_G6 + 1);
    soundsc(Y2, fs_new_C8);
    pause(length(Y2) / fs_new_C8 + 1);
else
    disp('Không tìm thấy thiết bị âm thanh, bỏ qua phần phát.');
end

max_samples = 5000;
Y1 = Y1(1:min(max_samples, length(Y1)));
Y2 = Y2(1:min(max_samples, length(Y2)));

n = 10; 
nb = 10;

if all(isnan(Y1)) || length(Y1) < n || length(Y1) < nb
    disp('Lỗi: Dữ liệu G6 không hợp lệ.');
    num_G6 = 1;
    den_G6 = 1;
else
    disp('Computing G6 model');
    [num_G6, den_G6] = stmcb(Y1, nb, n);
end

[h1, t1] = impz(num_G6, den_G6, min(500, length(Y1)), fs_new_G6);
subplot(2,2,3);
plot(t1, h1, 'r'); 
title('Impulse Response G6'); 
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

if all(isnan(Y2)) || length(Y2) < n || length(Y2) < nb
    disp('Lỗi: Dữ liệu C8 không hợp lệ.');
    num_C8 = 1;
    den_C8 = 1;
else
    disp('Computing C8 model');
    [num_C8, den_C8] = stmcb(Y2, nb, n);
end

[h2, t2] = impz(num_C8, den_C8, min(500, length(Y2)), fs_new_C8);
subplot(2,2,4);
plot(t2, h2, 'g'); 
title('Impulse Response C8'); 
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

disp('Kết thúc mô phỏng');
