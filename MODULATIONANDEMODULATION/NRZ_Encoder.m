function [time,output,Fs] = NRZ_Encoder(input, Rb, amplitude, style)
    % Thiết lập các thông số
    Fs = 16 * Rb;               % Tần số lấy mẫu
    oversampling_factor = 32;   % (Nếu cần dùng sau)
    Ts = 1 / Fs;                % Chu kỳ lấy mẫu
    Tb = 1 / Rb;                % Chu kỳ bit

    output = [];

    % Kiểm tra kiểu mã hóa
    switch lower(style)
        case {'manchester'}
            for count = 1:length(input)
                % Nửa đầu bit
                for tempTime = 0:Ts:(Tb/2 - Ts)
                    output = [output (-1)^( input(count) ) * amplitude];
                end
                % Nửa sau bit
                for tempTime = (Tb/2):Ts:(Tb - Ts)
                    output = [output (-1)^( input(count) + 1 ) * amplitude];
                end
            end

        case {'unipolar'}
            for count = 1:length(input)
                for tempTime = 0:Ts:(Tb - Ts)
                    output = [output input(count) * amplitude];
                end
            end

        case {'polar'}
            for count = 1:length(input)
                for tempTime = 0:Ts:(Tb - Ts)
                    % Nếu input(count) = 0 => (-1)^(1+0) = -1
                    % Nếu input(count) = 1 => (-1)^(1+1) = +1
                    output = [output amplitude * (-1)^(1 + input(count))];
                end
            end

        otherwise
            disp('NRZ_Encoder(input,Rb,amplitude,style) - Unknown method given as "style" argument');
            disp('Accepted Styles are "Manchester", "Unipolar" and "Polar"');
    end

    % Xây dựng vector thời gian tương ứng
    time = 0:Ts:(Tb * length(input) - Ts);

end
