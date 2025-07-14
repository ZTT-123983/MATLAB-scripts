function [outjadid, net,maxValue,optcon]=TrainAnnGA(net,data)

%% Problem Definition
ad=getwb(net);
Problem.CostFunction=@(x) TrainAnnCost(x,net,data);
Problem.nVar=numel(ad);
alpha=1;
Problem.VarMin=-(10^alpha);
Problem.VarMax=10^alpha;
%% GA Params
prompt = {'请输入ANN-GA算法的最大迭代次数:','请输入ANN-GA算法的种群数量:'};
dlgtitle = 'ANN-GA算法参数设置';
dims = [1 50];
definput = {'100','200'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
answer=str2double(answer);
Params.MaxIt=answer(1);      % Maximum Number of Iterations
Params.nPop=answer(2);        % Population Size
%% Run GA
results=GAR(Problem,Params);
%% Get Results
wb=results.BestSol;
x=data.Inputs;
t=data.Targets;
net = setwb(net, wb);
outjadid= net(x);
%% Max Results
x1=x(1,:);
x2=x(2,:);
x3=x(3,:);
xx = linspace(7, 9, 10000);
yy = linspace(min(x2), 35, 10000);
zz = linspace(min(x3), 0.05, 10000);
xx1 = xx(randperm(length(xx)));
yy1 = yy(randperm(length(yy)));
zz1 = zz(randperm(length(zz)));
X=[xx1;yy1;zz1];
outjadid1= net(X);
[maxValue, maxIndex] = max(outjadid1(outjadid1<100));
optcon=X(:,maxIndex);

%% Test
TESTHybrid(x,t,net,outjadid);
end