% 硫酸盐还原率二维云图绘制
clear; clc; close all
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

% 将图幅宽度和高度都改为1200
figure('Position', [100, 100, 1200, 1200]);

for i = 1:3
    subplot(1, 3, i);
    
    % 筛选当前温度的数据
    idx = (B == temps(i));
    A_temp = A(idx);
    C_temp = C(idx);
    response_temp = response(idx);
    
    if temps(i) == 30 || temps(i) == 40
        % 创建矩形网格点
        A_rect = [1, 5, 9];
        C_rect = [0.01, 0.105, 0.2];
        [A_rect_mesh, C_rect_mesh] = meshgrid(A_rect, C_rect);
        A_rect_flat = A_rect_mesh(:);
        C_rect_flat = C_rect_mesh(:);
        
        % 插值计算响应值
        response_rect = griddata(A_temp, C_temp, response_temp, A_rect_flat, C_rect_flat, 'linear');
        
        % 处理NaN值
        nan_idx = isnan(response_rect);
        if any(nan_idx)
            response_rect(nan_idx) = griddata(A_temp, C_temp, response_temp, A_rect_flat(nan_idx), C_rect_flat(nan_idx), 'nearest');
        end
        
        % 网格插值
        Z = griddata(A_rect_flat, C_rect_flat, response_rect, A_mesh, C_mesh, 'cubic');
    else
        % 直接网格插值
        Z = griddata(A_temp, C_temp, response_temp, A_mesh, C_mesh, 'cubic');
    end
    
    % 使用 pcolor 绘制云图
    pcolor(A_mesh, C_mesh, Z);
    shading interp; % 插值平滑
    hold on;
    
    % 创建10的倍数的等高线层级
    min_val = min(Z(:));
    max_val = max(Z(:));
    
    % 计算10的倍数层级
    start_level = 10 * ceil(min_val/10);  % 大于等于最小值的最小10的倍数
    end_level = 10 * floor(max_val/10);   % 小于等于最大值的最大10的倍数
    levels = start_level:10:end_level;   % 10的倍数序列
    
    % 如果层级少于5个，使用默认方法生成5个层级
    if numel(levels) < 5
        levels = linspace(min_val, max_val, 5);
        levels = 10 * round(levels/10);  % 四舍五入到最近的10的倍数
    end
    
    % === 修改后的等高线标签方法 ===
    % 绘制等高线并获取轮廓矩阵
    [contourMatrix, contourHandle] = contour(A_mesh, C_mesh, Z, levels, 'k', 'LineWidth', 0.5);
    
    % 设置标签间距为一个很大的值，确保每条等高线只显示一个标签
    set(contourHandle, 'LabelSpacing', 1000); 
    
    % 添加等高线标签
    clabel(contourMatrix, contourHandle, 'FontSize', 8, 'Color', 'k');
    
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
    
    % 设置正方形比例
    axis square;
end

% 调整子图位置以适应更大的图形窗口
for i = 1:3
    subplot(1, 3, i);
    pos = get(gca, 'Position');
    % 调整位置：保持宽度，增加高度，垂直居中
    new_height = min(pos(3), 0.25); % 最大高度为0.25（归一化单位）
    new_pos = [pos(1), (1 - new_height)/2, pos(3), new_height];
    set(gca, 'Position', new_pos);
end