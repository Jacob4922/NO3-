function [y5,e1,e2]=PLS(X,Y,x,y,p,q)

%% 偏最小二乘回归的通用程序

%  注释以“基于近红外光谱分析的汽油组分建模”为例，但本程序的适用范围绝不仅限于此

%  GreenSim团队原创作品（http://blog.sina.com.cn/greensim）

%% 输入参数列表

% X        校正集光谱矩阵，n×k的矩阵，n个样本，k个波长

% Y        校正集浓度矩阵，n×m的矩阵，n个样本，m个组分

% x        验证集光谱矩阵

% y        验证集浓度矩阵

% p        X的主成分的个数，最佳取值需由其它方法确定

% q        Y的主成分的个数，最佳取值需由其它方法确定

%% 输出参数列表

% y5       x对应的预测值（y为真实值）

% e1       预测绝对误差，定义为e1=y5-y

% e2       预测相对误差，定义为e2=|(y5-y)/y|

 

%% 第一步：对X,x,Y,y进行归一化处理

[n,k]=size(X);

m=size(Y,2);

Xx=[X;x];

Yy=[Y;y];

xmin=zeros(1,k);

xmax=zeros(1,k);

for j=1:k

    xmin(j)=min(Xx(:,j));

    xmax(j)=max(Xx(:,j));

    Xx(:,j)=(Xx(:,j)-xmin(j))/(xmax(j)-xmin(j));

end

ymin=zeros(1,m);

ymax=zeros(1,m);

for j=1:m

    ymin(j)=min(Yy(:,j));

    ymax(j)=max(Yy(:,j));

    Yy(:,j)=(Yy(:,j)-ymin(j))/(ymax(j)-ymin(j));

end

X1=Xx(1:n,:);

x1=Xx((n+1):end,:);

Y1=Yy(1:n,:);

y1=Yy((n+1):end,:);

 

%% 第二步：分别提取X1和Y1的p和q个主成分，并将X1,x1,Y1,y1映射到主成分空间

[CX,SX,LX]=princomp(X1);

[CY,SY,LY]=princomp(Y1);

CX=CX(:,1:p);

CY=CY(:,1:q);

X2=X1*CX;

Y2=Y1*CY;

x2=x1*CX;

y2=y1*CY;

 

%% 第三步：对X2和Y2进行线性回归

B=regress(Y2,X2,0.05);%第三个输入参数是显著水平，可以调整

 

%% 第四步：将x2带入模型得到预测值y3

y3=x2*B;

 

%% 第五步：将y3进行“反主成分变换”得到y4

y4=y3*pinv(CY);

 

%% 第六步：将y4反归一化得到y5

for j=1:m

    y5(:,j)=(ymax(j)-ymin(j))*y4(:,j)+ymin(j);

end

 

%% 第七步：计算误差

e1=y5-y;

e2=abs((y5-y)./y);

 

function [MD,ERROR,PRESS,SECV,SEC]=ExtraSim1(X,Y)

%% 基于PLS方法的进一步仿真分析

%% 功能一：计算MD值，以便于发现奇异样本

%% 功能二：计算各种p取值情况下的ERROR,PRESS,SECV,SEC值，以确定最佳输入变量个数

%  GreenSim团队原创作品（http://blog.sina.com.cn/greensim）

%%

[n,k]=size(X);

m=size(Y,2);

pmax=n-1;

q=m;

ERROR=zeros(1,pmax);

PRESS=zeros(1,pmax);

SECV=zeros(1,pmax);

SEC=zeros(1,pmax);

XX=X;

YY=Y;

N=size(XX,1);

for p=1:pmax

    disp(p);

    Err1=zeros(1,N);%绝对误差

    Err2=zeros(1,N);%相对误差

    for i=1:N

        disp(i);

        if i==1

            x=XX(1,:);

            y=YY(1,:);

            X=XX(2:N,:);

            Y=YY(2:N,:);

        elseif i==N

            x=XX(N,:);

            y=YY(N,:);

            X=XX(1:(N-1),:);

            Y=YY(1:(N-1),:);

        else

            x=XX(i,:);

            y=YY(i,:);

            X=[XX(1:(i-1),:);XX((i+1):N,:)];

            Y=[YY(1:(i-1),:);YY((i+1):N,:)];

        end

        [y5,e1,e2]=PLS(X,Y,x,y,p,q);

        Err1(i)=e1;

        Err2(i)=e2;

    end

    ERROR(p)=sum(Err2)/N;

    PRESS(p)=sum(Err1.^2);

    SECV(p)=sqrt(PRESS(p)/n);

    SEC(p)=sqrt(PRESS(p)/(n-p));

end

%%

[CX,SX,LX]=princomp(X);

S=SX(:,1:p);

MD=zeros(1,n);

for j=1:n

    s=S(j,:);

    MD(j)=(s')*(inv(S'*S))*(s);

end
