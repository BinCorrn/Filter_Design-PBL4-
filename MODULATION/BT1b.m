% fa = 150Hz,fc = 2000Hz, fs = 40kHz
% fa = 120Hz, fc = 2500Hz, fs = 45kHz 
fa = 120; wa = 2*pi*fa;
fc = 2500; wc = 2*pi*fc;
fs = 45000;
tiv = 1/fs;
t = 0:tiv:(0.045-tiv);
MD = 1;
A = MD*cos(wa*t);
y = A.*cos(wc*t);
plot(t,y,'k');
axis([0 0.045 -1.5 1.5]);
xlabel('second');
title('amplitude modulation of sine signal');