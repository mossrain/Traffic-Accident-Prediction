# preprocess_1
import pandas as pd
crash_data = pd.read_csv(r'../crash_data.csv')
# traffic_data=pd.read_csv(r'KalmanResult.csv')
traffic_data=pd.read_csv(r'../traffic_data.csv')

def timestamp_to_int(timestamp):
    strs=str(timestamp).split(":")
    return int(strs[0])*3600+int(strs[1])*60+int(strs[2])

for i in range(0,len(traffic_data)):
    traffic_data["time"].values[i]=timestamp_to_int(traffic_data["time"].values[i])

for i in range(0,len(crash_data)):
    crash_data["starttime"].values[i]=timestamp_to_int(crash_data["starttime"].values[i])
    crash_data["endtime"].values[i]=timestamp_to_int(crash_data["endtime"].values[i])

# print(crash_data)

traffic_data["is_crash"]=0
# print(traffic_data)

for i in range(0,len(crash_data)):
    segment=int(crash_data["segment"].values[i])
    starttime=int(crash_data["starttime"].values[i])
    endtime=int(crash_data["endtime"].values[i])
    for j in range(0,len(traffic_data)):
        if int(traffic_data["segment"].values[j])==segment:
            curtime=int(traffic_data["time"].values[j])
            if starttime<=curtime&curtime<=endtime:
                print(starttime,curtime,endtime)
                traffic_data["is_crash"].values[j]=1

print(traffic_data)
traffic_data.to_csv(r'update_traffic_data.csv')






