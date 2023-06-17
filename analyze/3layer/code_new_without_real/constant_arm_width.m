close all
clear
%% 信号
freq = 5e8:4e6:4e9;
fs = 2 * max(freq); 
dert_f = freq(2) - freq(1);
t_length = fs ./ dert_f; 
t = (0 : t_length + 1) * (1 ./ fs); 
y = exp(-(t - 3.5e-8).^2/(2 * 2e-9^2));

%% 设定变量
n_freq = length(freq);
[s_eps, m_eps, s_thi, m_thi] = RefreshParameters();
se = 25 : 2 : 35;
me = 40 : 5 : 60;
st = 0.005 : 0.007 : 0.03;
mt = 0.03 : 0.01 : 0.07;
parameter_change = 3;
parameter_name = ['s_eps'; 'm_eps'; 's_thi'; 'm_thi'];
parameter_value = ['se'; 'me'; 'st'; 'mt'];
sig = y .* sin(2 * pi * 2e9 * t);
SIG = merit.process.td2fd(sig', t, freq);
% plot(t, sig)
% xlabel('Time')
% ylabel('Amplitude')

%% 计算
n_parameter = length(eval(parameter_value(parameter_change, :)));
for j = 1 : n_parameter
    for i = 1 : n_freq
        eval([parameter_name(parameter_change,:) ...
            ' = eval([(parameter_value(parameter_change,:))+"(j)"]);']);
        if parameter_change == 3
            m_thi = 0.052 - s_thi;
        elseif parameter_change == 4
            s_thi = 0.052 - m_thi;
        else
        end
            E_output(i, j) = Transmission3layer(freq(i), 1, s_eps, m_eps, ...
                s_thi, m_thi);
    end
    E_out_f(:, j) = SIG .* E_output(:, j);
    E_result(:, j) = 2 * merit.process.fd2td(E_output(:, j), freq, t);
    E_out_t(:, j) = 2 * merit.process.fd2td(E_out_f(:, j), freq, t);
    y = envelope(E_out_t(:, j));
    t_delay(j) = t(find(y == max(y))) - t(find(sig == max(sig)));
end

E_amplitude = mag2db(abs(E_out_f));
E_phase = (180 / pi) * unwrap(angle(E_out_f));
% E_phase = (180 / pi) * angle(real(E_output) * 1j + imag(E_output));


%% 图表设定
n = n_parameter;
color = zeros(n, 3);
for i = 1 : n
    color(i, :)=[i/n (n - i)/n (n - i)/n];
end

switch parameter_change
    case 1
        name = 'Different skin Permittivity';
    case 2
        name = 'Different muscle Permittivity';
    case 3
        name = 'Different skin thickness';
    otherwise
        name = 'Different muscle thickness';
end

legend_labels = cell(1, n_parameter); 
for i = 1 : n_parameter
    mt = eval(parameter_value(parameter_change, :));
    legend_labels{i} = mat2str(mt(i));
end

%% 绘图
figure(1)
for i = 1 : n_parameter
    plot(t, E_result(:, i), 'Color', color(i, :))
    hold on
end
xlabel("Time");
ylabel("Amplitude");
title(strcat("Pulse signal with ", name));
legend(legend_labels);


figure(2)
for i = 1 : n_parameter
    plot(t, E_out_t(:, i), 'Color', color(i, :))
    hold on
end
xlabel("Time");
ylabel("Amplitude");
legend(legend_labels);
title(strcat("Modulated Gaussian pulse with ", name));

figure(3)
for i = 1 : n_parameter
    plot(freq, E_amplitude(:, i), 'Color', color(i, :))
    hold on
end
xlabel("Frequence");
ylabel("dB");
legend(legend_labels);
title(name);


figure(4)
for i = 1 : n_parameter
    plot(freq, E_phase(:, i), 'Color', color(i, :))
    hold on
end
xlabel("Frequence");
ylabel("Angle");
legend(legend_labels);
title(name);


figure(5)
plot(eval(parameter_value(parameter_change, :)), t_delay)
title(name);
xlabel(parameter_value(parameter_change, :));
ylabel("Time");