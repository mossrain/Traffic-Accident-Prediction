# 按照1:4构造数据集
import pandas as pd
import numpy as np
from sklearn import preprocessing
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
import random
from sklearn.utils import shuffle

# 1. 构造数据集
#事故组  is_crash=1的每一条
#对照组1 同一路段随机不同时间无事故
#对照组2 同一时间前一路段 
#对照组3 同一时间后一路段 
#对照组4 同一条路的不同路段且前后24min无事故 

# traffic_data=pd.read_csv(r'update_traffic_data_2.csv')
traffic_data=pd.read_csv(r'../featured_dataset.csv')
data=pd.DataFrame(columns=traffic_data.columns)

# print(traffic_data.columns)
# print(traffic_data.columns)
# traffic_data=traffic_data.drop(columns=['Unnamed: 0.3','Unnamed: 0.2', 'Unnamed: 0.1', 'Unnamed: 0'])
# traffic_data = (traffic_data-traffic_data.min())/(traffic_data.max()-traffic_data.min())#简单实现标准化
# print(traffic_data.columns)

# for i in range(0,len(traffic_data)):
#     traffic_data["segment"].values[i]=traffic_data["segment"].values[i]%10000
#     crash=False
#     if (traffic_data["is_crash"].values[i]==1) & (crash==False):
#         crash=True
#     elif (traffic_data["is_crash"].values[i]==1) & (crash) :
#         traffic_data["is_crash"].values[i]=0
#     else:
#         crash=False
        
        # if i-4>=0:
        #     traffic_data["is_crash"].values[i]=1
        # if i-3>=0:
        #     traffic_data["is_crash"].values[i]=1
        # if i-2>=0:
        #     traffic_data["is_crash"].values[i]=1
        # if i-1>=0:
        #     traffic_data["is_crash"].values[i]=1

is_crash=traffic_data["is_crash"].values

for i in range(0,len(is_crash)):
    if is_crash[i]==1:
        data=pd.concat([data,traffic_data.iloc[[i]]])
        seg=traffic_data["segment"].values[i]
        time=traffic_data["time"].values[i]
        group1=traffic_data[(traffic_data['segment'].isin([seg]))&(traffic_data['is_crash'].isin([0]))]
        # dif_seg_data=traffic_data[[traffic_data['segment']!=seg]]
        if len(traffic_data[traffic_data['segment'].isin([seg-1])])>0:
            lef_seg=seg-1
        else :
            l=(int(int(seg)/1000))*1000
            r=int(int(seg)/1000+1)*1000
            temp=traffic_data[(traffic_data['segment']>=l)&(traffic_data['segment']<r)]
            lef_seg=max(temp['segment'].values)

        if len(traffic_data[traffic_data['segment'].isin([seg+1])])>0:
            rig_seg=seg+1
        else :
            l=(int(int(seg)/1000))*1000
            r=int(int(seg)/1000+1)*1000
            temp=traffic_data[(traffic_data['segment']>=l)&(traffic_data['segment']<r)]
            rig_seg=min(temp['segment'].values)
        

        group2=traffic_data[traffic_data['segment'].isin([lef_seg]) & traffic_data["time"].isin([time])]
        group3=traffic_data[traffic_data['segment'].isin([rig_seg]) & traffic_data["time"].isin([time])]
        # group4=traffic_data[[traffic_data['time']!=time & traffic_data['segment']!=seg & traffic_data["is_crash"]==0]]

        new_seg=0
        while True:
            j=random.randint(0,len(traffic_data)-1)
            if traffic_data["segment"].values[j]!=seg:
                new_seg=traffic_data["segment"].values[j]
                break

        temp=traffic_data[traffic_data['segment'].isin([new_seg]) ]


        # for j in range(0,len(temp)):
        while True:
            j=random.randint(0,len(temp)-1)
            ok=True
            for k in range(max(0,j-12),min(j+12,len(temp))):
                if temp["is_crash"].values[k]==1:
                    ok=False
                    break
            if ok==True:
                break

        group4=temp.iloc[[j]]

        # print(len(group1),len(group2),len(group3),len(group4))

        index=random.randint(0,len(group1)-1)
        group1=group1.iloc[[index]]

        data=pd.concat([data,group1])
        data=pd.concat([data,group2])
        data=pd.concat([data,group3])
        data=pd.concat([data,group4])

data=shuffle(data)
print(data)
data.to_csv(r'dataset.csv')






