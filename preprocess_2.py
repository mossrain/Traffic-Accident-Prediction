#preprocess_2
import pandas as pd
import matplotlib.pyplot as plt
import os
import numpy as np

data=pd.read_csv(r'update_traffic_data.csv')

flow=data["flow"].values
speed=data["speed"].values
segment=data["segment"].values
time=data["time"].values
data["diff_flow"]=0 # 与上一时刻的flow差值
data["diff_speed"]=0 # 与上一时刻的speed差值
data["vari_flow_in_last_4mins"]=0 #前4分钟内的flow方差
data["vari_speed_in_last_4mins"]=0  #前4分钟内的flow方差
data["speed_on_last_seg"]=0 #同一条路的上一个路段的speed
data["flow_on_last_seg"]=0 #同一条路的上一个路段的flow
for i in range(0,len(data)):
    if segment[i-1]==segment[i]:
        data["diff_flow"].values[i]=flow[i-1]-flow[i]
        data["diff_speed"].values[i]=speed[i-1]-speed[i]
    # print(segment[i-2],segment[i-1],segment[i])
    if segment[i-2]==segment[i-1]&segment[i-1]==segment[i]:
        
        flow_arr=[float(flow[i-2]), float(flow[i-1]), float(flow[i])]
        speed_arr=[float(speed[i-2]), float(speed[i-1]), float(speed[i])]
        # print(flow_arr)
        # print(speed_arr)
        data["vari_flow_in_last_4mins"].values[i]=np.var(flow_arr)
        data["vari_speed_in_last_4mins"].values[i]=np.var(speed_arr)
    
    if int(segment[i])%1000>101:
        data_in_last_seg=data[data["segment"]==int(segment[i])-1]
        data_in_last_seg=data_in_last_seg[data_in_last_seg["time"]==time[i]]
        # print(data_in_last_seg)
        if len(data_in_last_seg)>0:
            data["speed_on_last_seg"].values[i]=data_in_last_seg["speed"]
            data["flow_on_last_seg"].values[i]=data_in_last_seg["flow"]
   

data.to_csv(r'update_traffic_data_2.csv')
        

    







