%% Coefficient input
n = 4;
n_start = 3;
a1 = n_start - 1;

%% set empty matrix
fre_syntony_test = zeros(n, 1);
fre_syntony_calculate = zeros(n, 1);
amplitude_syntony_test = zeros(n, 1);
bandwidth = zeros(n, 1);
num_antenna = n_start : n_start + n - 1;
color = zeros(n, 3);
phase = zeros(n, 1);
freq_10dB_point = zeros(n, 2);
L = zeros(n, 1);

%% Set the data matrix
file_start = strcat ('monopole1_',int2str(n_start), 'l1s');
A = readmatrix(file_start);
fre_data = zeros(length(A), 2 * n + 1);
amplitude = zeros(length(A), n);
fre_data(:, 1) = A(:, 1);
x = fre_data(:, 1);

%% use function
for i = n_start : a1 + n
    file_name = strcat ('monopole1_',int2str(i), 'l1s');
    A = readmatrix(file_name);
    fre_data(:, [2 * i - a1 * 2, 2 * i - a1 * 2 + 1]) = A(:, [2, 3]);
    [L(i - a1), amplitude(:, i - a1), amplitude_syntony_test(i - a1),...
       fre_syntony_test(i - a1), fre_syntony_calculate(i - a1)] = ...
       thin(i, fre_data(:, [1, (i - a1) * 2, (i - a1) * 2 + 1]));
end

%% color settings
for i = 1 : n
    color(i,:)=[i/n 1 0];
end

%% Image display
figure (1)
for i=1:n
    plot(fre_data(:, 1), amplitude(:, i), 'color', color(i,:));
    hold on
end
legend('3', '4', '5', '6');
xlabel('frequency');
ylabel('dB');
title("Attenuation amplitude(dB) of different numbers antennas nodes");

figure (2)
plot(L, fre_syntony_calculate,'ro-', 'MarkerFaceColor','r');
xlabel('The length of the antenna');
ylabel('frequency');
hold on
plot(L, fre_syntony_test, 'go-', 'MarkerFaceColor', 'g');
legend('Expected resonant frequency', 'Measured resonance frequency');
title("Comparison of expected and actual resonant frequency")

figure (3)
plot(L, amplitude_syntony_test);
xlabel('The length of the antenna');
ylabel('syntony amplitude(dB)');
title("The attenuation amplitude when resonates")

% figure (4)
% plot(num_antenna, bandwidth);
% xlabel('The number of nodes of the antenna');
% ylabel('bandwidth');
% title("10dB Bandwidth of Different Antennas")