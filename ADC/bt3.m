[signal, Fs] = audioread('audio_sample.wav');
signal = signal(:,1);
t = (0:length(signal)-1)/Fs;

figure;
subplot(2,2,1);
plot(t, signal);
title('Tín hiệu Analog gốc');
xlabel('Time (s)');
ylabel('Amplitude');

Fs_digital = 1000;
Ts_digital = 1/Fs_digital;
t_digital = 0:Ts_digital:t(end);

subplot(2,2,2);
stem(t_digital, digital_signal, 'filled');
title('Tín hiệu Digital sau lấy mẫu');
xlabel('Time (s)');
ylabel('Amplitude');

Fc_low = 250;
[b_low, a_low] = butter(4, Fc_low/(Fs_digital/2), 'low');
digital_low = filter(b_low, a_low, digital_signal);

subplot(2,2,3);
plot(t_digital, digital_low);
title('Tín hiệu Digital sau lọc thông thấp (Fc = 500Hz)');
xlabel('Time (s)');
ylabel('Amplitude');

Fc_high = 500;  % Tần số cắt 1000 Hz
[b_high, a_high] = butter(4, Fc_high/(Fs/2), 'high');
analog_high = filter(b_high, a_high, signal);

subplot(2,2,4);
plot(t, analog_high);
title('Tín hiệu Analog sau lọc thông cao (Fc = 1000Hz)');
xlabel('Time (s)');
ylabel('Amplitude');

