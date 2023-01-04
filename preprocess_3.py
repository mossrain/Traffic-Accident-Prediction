#删除部分缺失值
import pandas as pd

traffic_data=pd.read_csv(r'update_traffic_data.csv')
flow=traffic_data["flow"].values
speed=traffic_data["speed"].values
print(len(flow),len(speed),len(traffic_data))
for i in range(0,len(flow)):
    # index=traffic_data.index[i]
    print(flow[i],speed[i],i)
    if (flow[i]==0) & (speed[i]!=0):
        traffic_data=traffic_data.drop(index=i)

print(traffic_data)
traffic_data.to_csv(r'update_traffic_data.csv')