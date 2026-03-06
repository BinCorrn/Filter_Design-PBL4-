%spectra of frequency modulated signals
%frequency modulation of sine signal
fa = 100;    wa = 2*pi*fa;
fc = 1800;  wc = 2*pi*fc;
fs = 35000; tiv = 1/fs;
t = 0:tiv:(0.1-tiv);
%vector of frequencies for spectra:
w1 = -fs/2:-1; w2 = 1:fs/2; w = [w1 w2];
subplot(3,1,1);
beta = 1;
y = cos((wc*t/2) + (beta*sin(wa*2*t)));
ffy = fft(y,fs);
sy = fftshift(real(ffy)); sy = sy/max(sy);
plot(w,sy);
axis([-3000 3000 -1 1]);
ylabel('beta = 1'); title('Y(w)');
subplot(3,1,2);
beta = 5;
y = cos((wc*t/2) + (beta*sin(wa*2*t)));
ffy = fft(y,fs);
sy = fftshift(real(ffy)); sy = sy/max(sy);
plot(w,sy);
axis([-3000 3000 -1 1]);
ylabel('beta = 5'); title('Y(w)');
subplot(3,1,3);
beta = 10;
y = cos((wc*t/2) + (beta*sin(wa*2*t)));
ffy = fft(y,fs);
sy = fftshift(real(ffy)); sy = sy/max(sy);
plot(w,sy);
axis([-3000 3000 -1 1]);
ylabel('beta = 10'); title('Y(w)');
