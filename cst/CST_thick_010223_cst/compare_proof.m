close all
clear

%% Coefficient input
n = 8; %data volume
n_start = 18;%Minimum Antenna Sections
a1 = n_start - 1;%Simplify calling functions
num_antenna = n_start : n_start + n - 1;
L = zeros(n, 1);
fre_syntony_calculate = zeros(n, 1);
for i = n_start : n_start + n - 1
    [L(i - n_start + 1), fre_syntony_calculate(i - n_start + 1)] = TheoreticalValue(i);
end

%% Set the data matrix
Data_test = make_data_matrix(n_start, n, 'measurement\monopole2_', '', 1);
Data_cst_boundary = make_data_matrix(n_start, n, "boundary\", '', 0);

%% use function for test
[bandwidth_test, amplitude_syntony_test, fre_syntony_test] = ...
    ResonanceFunction(n, n_start, Data_test);
[bandwidth_cst, amplitude_syntony_cst, fre_syntony_cst_boundary] = ...
    ResonanceFunction(n, n_start, Data_cst_boundary);

%% plot
color = [
    0.1         0.7         0.9
    0.5000    0.2         0.6
        0.3    0.6    0.3
];

colormap(color);
% figure(2)
for i = 1 : 3
    y_min = min(Data_test(:, (3 * i - 1)));
    x_min = Data_test(find(Data_test(:, (3 * i - 1)) == y_min), 1);
    plot(Data_test(:, 1), Data_test(:, (3 * i - 1)), 'color', color(i, :), 'LineWidth', 2)
    h = line([x_min, x_min], [-40, y_min]);
    set(h, 'color', color(i, :), 'LineStyle', ':', 'LineWidth', 1);
    hold on 
    y_min = min(Data_cst_boundary(:, (3 * i - 1)));
    x_min = Data_cst_boundary(find(Data_cst_boundary(:, (3 * i - 1)) == y_min), 1);
    plot(Data_cst_boundary(:, 1), Data_cst_boundary(:, (3 * i - 1)), 'color', color(i, :), 'LineStyle', '--', 'LineWidth', 2)
    h = line([x_min, x_min], [-40, y_min]);
    set(h, 'color', color(i, :), 'LineStyle', '-.', 'LineWidth', 1);
    xlabel('frequency(Hz)');
    ylabel('S11(dB)');
    legend('Experiment', '','Simulation')
end

c = colorbar;
c.Ticks = [0, 0.33, 0.67, 1];
c.TickLabels = {L(1), L(2), L(3), L(4)}; % 设置标签
c.Label.String = 'antenna length';


