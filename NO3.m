%% 1.清空环境变量
close all;
clear;
clc;

%% 2.训练集/测试集产生
% 1.导入数据
load shujuji.mat

%%
% 2. 随机产生训练集和测试集，因为是随机产生，所以每次执行的结果会不同
huafen = randperm(size(xiguangdu,2));%xiguangdu所有列数
% 训练集——9个样本
P_train = xiguangdu(:,huafen(1:9));
T_train = nongdu(huafen(1:9),:)';
% 测试集——2个样本
P_test = xiguangdu(:,huafen(9:end));
T_test = nongdu(huafen(9:end),:)';
N = size(P_test,2);

%% 3.SG平滑
PSG_train = sgolayfilt(P_train,2,5);
PSG_test = sgolayfilt(P_test,2,5);

%% 4.数据归一化
[P1_train, ps_input] = mapminmax(PSG_train,0,1);
P1_test = mapminmax('apply',PSG_test,ps_input);

[t_train, ps_output] = mapminmax(T_train,0,1);
t_test = mapminmax('apply',T_test,ps_output);

%% 5.偏最小二乘法PLS
 