% fa = 150Hz,fc = 2000Hz, fs = 40kHz
% fa = 120Hz, fc = 2500Hz, fs = 45kHz 
fa = 150; wa = 2*pi*fa;
fc = 2000; wc = 2*pi*fc;
fs = 40000;
tiv = 1/fs;
t = 0:tiv:(0.045-tiv);
MD = 1;
A = MD*sin(wa*t);
y = A.*cos(wc*t);
plot(t,y,'k');
axis([0 0.04 -1.5 1.5]);
xlabel('second');
title('amplitude modulation of sine signal');