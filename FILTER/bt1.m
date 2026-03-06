num=942; 
den=[1 942]; %3.14x2x150 = 942
fs=150; 

[numd,dend] =bilinear(num, den,fs); 
f=logspace(-1,2); 
G=freqz(numd,dend, f,fs); 
AG=20*log10(abs(G));
Fl= angle(G); 

subplot(2,1,1); semilogx(f,AG,'k'); 
grid; axis([0.1 100 -35 5]);
ylabel('dB');
title('frequency response for the bilinear transformation fs=150Hz');

subplot(2,1,2); semilogx(f,Fl,'k'); 
grid,axis([0.1 100 -1.1 1.6]);
ylabel('rad.');
xlabel('Hz.');
