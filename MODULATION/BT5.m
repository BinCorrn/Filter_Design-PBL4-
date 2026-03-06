clc; clear; close all;
fa = 100; wa = 2*pi*fa;
fc = 2000; wc = 2*pi*fc; 
fs = 16*2048;
tiv = 1/fs; 
t = 0:tiv:(0.05-tiv); 

A = sin(wa*t);

gA = hilbert(A);

C = cos(wc*t);
gC = hilbert(C);

gSSB = gA .* gC;
y = real(gSSB);
subplot(2,1,1);
plot(t, A, 'k');
axis([0.01 0.04 -1.2 1.2]);
ylabel('a(t)');
title('SSB amplitude modulation with sine signal');

subplot(2,1,2);
plot(t, y, 'k');
axis([0.01 0.04 -1 1]);
xlabel('seconds'); ylabel('y(t)');
title('SSB Modulated Signal');
