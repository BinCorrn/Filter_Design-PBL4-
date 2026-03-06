fa = 70;    wa = 2*pi*fa;
fc = 1500;  wc = 2*pi*fc;
fs = 40000; tiv = 1/fs;
t = 0:tiv:(0.1-tiv);
beta = 20;
y = cos((wc*t) + (beta*sin(wa*t)));
plot(t,y,'k'); axis([0.05 0.1 -1.5 1.5]);
xlabel('second'); title('frequency modulation of sine signal');