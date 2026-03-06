STT_sinh_vien = 29; % Thay thế bằng số thứ tự của sinh viên
noiseVariance = 0.15 * STT_sinh_vien; % Noise variance of AWGN channel
Rb = 1e3; % Tốc độ bit
amplitude = 1.5; % Biên độ

% Số lượng bit dữ liệu
N = 100; % Number of data bits

% Tạo dữ liệu ngẫu nhiên
data = randn(1, N) >= 0; % Generate uniformly distributed random data

% Mã hóa NRZ
[time, nrzData, Fs] = NRZ_Encoder(data, Rb, amplitude, 'Polar');
Tb = 1 / Rb;

% Vẽ tín hiệu dữ liệu nhị phân đầu vào
subplot(4, 2, 1);
stem(data);
xlabel('Samples');
ylabel('Amplitude');
title('Input Binary Data');
axis([0, N, -0.5, 1.5]);

% Vẽ tín hiệu NRZ đã mã hóa
subplot(4, 2, 3);
plotHandle = plot(time, nrzData);
xlabel('Time');
ylabel('Amplitude');
title('Polar NRZ encoded data');
set(plotHandle, 'LineWidth', 2.5);
maxTime = max(time);
maxAmp = max(nrzData);
minAmp = min(nrzData);
axis([0, maxTime, minAmp - 1, maxAmp + 1]);
grid on;

% Tạo sóng mang
Fc = 2 * Rb;
osc = sin(2 * pi * Fc * time);

% Điều chế BPSK
bpskModulated = nrzData .* osc;
subplot(4, 2, 5);
plot(time, bpskModulated);
xlabel('Time');
ylabel('Amplitude');
title('BPSK Modulated Data');
axis([0, maxTime, minAmp - 1, maxAmp + 1]);

% Vẽ phổ công suất của tín hiệu BPSK
subplot(4, 2, 7);
h = spectrum.welch; % Welch spectrum estimator
Hpsd = psd(h, bpskModulated, 'Fs', Fs);
plot(Hpsd);
title('PSD of BPSK modulated Data');

% Thêm nhiễu AWGN
noise = sqrt(noiseVariance) * randn(1, length(bpskModulated));
received = bpskModulated + noise;
subplot(4, 2, 2);
plot(time, received);
xlabel('Time');
ylabel('Amplitude');
title('BPSK Modulated Data with AWGN noise');

% Giải điều chế BPSK
v = received .* osc;
% Tích phân
integrationBase = 0:1/Fs:Tb-1/Fs;
y = zeros(1, length(v) / (Tb * Fs));
for i = 0:(length(v) / (Tb * Fs)) - 1
    y(i + 1) = trapz(integrationBase, v(int32(i * Tb * Fs + 1):int32((i + 1) * Tb * Fs)));
end
% So sánh ngưỡng
estimatedBits = (y >= 0);
subplot(4, 2, 4);
stem(estimatedBits);
xlabel('Samples');
ylabel('Amplitude');
title('Estimated Binary Data');
axis([0, N, -0.5, 1.5]);

% Tính tỷ lệ lỗi bit (BER)
BER = sum(xor(data, estimatedBits)) / length(data);
fprintf('Bit Error Rate (BER): %f\n', BER);

% Vẽ chòm sao BPSK tại phía phát
subplot(4, 2, 6);
Q = zeros(1, length(nrzData)); % No Quadrature Component for BPSK
stem(nrzData, Q);
xlabel('Inphase Component');
ylabel('Quadrature Phase component');
title('BPSK Constellation at Transmitter');

axis([-1.5, 1.5, -1, 1]);

% Vẽ chòm sao BPSK tại phía thu
subplot(4, 2, 8);
Q = zeros(1, length(y)); % No Quadrature Component for BPSK
stem(y / max(y), Q);
xlabel('Inphase Component');
ylabel('Quadrature Phase component');
title(['BPSK Constellation at Receiver when AWGN Noise Variance=', num2str(noiseVariance)]);
axis([-1.5, 1.5, -1, 1]);