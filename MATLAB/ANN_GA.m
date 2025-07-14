%clear all��������ռ�����б���
clear all
%��close all�����е�Figure���� 
close all
%clc�������ڵ����ݣ��Թ��������е�ȫ���������κ�Ӱ�� 
clc
%�����Ա����������������
warning off
rng(1)
%% Data
data=CreateData();
%% ANN-GA
% Create a Fitting Network
prompt = {'���������ز������'};
dlgtitle = 'ANN-GA�㷨��������';
dims = [1 50];
definput = {'20'};
answer1 = inputdlg(prompt,dlgtitle,dims,definput);
answer1=str2double(answer1);
hiddenLayerSize = answer1(1);
% create a neural network
net = feedforwardnet(hiddenLayerSize);
net = configure(net, data.Inputs, data.Targets);
NotOPT_variable=getwb(net);
%% Train Hybrid ANN-GA
[outjadid, out,maxValue,optcon]=TrainAnnGA(net,data);
pre=outjadid;
exp=data.Targets;
m=numel(pre);
r= corrcoef(pre,exp);
R=r(2,1)^2;
error = exp - pre;
MSE=mean(error(:).^2);
RMSE=sqrt(MSE);
sprintf('R square:%f',R)
sprintf('MSE:%f',MSE)
sprintf('RMES:%f',RMSE)
sprintf('Optimum conditions:A:%f��B:%f��C:%f,',optcon(1),optcon(2),optcon(3))
sprintf('Optimum Sulfate reduction rate:%f',maxValue)
figure
hold on
plot(1:m,exp,'bs',...
    'LineWidth',1,...
    'MarkerSize',6,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','b')
plot(1:m,pre,'-or','LineWidth',1)
legend('Experimental','ANN-GA predicted');
xlabel('Run No');
ylabel('Sulfate reduction rate(%)');
grid off
set(gca,'fontname','Times new roman','FontSize', 10);  % Set fontname
set(gca,'ytick',[0 20 40 60 80 100])
box on
set(gcf,'color','white')

figure
plot(exp,pre,'or','LineWidth',2)
hold on
plot([min(exp),max(exp)],[min(exp),max(exp)],'--k','LineWidth',2)
xlabel('Experimental value');
ylabel('Model predicted value');
grid off
set(gca,'fontname','Times new roman','FontSize', 10);  % Set fontname
set(gca, 'xtick',[0 20 40 60 80 100],'ytick',[0 20 40 60 80 100])
hold on
set(gcf,'color','white')
OPT_variable=getwb(net);