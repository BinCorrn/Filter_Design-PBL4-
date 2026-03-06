clc; clear;

% Thông số mong muốn
% Rp = 0.3 dB
% As = 50 dB
% Thông số thiết kế
wp = 0.5*pi;
ws = 0.8*pi;

% Tính độ rộng vùng chuyển tiếp
tr_width = ws - wp;

M = ceil(6.6*pi / tr_width) + 1;  

% Trục thời gian
n = 0:M-1;
alpha = (M - 1)/2;

% Tính đáp ứng xung lý tưởng hd[n] cho bộ lọc thông thấp
wc = (ws + wp)/2;  % tần số cắt giữa wp và ws
m = n - alpha + eps;
hd = sin(wc * m) ./ (pi * m);  % sinc

% Áp dụng cửa sổ Hamming
w_ham = hamming(M)';
h = hd .* w_ham;

% Tính đáp ứng tần số
[H, w] = freqz(h, 1, 1000, 'whole');  % đáp ứng tần số 0 → 2pi
H = H(1:501);          % lấy nửa phổ 0 → pi
w = w(1:501);          % tương ứng

% Biến phân tích
mag = abs(H);
db = 20*log10((mag + eps)/max(mag));  % dB
pha = unwrap(angle(H));
grd = grpdelay(h, 1, w);

% Vẽ các đồ thị
subplot(2,2,1); 
stem(n, hd); 
title('Ideal Impulse Response'); 
xlabel('n'); 
ylabel('hd(n)'); 
subplot(2,2,2); 
stem(n, w_ham); 
title('Hamming Window'); 
xlabel('n'); 
ylabel('w(n)'); 
subplot(2,2,3); 
stem(n, h); 
title('Actual Impulse Response'); 
xlabel('n'); 
ylabel('h(n)'); 
subplot(2,2,4); 
plot(w/pi, db); 
title('Magnitude Response in dB'); 
grid; 
axis([0 1 -100 10]); 
xlabel('\omega in \pi units'); 
ylabel('Decibels');

