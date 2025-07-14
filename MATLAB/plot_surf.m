% 硫酸盐还原率二维云图绘制
clear; clc;close all
warning off
% 数据输入
A = [1 5 5 5 1 5 1 5 9 9 9 9 5 1]; % COD/SO42-
B = [40 40 30 30 30 40 35 35 35 40 35 30 35 35]; % 温度
C = [0.105 0.2 0.2 0.01 0.105 0.01 0.01 0.105 0.2 0.105 0.01 0.105 0.105 0.2]; % 气体流量
response = [12.48055 25.35792 36.86151 85.73757 19.83483 63.09044 38.13484 38.27659 28.86984 26.70388 88.78447 85.09467 36.09676 10.39038]; % 硫酸盐还原率

% 创建网格
A_grid = linspace(1, 9, 20);
C_grid = linspace(0.01, 0.2, 20);
[A_mesh, C_mesh] = meshgrid(A_grid, C_grid);

% 温度设置
temps = [30, 35, 40];

figure('Position', [100, 100, 1200, 400]);

for i = 1:3
    subplot(1, 3, i);
    
    % 筛选当前温度的数据
    idx = (B == temps(i));
    A_temp = A(idx);
    C_temp = C(idx);
    response_temp = response(idx);
    

    if temps(i) == 30 || temps(i) == 40

        A_rect = [1, 5, 9];
        C_rect = [0.01, 0.105, 0.2];
        [A_rect_mesh, C_rect_mesh] = meshgrid(A_rect, C_rect);
        A_rect_flat = A_rect_mesh(:);
        C_rect_flat = C_rect_mesh(:);
        

        response_rect = griddata(A_temp, C_temp, response_temp, A_rect_flat, C_rect_flat, 'linear');
        

        nan_idx = isnan(response_rect);
        if any(nan_idx)
            response_rect(nan_idx) = griddata(A_temp, C_temp, response_temp, A_rect_flat(nan_idx), C_rect_flat(nan_idx), 'nearest');
        end
        

        Z = griddata(A_rect_flat, C_rect_flat, response_rect, A_mesh, C_mesh, 'cubic');
    else

        Z = griddata(A_temp, C_temp, response_temp, A_mesh, C_mesh, 'cubic');
    end
    
    % 使用 pcolor 绘制云图
    pcolor(A_mesh, C_mesh, Z);
    shading interp; % 插值平滑
    hold on;
    
    % 使用 contourf 仅绘制等高线
    [M, c] = contour(A_mesh, C_mesh, Z, 5, 'k', 'LineWidth', 0.5); % 5条黑色等高线
    clabel(M, c, 'FontSize', 8, 'Color', 'k'); % 显示等高线数值，设置字体大小和颜色
    colorbar;
    
    % 添加数据点
    scatter(A_temp, C_temp, 50, response_temp, 'filled', 'MarkerEdgeColor', 'k');
    
    % 图形设置
    xlabel('COD/SO_4^{2-}');
    ylabel('Gas stripping flow');
    title(sprintf(' %d°C', temps(i)));
    colormap('jet');
    grid on;
    set(gca,'FontName','Times New Roman');
    set(gca,'XTick',1:2:9);%设置要显示坐标刻度
    set(gca,'YTick',[0.01:0.038:0.200]);%设置要显示坐标刻度
    set(gca,'YTicklabel',{'0.010','0.048','0.086','0.124','0.162','0.200'})
end


