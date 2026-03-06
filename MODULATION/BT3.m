%Giai dieu che
%fa = 100Hz, fc = 2000Hz, fs = 16*2048, A = 2+(MD*a), MD = 0.5
%Tao t/h dieu che
fa = 100; wa = 2*pi*fa;
fc = 2000; wc = 2*pi*fc;
fs = 16*2048;
tiv = 1/fs;
t = 0:tiv:(0.032768-tiv);
MD = 0.5;
A = 2 + (MD*sin(wa*t));
y = A.*(cos(wc*t));
a = sin(wa*t);
%Doan duoi nay giai dieu che
N = length(t); d1 = zeros(1,N);
for tt = 1:N
    if y(tt) < 0
        d1(tt) = 0;
    else
        d1(tt) = y(tt);
    end
end

%Loc RC
R = 2000; C = 8e-7;
fil = tf( R , [R*C 1]);
d2 = lsim(fil,d1,t);
subplot(2,1,1);
plot(t,d1,'k');
xlabel('seconds');
title('rectified modulated signal');
subplot(2,1,2);
plot(t,d2,'k');
xlabel('seconds'); title('demodulated signal');