clc;
clear;
close all; % closes all open figures

figure(1)

x = linspace(0,2*pi);
a1 = plot(x, cos(x), 'black', 'LineWidth', 2);
hold on
a2 = plot(x, sin(x),'--green', 'LineWidth',3);

if abs(a1(x)-a2(x)) < 0.05
    plot(a1,a2)
end

title('sin(x) and cos(x) plot');
xlabel('x axis');
ylabel('y axis');
legend([a1 a2],'y1 = sin(x)', 'y2 = cos(x)', '1st intersect point', '2nd intersect point')