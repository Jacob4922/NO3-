 %% 1. 清空环境变量
close all;
clear;
clc;
%% 2. 训练集/测试集产生
%%
% 1.导入数据
load shujuji.mat

%%
% 2. 随机产生训练集和测试集，因为是随机产生，所以每次执行的结果会不同
temp = randperm(size(xiguangdu,2));%nongdu所有行数
% 训练集——8个样本
P_train = xiguangdu(:,temp(1:8));
T_train = nongdu(temp(1:8),:)';
% 测试集——3个样本
P_test = xiguangdu(:,temp(8:end));
T_test = nongdu(temp(8:end),:)';
N = size(P_test,2);

%% 3. 数据归一化
[p_train, ps_input] = mapminmax(P_train,0,1);
p_test = mapminmax('apply',P_test,ps_input);

[t_train, ps_output] = mapminmax(T_train,0,1);
t_test = mapminmax('apply',T_test,ps_output);

%% 4. BP神经网络创建、训练及仿真测试
%%
% 1. 创建网络
net = newff(p_train,t_train,9);

%%
% 2. 设置训练参数
net.trainParam.epochs = 1000;  %迭代次数
net.trainParam.goal = 1e-3;    %训练目标，误差范围
net.trainParam.lr = 0.01;      %学习率

%%
% 3. 训练网络
net = train(net,p_train,t_train);

%%
% 4. 仿真测试
t_sim = sim(net,p_test);

%%
% 5. 数据反归一化
T_sim = mapminmax('reverse',t_sim,ps_output);

%% V. 性能评价
%%
% 1. 相对误差error
error = abs(T_sim - T_test)./T_test;
%%
% 2. 决定系数R^2
R2 = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 

%%
% 3. 结果对比
result = [T_test' T_sim' error']

%% VI. 绘图
figure
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o')
legend('真实值','预测值')
xlabel('预测样本')
ylabel('硝酸盐值')
string = {'测试集硝酸盐值含量预测结果对比';['R^2=' num2str(R2)]}; %越接近1，效果越好
title(string)

