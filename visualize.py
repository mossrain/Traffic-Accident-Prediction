#visualize
import pandas as pd
import matplotlib.pyplot as plt
import os

data=pd.read_csv(r'update_traffic_data.csv')

segments=list(set(data["segment"].values))

for segment in segments:
    new_data=data[data["segment"]==segment]
    time=new_data["time"].values
    flow=new_data["flow"].values
    speed=new_data["speed"].values
    is_crash=new_data["is_crash"].values

    size=[]
    for i in range(0,len(is_crash)):
        if is_crash[i]==0:
            size.append(0)
        else:
            size.append(20)

    plt.figure() 
    plt.ylabel(u'flow or speed')
    plt.xlabel(u'time')

    # plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.xticks(rotation=45) 
    
    plt.plot(time,flow,label=u'flow',zorder=1)
    plt.plot(time,speed,label=u'speed',zorder=1)

    plt.scatter(time,flow,label=u'flow in crash',c='purple',s=size,zorder=2)
    plt.scatter(time,speed,label=u'speed in crash',c='red',s=size,zorder=2)

    plt.legend()
    plt.title("segment: "+str(segment))

    result_path = r'./pictures/' 
    imgname="segment_"+str(segment)+".jpg"
    save_img_path = os.path.join(result_path,imgname)
    print(save_img_path)
    # plt.show()
    plt.savefig(save_img_path,dpi=600)  
