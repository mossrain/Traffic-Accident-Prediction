#visualize
from math import sqrt
import pandas as pd
import matplotlib.pyplot as plt
import os

data=pd.read_csv(r'update_traffic_data_2.csv')

segments=list(set(data["segment"].values))

for segment in segments:
    new_data=data[data["segment"]==segment]
    time=new_data["time"].values
    flow=new_data["flow"].values
    speed=new_data["speed"].values
    is_crash=new_data["is_crash"].values
    diff_flow=new_data["diff_flow"].values
    diff_speed=new_data["speed"].values
    vari_flow=new_data["vari_flow_in_last_4mins"].values
    std_flow=[]
 
    for i in range(0,len(vari_flow)):
        std_flow.append(sqrt(float(vari_flow[i])))

    vari_speed=new_data["vari_speed_in_last_4mins"].values
    speed_on_last_seg=new_data["speed_on_last_seg"].values
    flow_on_last_seg=new_data["flow_on_last_seg"].values

    size=[]
    for i in range(0,len(is_crash)):
        if is_crash[i]==0:
            size.append(0)
        else:
            size.append(10)

    plt.figure() 
    plt.ylabel(u'flow or speed')
    plt.xlabel(u'time')

    # plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.xticks(rotation=45) 
    
    plt.plot(time,flow,label=u'flow',zorder=1)
    plt.plot(time,speed,label=u'speed',zorder=1)
    plt.plot(time,diff_flow,label=u'diff_flow',zorder=1)
    plt.plot(time,diff_speed,label=u'diff_speed',zorder=1)
    plt.plot(time,std_flow,label=u'std_flow',zorder=1)
    plt.plot(time,vari_speed,label=u'vari_speed',zorder=1)
    plt.plot(time,speed_on_last_seg,label=u'speed_on_last_seg',zorder=1)
    plt.plot(time,flow_on_last_seg,label=u'flow_on_last_seg',zorder=1)
    

    plt.scatter(time,flow,c='blue',s=size,zorder=2,alpha=0.7)
    plt.scatter(time,speed,c='orange',s=size,zorder=2,alpha=0.7)
    plt.scatter(time,diff_flow,c="green",s=size,zorder=2,alpha=0.7)
    plt.scatter(time,diff_speed,c="red",s=size,zorder=2,alpha=0.7)
    plt.scatter(time,std_flow,c="purple",s=size,zorder=2,alpha=0.7)
    plt.scatter(time,vari_speed,c="saddlebrown",s=size,zorder=2,alpha=0.7)
    plt.scatter(time,speed_on_last_seg,c="deeppink",s=size,zorder=2,alpha=0.7)
    plt.scatter(time,flow_on_last_seg,c="black",s=size,zorder=1,alpha=0.7)
    

    plt.legend()
    plt.title("segment: "+str(segment))

    result_path = r'./pictures_2/' 
    imgname="segment_"+str(segment)+".jpg"
    save_img_path = os.path.join(result_path,imgname)
    print(save_img_path)
    # plt.show()
    plt.savefig(save_img_path,dpi=600)  
    plt.close()
