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
data["vari_speed_in_last_4mins"]=0  #前4分钟内的speed方差
# data["vari_flow_in_last_8mins"]=0 #前8分钟内的flow方差
# data["vari_speed_in_last_8mins"]=0  #前8分钟内的speed方差
# data["cv_flow"]=0 # 前8分钟内flow的变异系数
# data["cv_speed"]=0# 前8分钟内speed的变异系数
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

    # if i>=4:
    #     flow_arr=[]
    #     speed_arr=[]
    #     i_value=segment[i]
    #     ok=True
    #     for j in range(i-4,i):
    #         if segment[j]!=segment[i]:
    #             ok=False
    #             break
    #         else:
    #             flow_arr.append(flow[j])
    #             speed_arr.append(speed[j])
    #     if ok:
    #         data["vari_flow_in_last_8mins"].values[i]=np.var(flow_arr)
    #         data["vari_speed_in_last_8mins"].values[i]=np.var(speed_arr)
    #         if np.average(flow_arr)==0:
    #             input("flow 0 "+str(segment[i]))
    #         else:
    #             print("flow_arr",np.std(flow_arr),np.average(flow_arr))
    #             data["cv_flow"].values[i]=float(np.std(flow_arr))/float(np.average(flow_arr))*100
    #             print(data["cv_flow"].values[i])
    #         if np.average(speed_arr)==0:
    #             input("speed 0"+str(segment[i]))
    #         else:
    #             print("speed_arr",np.std(speed_arr),np.average(speed_arr))
    #             data["cv_speed"].values[i]=float(np.std(speed_arr))/float(np.average(speed_arr))*100
    #             print(data["cv_speed"].values[i])

    
    if int(segment[i])%1000>101:
        data_in_last_seg=data[data["segment"]==int(segment[i])-1]
        data_in_last_seg=data_in_last_seg[data_in_last_seg["time"]==time[i]]
        # print(data_in_last_seg)
        if len(data_in_last_seg)>0:
            data["speed_on_last_seg"].values[i]=data_in_last_seg["speed"]
            data["flow_on_last_seg"].values[i]=data_in_last_seg["flow"]
   
data["road_id"]=0
data["seg_id"]=0

last_road_id=0
first_seg_id=0
for i in range(0,len(data)):
    road_id=data["road_id"].values[i]=int(int(data["segment"].values[i])/1000)-20
    seg_id=int(data["segment"].values[i])%1000
    if last_road_id==road_id:
        data["seg_id"].values[i]=seg_id-first_seg_id
    else:
        print(last_road_id,road_id)
        data["seg_id"].values[i]=0
        first_seg_id=seg_id
        # input(first_seg_id)
    last_road_id=road_id
    print(data["road_id"].values[i],data["seg_id"].values[i],seg_id)
data.to_csv(r'update_traffic_data_2.csv')
        

    







