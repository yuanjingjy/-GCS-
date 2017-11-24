clc
clear all
addpath(genpath('E:/E盘/预测低血容量/加入GCS等参数'))

%该程序的主要流程为：加载数据、去除异常数据、提取特征值、特征值筛选、神经网络

%% 初始化特征值矩阵final_eigen
final_eigen=zeros(919,87);%所有训练集测试集数据共358例
final_eigen(1:513,end)=1;
final_eigen(514:end,end)=0;


%% 加载数据
threshhold=[250,200,200,200,200,100,100];

pathname3='E:/E盘/预测低血容量/加入GCS等参数/AHE';
cd(pathname3);
FileList=dir;
AHEpath='D:/Available/already/'
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       AHEname(i,:)=str2num(tmpname(2:6));
       subjectid=AHEname(i,:);
       load(tmpname)
       for j=1:7
           data=AHE_tmp(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
 
%———————ABPMean30min采样一次—————————%           
%             if j==4
% %                ABPMean_AHE(:,i)=pro_miss;
%                pro_miss=reSample(pro_miss);
%            end
%———————所有ABP30min采样一次—————————%          
%             if j==2 || j==3 || j==64
%                pro_miss=reSample(pro_miss);
%             end
%———————所有数据采样一次—————————%
%            pro_miss=reSample(pro_miss);
           
 %%           
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2,start:start+10)=eigen;
       end
       
       
       filedir=[AHEpath,tmpname(1:6)];
       cd(filedir);
       baseinfoname=[tmpname(1:end-7),'baseinfo.mat'];
       load(baseinfoname);
       final_eigen(i-2,78:86)=baseinfo(1:9);  
       cd(pathname3);
   end
end
cd ..

pathname4='E:/E盘/预测低血容量/加入GCS等参数/nonAHE';
cd(pathname4);
nonAHEpath='D:/Available/already/'
FileList=dir;
for i=1:length(FileList)
    tmpname=FileList(i).name;
   if(tmpname(1)=='s')
       nonAHEname(i,:)=str2num(tmpname(2:6));
       load(tmpname)
       for j=1:7
           data=nonAHE_data(1:600,j);
           pro_abn=xigma(data);
           pro_miss=mmMissingValues(pro_abn,threshhold(j));
           
%%  对数据进行降采样处理
%———————ABPMean30min采样一次—————————%           
%             if j==4
% %                ABPMean_AHE(:,i)=pro_miss;
%                pro_miss=reSample(pro_miss);
%            end
%———————所有ABP30min采样一次—————————%          
%             if j==2 || j==3 || j==64
%                pro_miss=reSample(pro_miss);
%             end
%———————所有数据采样一次—————————%
%            pro_miss=reSample(pro_miss);
           
 %%  开始求特征值       
           eigen=tezhengzhi(pro_miss);
           start=(j-1)*11+1;
           final_eigen(i-2+513,start:start+10)=eigen;
       end
       
       filedir=[nonAHEpath,tmpname(1:6)];
       cd(filedir);
       baseinfoname=[tmpname(1:end-7),'baseinfo.mat'];
       load(baseinfoname);
       final_eigen(i-2+513,78:86)=baseinfo(1:9);  
       cd(pathname4);
   end
end
cd ..
test_eigen=final_eigen;
% load final_eigen
%特征值中的空值NAN用均值进行替换，因为空值替换程序是针对单个生理参数的11个特征值
%进行替换的，而整个特征值矩阵是7个变量的77个特征值排列到一起，所以需要调用7次
%pro_nan函数
for k=1:7
    start=(k-1)*11+1;
   tmp=final_eigen(:,start:start+10);
   pro_nandata=pro_nan(tmp);
   final_eigen(:,start:start+10)=pro_nandata;
end

% %处理基本信息中的nan值，共有4个体重信息缺失，直接去掉
% [m,n]=find(isnan(final_eigen)==1);
% delnum=unique(m);
% for i=length(delnum):-1:1
%    final_eigen(delnum(i),:)=[]; 
% end

%最后3列体中信息基本是一致的，只取1列
final_eigen=[final_eigen(:,1:83), final_eigen(:,end)];

