clear; clc;
Eb=1;
EbN0dBvector=0:3:9;
 
%Nf=10;Nc=16;T=10e-5;
Nf=10;
Nc=16;
T=10e-5;
f_delta=1/T;
t_step=T/Nc;
t_vector=0:t_step:(T-t_step);
Ns=length(t_vector);
 
for k=0:(Nc-1)
    k_th_subcarrier=1/sqrt(T) *exp(1j*2*pi*k*f_delta*t_vector);
    subcarrier_matrix(k+1,:)=k_th_subcarrier;
end

for snr_i=1:length(EbN0dBvector)
    EbN0dB=EbN0dBvector(snr_i);
    EbN0=10^(EbN0dB/10);
    N0=Eb/EbN0;
% kết thúc bôi đen
    vn=N0/(2*t_step);
    errcnt=0;
    bitcnt=0;
 
    while errcnt<100
        OFDM_frame=[];
        for m=1:Nf
            data_symbols_in_OFDMsymbol=sign(rand(1,Nc)-0.5)+1j*sign(rand(1,Nc)-0.5);
            data_symbols_in_OFDMframe(m,:)=data_symbols_in_OFDMsymbol;
            xt=zeros(1,Ns);
            % Bắt đầu bôi đen để tổng hợp OFDM symbol
            for k=0:(Nc-1)
                s_k=data_symbols_in_OFDMsymbol(k+1);
                xt=xt+s_k*subcarrier_matrix(k+1,:);
            end

            OFDM_frame=[OFDM_frame xt];
        end
 
        noise=sqrt(vn)*(randn(1,length(OFDM_frame))+1j*randn(1,length(OFDM_frame)));
        rt_frame=OFDM_frame+noise;
 
        for m=1:Nf
            mth_OFDMsymbol_in_rt=rt_frame((m-1)*Ns+(1:Ns));
            for k=0:(Nc-1)
                k_th_subcarrier=subcarrier_matrix(k+1,:);
                D=t_step*sum(mth_OFDMsymbol_in_rt.*conj(k_th_subcarrier));
                estimated_data_symbols_in_OFDMframe(m,k+1)=sign(real(D))+1j*sign(imag(D));
            end
        end
 
        Ierrs=sum(sum(real(data_symbols_in_OFDMframe)~=real(estimated_data_symbols_in_OFDMframe)));
        Qerrs=sum(sum(imag(data_symbols_in_OFDMframe)~=imag(estimated_data_symbols_in_OFDMframe)));
        errcnt=errcnt+(Ierrs+Qerrs);
        bitcnt=bitcnt+Nc*Nf*2;
    end
 
    BER1(snr_i)=errcnt/bitcnt;
    BERtheory1(snr_i)=0.5*erfc(sqrt(EbN0));
end
 
%Nf=20;Nc=32;T=0.0001;
Nf=20;
Nc=32;
T=0.0001;
f_delta=1/T;
t_step=T/Nc;
t_vector=0:t_step:(T-t_step);
Ns=length(t_vector);
subcarrier_matrix = [];
t_vector = 0:t_step:(T - t_step); 

for k=0:(Nc-1)
    k_th_subcarrier=1/sqrt(T) *exp(1j*2*pi*k*f_delta*t_vector);
    subcarrier_matrix(k+1,:)=k_th_subcarrier;
end
 
for snr_i=1:length(EbN0dBvector)
    EbN0dB=EbN0dBvector(snr_i);
    EbN0=10^(EbN0dB/10);
    N0=Eb/EbN0;
    vn=N0/(2*t_step);
    errcnt=0;
    bitcnt=0;
 
    while errcnt<100
        data_symbols_in_OFDMframe = zeros(Nf, Nc);  
        OFDM_frame=[];
        for m=1:Nf
            data_symbols_in_OFDMsymbol=sign(rand(1,Nc)-0.5)+1j*sign(rand(1,Nc)-0.5);
            data_symbols_in_OFDMframe(m,:)=data_symbols_in_OFDMsymbol;
            xt=zeros(1,Ns);
            % Bắt đầu bôi đen để tổng hợp OFDM symbol
            for k=0:(Nc-1)
                s_k=data_symbols_in_OFDMsymbol(k+1);
                xt=xt+s_k*subcarrier_matrix(k+1,:);
            end
            % Kết thúc bôi đen
            OFDM_frame=[OFDM_frame xt];
        end
 
        noise=sqrt(vn)*(randn(1,length(OFDM_frame))+1j*randn(1,length(OFDM_frame)));
        rt_frame=OFDM_frame+noise;
 
        for m=1:Nf
            mth_OFDMsymbol_in_rt=rt_frame((m-1)*Ns+(1:Ns));
            for k=0:(Nc-1)
                k_th_subcarrier=subcarrier_matrix(k+1,:);
                D=t_step*sum(mth_OFDMsymbol_in_rt.*conj(k_th_subcarrier));
                estimated_data_symbols_in_OFDMframe(m,k+1)=sign(real(D))+1j*sign(imag(D));
            end
        end
 
        Ierrs=sum(sum(real(data_symbols_in_OFDMframe)~=real(estimated_data_symbols_in_OFDMframe)));
        Qerrs=sum(sum(imag(data_symbols_in_OFDMframe)~=imag(estimated_data_symbols_in_OFDMframe)));
        errcnt=errcnt+(Ierrs+Qerrs);
        bitcnt=bitcnt+Nc*Nf*2;
    end
 
    BER2(snr_i)=errcnt/bitcnt;
    BERtheory2(snr_i)=0.5*erfc(sqrt(EbN0));
end

%đồ thị
figure
semilogy(EbN0dBvector, BER1, 'b'); hold on;
semilogy(EbN0dBvector, BERtheory1, 'y');
semilogy(EbN0dBvector, BER2, 'r');
semilogy(EbN0dBvector, BERtheory2, 'g');
grid on;
legend('Simulated OFDM (Nf=10, Nc=16)', 'Theoretical BPSK', ...
       'Simulated OFDM (Nf=20, Nc=32)', 'Theoretical BPSK');
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate');
title('BER performance comparison of two OFDM configurations');
