function Data=CreateData()

% f=xlsread('��Ӧ����Ӱ������.xlsx','Sheet1', 'A2:D29')';
% x=f(1:3,:);
% t=f(4,:);
f=xlsread('��Ӧ����Ӱ������.xlsx','Sheet1', 'D3:Q16');
t=f(:)';
A=xlsread('��Ӧ����Ӱ������.xlsx','Sheet1', 'A3:A16');
A=repmat(A,14,1);
B=xlsread('��Ӧ����Ӱ������.xlsx','Sheet1', 'B3:B16');
B=repmat(B,14,1);
C=xlsread('��Ӧ����Ӱ������.xlsx','Sheet1', 'C3:C16');
C=repmat(C,14,1);
x=[A,B,C]';
ANSWER=questdlg(' ��������ݼ����й�һ��������?',...
  '��һ������','��','��','Yes');
if strcmp(ANSWER,'Yes')
    for i= 1:4
        MinX = min(x);
        MaxX = max(x);
        x(:,i) = Normalize_Fcn(x(:,i),MinX(i),MaxX(i));
    end
    
    
    for i= 1:2
        Mint = min(t);
        Maxt = max(t);
        t(:,i) = Normalize_Fcn(t(:,i),Mint(i),Maxt(i));
    end
end
%% Train
Inputs=x;
Targets=t;
Data.Inputs=Inputs;
Data.Targets=Targets;
end