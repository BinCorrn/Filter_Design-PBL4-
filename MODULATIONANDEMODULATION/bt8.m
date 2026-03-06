% Demodulation of pulses
% The modulating signal is a sine
% The modulating frequency in Hz
fa = 60; % signal frequency in Hz
wa = 2 * pi * fa; % signal frequency in rad/s
nsc = 16; % number of samples per signal period
fs = nsc * fa; % sampling frequency in Hz
tiv = 1 / fs; % time interval between samples
% Time intervals set (0.03 seconds):
t = 0:tiv:(0.05 - tiv);
% Sampling the modulating signal
a = 0.5 + 0.3 * sin(wa * t);
subplot(2,1,1);
plot(t, a, 'k');
ylabel('modulating sine');
title('demodulation of pulses');
axis([0 0.025 -0.2 1.2]);

% PWM modulation
[PWMy, ty] = modulate(a, fa, fs, 'pwm', 'centered');

% PWM demodulation
PWMa = demod(PWMy, fa, fs, 'pwm', 'centered');
subplot(2,1,2);
plot(t, PWMa, 'k');
axis([0 0.025 -0.2 1.2]);
ylabel('PWM');
