%IEEE 802.11 OFDM
%----Simulation parameters --- nSym = 10^4
%Number of OFDM Symbols to transmit
clear; clc;
nSym = 2e4;
EbN0dB = -20:2:8;
N = 64;
Nsd = 48;
Nsp = 4;
ofdmBW = 4e6;   %OFDM BW
deltaF = ofdmBW/N;
Tfft = 1/deltaF;    %IFFT/FFT period
Tgi = Tfft/4;       %Guard interval duration - duration of cyclic prefix
Tsignal = Tgi + Tfft;   %duration of BPSK-OFDM symbol
Ncp = N*Tgi/Tfft;   %Number of symbols allocated to cyclic prefix
Nst = Nsd + Nsp;    %Number of total used subcarriers
nBitsPerSym = Nst;  %For BPSK the number of Bits per symbol is same as num of subcarries
EsN0dB = EbN0dB + 10*log10(Nst/N) + 10*log10(N/(Ncp+N));    %Converting to symbol to noise ratio
errors = zeros(1,length(EsN0dB));
theoreticalBER = zeros(1,length(EbN0dB));

%Monte Carlo Simunlation
for i = 1:length(EsN0dB)
    for j = 1:nSym
        s = 2*round(rand(1,Nst))-1;
        X_Freq = [zeros(1,1), s(1:Nst/2), zeros(1,11), s(Nst/2+1:end)];

        %Pretending the data to be in frequency domain and converting to time domain
        x_Time = N/sqrt(Nst)*ifft(X_Freq);
 
        %Adding Cyclic Prefix
        ofdm_signal = [x_Time(N-Ncp+1:N) x_Time];
        %--------Channel                    Modeling---------
        %AWGN CHANNEL
        noise = 1/sqrt(2)*(randn(1,length(ofdm_signal)) + 1i*randn(1,length(ofdm_signal)));
        r = sqrt((N+Ncp)/N)*ofdm_signal + 10^(-EsN0dB(i)/20)*noise;
        r_Parallel = r(Ncp+1:(N+Ncp));
        
        %FFTBlock
        r_Time = sqrt(Nst)/N*(fft(r_Parallel));
        R_Freq = r_Time([(2:Nst/2+1) (Nst/2+13:Nst+12)]);  
        R_Freq(R_Freq >0) = +1;
        R_Freq(R_Freq <0) = -1;
        s_cap = R_Freq;
        
        numErrors = sum(s_cap ~= s); %Count mumber of errors

        %Accumulate bit errors for all symbols transmitted
        errors(i) = errors(i) + numErrors;
        
    end

    theoreticalBER(i) = (1/2)*erfc(sqrt(10.^(EbN0dB(i)/10))); %Same as BER for BPSK over A

end
simulatedBER = errors/(nSym*Nst);
rmse = sqrt(mean((simulatedBER-theoreticalBER).^2));
disp(rmse);

plot(EbN0dB,log10(simulatedBER),'r-o');
hold on;
plot(EbN0dB,log10(theoreticalBER),'k*');
grid on;
title('BER Vs EbNodB for OFDM with BPSK modulation over AWGN');
xlabel('Eb/N0 (dB)');
ylabel('log10(BER)');
legend('simulated', 'theoretical');

