% Tham số
Fs = 1000;              % Tần số lấy mẫu (Hz)
T = 1/Fs;               % Chu kỳ lấy mẫu
t = 0:T:1-T;            % Thời gian 1 giây
N = length(t);          % Số mẫu

% Tín hiệu gồm 50 Hz (tín hiệu) và 400 Hz (nhiễu)
x = sin(2*pi*50*t) + 0.5*sin(2*pi*400*t);

% FFT
X = fft(x);             
X_mag = abs(X)/N;       % Biên độ chuẩn hóa
f = (0:N-1)*(Fs/N);     % Trục tần số

% Vẽ phổ biên độ
figure;
plot(f(1:N/2), 2*X_mag(1:N/2)); grid on;
xlabel('Tần số (Hz)');
ylabel('|X(f)|');
title('Phân tích phổ tín hiệu bằng FFT');
