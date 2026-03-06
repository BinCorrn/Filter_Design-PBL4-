X_Freq = [-1 1 1 -1 ];  % độ dài N, chỉ gồm giá trị thực
X_Time = ifft(X_Freq);
disp(X_Time)