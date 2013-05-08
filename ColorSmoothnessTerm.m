function output = ColorSmoothnessTerm(color,sigma)
%Calculate the smoothness term matrix of a 3- channel color image
%Output: 
%   output      -   the output sparse matrix
%Input: 
%   color       -   Input color image
%   sigma       -   Coefficient of gaussian kernel for color similarity
%Code Author:
%   Liu Junyi, Zhejiang University
%   Dec. 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
height = size(color,1);
width = size(color,2);
x=zeros(1,(width-2)*(height-2)*8);
y=zeros(1,(width-2)*(height-2)*8);
s=zeros(1,(width-2)*(height-2)*8);
colorUp = [color;zeros(1,width,3)]; 
colorUp = colorUp(2:height+1,:,:);         % �����������ƶ�һ�У����һ����0���
colorDown = [zeros(1,width,3);color];
colorDown = colorDown(1:height,:,:);       % �����������ƶ�һ�У���һ����0���
colorRight = [zeros(height,1,3),color]; 
colorRight = colorRight(:,1:width,:);      % �����������ƶ�һ�У���һ����0���
colorLeft = [color,zeros(height,1,3)]; 
colorLeft = colorLeft(:,2:width+1,:);      % �����������ƶ�һ�У����һ����0���
CompareColor{1}=colorUp;
CompareColor{2}=colorDown;
CompareColor{3}=colorRight;
CompareColor{4}=colorLeft;

% ���Ա�Ե�����ؽ��в���
rowRange = 2:height-1;
colRange = 2:width-1;
[mu,mv] = meshgrid(1:height, 1:width);
mu = mu';
mv = mv';
for i=1:4 % ����ķ����ͼ����в���
    % ���ָ��ͼ��Խ�������Smoothness��ļ���
    Temp1 = color(rowRange,colRange,:) - CompareColor{i}(rowRange,colRange,:);
    Temp2 = Temp1(:,:,1).^2+Temp1(:,:,2).^2+Temp1(:,:,3).^2;
    Temp3 = sqrt(exp(-1/(2*sigma^2)*Temp2));
    % ��һ����:ԭͼ
    indexRange = 2*length(rowRange)*length(colRange)*(i-1)+1:2*length(rowRange)*length(colRange)*(i-1)+length(rowRange)*length(colRange);
    xTemp = length(rowRange)*length(colRange)*(i-1)+1:length(rowRange)*length(colRange)*i;
    xTemp = xTemp';
    x(indexRange) = xTemp;
    
    muTemp = mu(rowRange,colRange);
    mvTemp = mv(rowRange,colRange);
    pu = reshape(muTemp,length(rowRange)*length(colRange),1);
    pv = reshape(mvTemp,length(rowRange)*length(colRange),1);
    yTemp = pu + (pv - 1) * height;
    y(indexRange) = yTemp;

    sTemp = reshape(Temp3,numel(Temp3),1);
    s(indexRange) = sTemp;

    % �ڶ�����:�Ƚ�ͼ
    indexRange = 2*length(rowRange)*length(colRange)*(i-1)+length(rowRange)*length(colRange)+1:2*length(rowRange)*length(colRange)*i;
    xTemp = length(rowRange)*length(colRange)*(i-1)+1:length(rowRange)*length(colRange)*i;
    xTemp = xTemp';
    x(indexRange) = xTemp;

    if (i==1)
        muTemp = mu(rowRange+1,colRange);
        mvTemp = mv(rowRange+1,colRange);
    elseif (i==2)
        muTemp = mu(rowRange-1,colRange);
        mvTemp = mv(rowRange-1,colRange);
    elseif (i==3)
        muTemp = mu(rowRange,colRange-1);
        mvTemp = mv(rowRange,colRange-1);
    elseif (i==4)
        muTemp = mu(rowRange,colRange+1);
        mvTemp = mv(rowRange,colRange+1);
    end
    pu = reshape(muTemp,length(rowRange)*length(colRange),1);
    pv = reshape(mvTemp,length(rowRange)*length(colRange),1);
    yTemp = pu + (pv - 1) * height;
    y(indexRange) = yTemp;

    sTemp = -reshape(Temp3,numel(Temp3),1);
    s(indexRange) = sTemp;
end
output=sparse(x,y,s,(width-2)*(height-2)*4,height*width);

