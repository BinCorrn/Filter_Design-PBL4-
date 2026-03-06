% A message via 4-PSK
% The pulses (bits):
a = [0 1 1 1 0 1 0 1 1 0 1 1 1 1 0 1];  % Modulating signal (bits)
Nb = length(a);  % Number of message bits
fc = 1000;  % Carrier frequency in Hz

% Number of samples per carrier cycle (also per bit-pair):
ns = 20;
fs = ns * fc;  % Sampling frequency in Hz
tiv = 1 / fs;  % Time interval between samples

% Time intervals set, 1 sine period (1 bit-pair):
t = 0: tiv: (1 / fc) - tiv;

% Time intervals set for the complete message:
tmsg = 0: tiv: (Nb / 2) * (1 / fc) - tiv;  % Adjusted for 16-bit message length

% Carrier signals for bit-pair time
c1 = sin(2 * pi * fc * t);   %00
c2 = sin((2 * pi * fc * t) + (pi / 2));%01
c3 = sin((2 * pi * fc * t) + pi);%10
c4 = sin((2 * pi * fc * t) + (3 * pi / 2));%11
figure;
% Adjust the signal 'as' for modulating signal
xx = Nb / (10 * fc);  % For vertical lines
us1 = ones(1, ns / 2);  % Vector of ns/2 ones
as = a(1) * us1;  % Start with first bit
for nn = 2: Nb
    as = cat(2, as, a(nn) * us1);
end

% Plot modulating signal:
subplot(2, 1, 1);
plot(tmsg, as, 'k'); hold on;
for nn = 1:8
    plot([nn * xx/1.6 nn * xx/1.6], [-0.2 1.2], ':b');
end
axis([0 Nb / (2 * fc) -0.2 1.2]);
ylabel('Message');
xlabel('Seconds');
title('4-PSK Modulation');
cs = c2;
cs = cat(2,cs,c4);
cs = cat(2,cs,c2);
cs = cat(2,cs,c2);
cs = cat(2,cs,c3);
cs = cat(2,cs,c4);
cs = cat(2,cs,c4);
cs = cat(2,cs,c2);
% Plot the 4-PSK signal
subplot(2, 1, 2);
plot(tmsg, cs, 'k'); hold on;
for nn = 1: 8
    plot([nn * xx/1.6 nn * xx/1.6], [-1.2 1.2], ':b');
end
axis([0 Nb / (2 * fc) -1.2 1.2]);
ylabel('4-PSK Signal');
xlabel('Seconds');