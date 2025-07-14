function TESTHybrid(x,t,net,outjadid)

% Choose Input and Output Pre/Post-Processing Functions
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};
% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainFcn = 'trainlm';  % Levenberg-Marquardt
% Choose a Performance Function
net.performFcn = 'mse';  % Mean squared error
% Choose Plot Functions
net.trainParam.showWindow=false;
net.trainParam.showCommandLine=false;
net.trainParam.show=1;
net.trainParam.epochs=100;
net.trainParam.goal=1e-8;
net.trainParam.max_fail=20;

%% Start
inputs=x;
targets=t;
% Train the Network
[net,tr] = train(net,inputs,targets);
% Test the Network
outputs = outjadid;
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

%% Recalculate Training Performance

trainInd=tr.trainInd;
trainInputs = inputs(:,trainInd);
trainTargets = targets(:,trainInd);
trainOutputs = outputs(:,trainInd);
trainErrors = trainTargets-trainOutputs;
trainPerformance = perform(net,trainTargets,trainOutputs);

%% Recalculate Validation Performance

valInd=tr.valInd;
valInputs = inputs(:,valInd);
valTargets = targets(:,valInd);
valOutputs = outputs(:,valInd);
valErrors = valTargets-valOutputs;
valPerformance = perform(net,valTargets,valOutputs);

%% Recalculate Test Performance

testInd=tr.testInd;
testInputs = inputs(:,testInd);
testTargets = targets(:,testInd);
testOutputs = outputs(:,testInd);
testError = testTargets-testOutputs;
testPerformance = perform(net,testTargets,testOutputs);

target_all = targets;
output_all = outjadid;

target_train = targets(:, trainInd);
output_train = outjadid(:, trainInd);

target_val = targets(:, valInd);
output_val = outjadid(:, valInd);

target_test = targets(:, testInd);
output_test = outjadid(:, testInd);
figure;
set(gcf,'color','white');

% 绘制训练集回归
subplot(2,2,1);
scatter(target_train, output_train, 40, 'o', 'MarkerEdgeColor','k');
hold on;
p_train = polyfit(target_train, output_train, 1);
yfit_train = polyval(p_train, target_train);
plot(target_train, yfit_train, 'b-', 'LineWidth', 2);
plot([min(target_train), max(target_train)], [min(output_train), max(output_train)], 'k--');
R_train = corrcoef(target_train, output_train);
text(min(target_train), max(output_train), sprintf('Training: R=%.5f', R_train(2,1)), 'FontSize',10,'FontWeight','bold');
eqn_train = sprintf('%.2f目标%+.4f', p_train(1), p_train(2));
ylabel(['输出~ = ' eqn_train]);
xlabel('Target');
legend('Data','Fit','Y=T','Location','best');
R_train = corrcoef(target_train, output_train);
title(['Training: R=' num2str(R_train(2,1),'%.5f')]);
box on
% 绘制验证集回归
subplot(2,2,2);
scatter(target_val, output_val, 40, 'o', 'MarkerEdgeColor','k');
hold on;
p_val = polyfit(target_val, output_val, 1);
yfit_val = polyval(p_val, target_val);
plot(target_val, yfit_val, 'g-', 'LineWidth', 2);
plot([min(target_val), max(target_val)], [min(output_val), max(output_val)], 'k--');
R_val = corrcoef(target_val, output_val);
text(min(target_val), max(output_val), sprintf('Validation: R=%.5f', R_val(2,1)), 'FontSize',10,'FontWeight','bold');
eqn_val = sprintf('%.2fTarget%+.4f', p_val(1), p_val(2));
ylabel(['输出~ = ' eqn_val]);
xlabel('Target');
legend('Data','Fit','Y=T','Location','best');
R_val = corrcoef(target_val, output_val);
title(['Validation: R=' num2str(R_val(2,1),'%.5f')]);
box on
% 绘制测试集回归
subplot(2,2,3);
scatter(target_test, output_test, 40, 'o', 'MarkerEdgeColor','k');
hold on;
p_test = polyfit(target_test, output_test, 1);
yfit_test = polyval(p_test, target_test);
plot(target_test, yfit_test, 'r-', 'LineWidth', 2);
plot([min(target_test), max(target_test)], [min(output_test), max(output_test)], 'k--');
R_test = corrcoef(target_test, output_test);
text(min(target_test), max(output_test), sprintf('Test: R=%.5f', R_test(2,1)), 'FontSize',10,'FontWeight','bold');
eqn_test = sprintf('%.2f目标%+.4f', p_test(1), p_test(2));
ylabel(['输出~ = ' eqn_test]);
xlabel('Target');
legend('Data','Fit','Y=T','Location','best');
R_test = corrcoef(target_test, output_test);
title(['Test: R=' num2str(R_test(2,1),'%.5f')]);
box on
% 绘制全部数据回归
subplot(2,2,4);
scatter(target_all, output_all, 40, 'o', 'MarkerEdgeColor','k');
hold on;
p_all = polyfit(target_all, output_all, 1);
yfit_all = polyval(p_all, target_all);
plot(target_all, yfit_all, 'k-', 'LineWidth', 2);
plot([min(target_all), max(target_all)], [min(output_all), max(output_all)], 'k--');
R_all = corrcoef(target_all, output_all);
text(min(target_all), max(output_all), sprintf('All: R=%.5f', R_all(2,1)), 'FontSize',10,'FontWeight','bold');
eqn_all = sprintf('%.2fTarget%+.4f', p_all(1), p_all(2));
ylabel(['输出~ = ' eqn_all]);
xlabel('Target');
legend('Data','Fit','Y=T','Location','best');
R_all = corrcoef(target_all, output_all);
title(['All: R=' num2str(R_all(2,1),'%.5f')]);
box on
set(gcf,'Position',[100 100 900 700]);
%% 绘制学习曲线
figure;
plot(tr.epoch, tr.perf); % % 训练性能
hold on;
plot(tr.epoch, tr.vperf); % 验证性能
plot(tr.epoch, tr.tperf); % 测试性能
legend('Training Performance','Validation Performance','Test Performance');
xlabel('Epochs');
ylabel('Performance (MSE)');
title('Learning Curves');
grid on;
set(gcf,'color','white');
end