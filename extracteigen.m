clc
clear all
addpath(genpath('E:/E��/Ԥ���Ѫ����/����GCS�Ȳ���'))

%�ó������Ҫ����Ϊ���������ݡ�ȥ���쳣���ݡ���ȡ����ֵ������ֵɸѡ��������

%% ��ʼ������ֵ����final_eigen
final_eigen=zeros(919,87);%����ѵ�������Լ����ݹ�358��
final_eigen(1:513,end)=1;
final_eigen(514:end,end)=0;


%% ��������
threshhold=[250,200,200,200,200,100,100];

pathname3='E:/E��/Ԥ���Ѫ����/����GCS�Ȳ���/AHE';
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
 
%��������������ABPMean30min����һ�Ρ�����������������%           
%             if j==4
% %                ABPMean_AHE(:,i)=pro_miss;
%                pro_miss=reSample(pro_miss);
%            end
%������������������ABP30min����һ�Ρ�����������������%          
%             if j==2 || j==3 || j==64
%                pro_miss=reSample(pro_miss);
%             end
%���������������������ݲ���һ�Ρ�����������������%
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

pathname4='E:/E��/Ԥ���Ѫ����/����GCS�Ȳ���/nonAHE';
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
           
%%  �����ݽ��н���������
%��������������ABPMean30min����һ�Ρ�����������������%           
%             if j==4
% %                ABPMean_AHE(:,i)=pro_miss;
%                pro_miss=reSample(pro_miss);
%            end
%������������������ABP30min����һ�Ρ�����������������%          
%             if j==2 || j==3 || j==64
%                pro_miss=reSample(pro_miss);
%             end
%���������������������ݲ���һ�Ρ�����������������%
%            pro_miss=reSample(pro_miss);
           
 %%  ��ʼ������ֵ       
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
%����ֵ�еĿ�ֵNAN�þ�ֵ�����滻����Ϊ��ֵ�滻��������Ե������������11������ֵ
%�����滻�ģ�����������ֵ������7��������77������ֵ���е�һ��������Ҫ����7��
%pro_nan����
for k=1:7
    start=(k-1)*11+1;
   tmp=final_eigen(:,start:start+10);
   pro_nandata=pro_nan(tmp);
   final_eigen(:,start:start+10)=pro_nandata;
end

% %���������Ϣ�е�nanֵ������4��������Ϣȱʧ��ֱ��ȥ��
% [m,n]=find(isnan(final_eigen)==1);
% delnum=unique(m);
% for i=length(delnum):-1:1
%    final_eigen(delnum(i),:)=[]; 
% end

%���3��������Ϣ������һ�µģ�ֻȡ1��
final_eigen=[final_eigen(:,1:83), final_eigen(:,end)];

