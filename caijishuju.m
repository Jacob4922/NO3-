%%数据提取
close all; clear; clc;
data_1 = xlsread('Cary5000_KNO3_1.0.xlsx');
[data_1row, data_1col] = size(data_1);
data_x = data_1(:,1);                   %紫外波段的波长范围（横坐标）
data_y = data_1(:,2 : 2 :data_1col);    %吸光度的大小（纵坐标）

%%SG平滑
y = sgolayfilt(data_y,2,5);

%%画图
figure;
for i=1:11
    plot(data_x,data_y(:,i));
    plot(data_x,y(:,i));
    hold on;
end
title('硝酸盐uv吸收光谱图（1cm比色皿）');    xlabel('波长/nm Wavelength');    ylabel('吸光度 absorbance');
xlim([200 400]); ylim([-0.1 5]);    %x，y轴的坐标范围
legend('0mg/L','0.02mg/L','0.05mg/L','0.1mg/L','0.3mg/L','0.5mg/L','0.7mg/L','1mg/L','3mg/L','5mg/L','7mg/L');	% 添加图例