clear
close all
se = 25 : 1 : 35;
me = 40 : 2 : 60;
st = 0.0005 : 0.0005 : 0.003;
at = 0.036 : 0.01 : 0.071;
shape_point = ['o', 'x', '^', 's', 'p', 'h'];
shape_labels = {'se = 25', 'se = 27', 'se = 29', 'se = 31', 'se = 33', 'se = 35'};

colorValues = 0.1 : 0.1 : 1; % 颜色数值

for j = 1 : length(at)
    figure(j)
    arm_thickness = at(j);
    [t_delay, E_amplitude] = cal_arm_thickness(arm_thickness, se, me, st);
    for k = 1 : length(se)
            for h = 1 : length(st)
                y_point = reshape(t_delay(k, h, :), [], 1);
                x_point = reshape(E_amplitude(k, h, :), [], 1);
                scatter(x_point, y_point, 30, me, 'o', 'filled')
                hold on
            end
    end
    xlabel('Amplitude')
    ylabel('TOA')
    title('arm thickness =', at(j))
    colorbar;
end