clc;
fa = 100; wa = 2*pi*fa;
fc = 2000; wc = 2*pi*fc;
fs = 16*2048;
MD = 0.5;
tiv = 1/fs; 

t = 0:tiv:0.032768-tiv;
 
a = sin(wa*t);

A = 2 + (MD * a);

y = A.*cos(wc*t);

subplot(3,1,1);
ffa = fft(a,fs);
sa = fftshift(real(ffa)); sa = sa/max(sa);
w1 = -fs/2:-1; w2 = 1:fs/2; w = [w1 w2];
plot(w,sa);
axis([-1500 1500 -1 1]);
xlabel('Hz'); title('A(w)');ylabel('magnitude');

subplot(3,1,2);
plot(t,y,'k');
axis([0 0.032768 -3 3]);
xlabel('seconds'); title('y(t)');ylabel('magnitude');

subplot(3,1,3);
ffy = fft(y,fs);
sy = fftshift(real(ffy)); sy =sy /max(sy);
plot(w,sy);
axis([-3000 3000 -1 1]);
xlabel('Hz'); title('Y(w)');ylabel('magnitude');