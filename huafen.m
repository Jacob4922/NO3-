%% 2.训练集、测试集产生
% 1）导入数据，NIR输入数据，ocrance输出数据
%load spectra_data.mat;
NIR=xlsread('shujuji.xlsx'); octane=xlsread('shujuji_bendi.xlsx');
%% P代表输入数据，T代表输出数据
% 2）随机产生训练集和测试集
% size(a,1)表示显示矩阵的行数，size（a,2)现实矩阵列数,是一个数字！
temp = randperm(size(NIR,1)); %randperm生成一个数列但是是乱序排列
%训练集----50个样本
%这里进行了转置，让列数代表样本数，行数代表每一组样本里的变量数
P_train = NIR(temp(1:7),:)';
T_train = octane(temp(1:7),:)'; %temp(1:50)是取出temp的前五十个数 (temp(1:50)),:)
%是取出前五十行的所有列
P_test = NIR(temp(8:end),:)';
T_test = octane(temp(8:end),:)';
N = size(P_test,2);