# 只绘制starttime-endtime以及前后16min（前后8个时间点）
# 也就是说，每次事故对应一张图
# 观察每次事故前后的特征变化

from math import sqrt
import pandas as pd
import matplotlib.pyplot as plt
import os

data=pd.read_csv(r'update_traffic_data_2.csv')

segments=list(set(data["segment"].values))

for segment in segments:
    new_data=data[data["segment"]==segment]
    is_crash=new_data["is_crash"].values
    exit=True
    for i in is_crash:
        if i==1:
            exit=False
            break

    if exit:
        continue

    
    time=new_data["time"].values
    flow=new_data["flow"].values
    speed=new_data["speed"].values
    
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
    draw_flow=[]
    draw_speed=[]
    draw_diff_flow=[]
    draw_diff_speed=[]
    draw_std_flow=[]
    draw_vari_speed=[]
    draw_speed_on_last_seg=[]
    draw_flow_on_last_seg=[]
    draw_time=[]
    starttime=0

    for i in range(0,len(is_crash)):
        if is_crash[i]==1:
            ok1=True
            ok2=True
            for j in range(max(0,i-3),i):# i-3,i-2,i-1
                if is_crash[j]==1:
                    ok1=False
                    break

            for j in range(i+1,min(len(is_crash),i+4)):# i+1,i+2,i+3
                if is_crash[j]==1:
                    ok2=False
                    break
            
            if ok1:
                starttime=i
                for j in range(max(0,i-3),i):
                    draw_flow.append(flow[j])
                    draw_speed.append(speed[j])
                    draw_diff_flow.append(diff_flow[j])
                    draw_diff_speed.append(diff_speed[j])
                    draw_std_flow.append(std_flow[j])
                    draw_vari_speed.append(vari_speed[j])
                    draw_speed_on_last_seg.append(speed_on_last_seg[j])
                    draw_flow_on_last_seg.append(flow_on_last_seg[j])
                    size.append(0)
                    # print(j,len(time))
                    draw_time.append(time[j])
                   
            
            draw_flow.append(flow[i])
            draw_speed.append(speed[i])
            draw_diff_flow.append(diff_flow[i])
            draw_diff_speed.append(diff_speed[i])
            draw_std_flow.append(std_flow[i])
            draw_vari_speed.append(vari_speed[i])
            draw_speed_on_last_seg.append(speed_on_last_seg[i])
            draw_flow_on_last_seg.append(flow_on_last_seg[i])
            size.append(10)
            draw_time.append(time[i])

            if ok2:
                for j in range(i+1,min(len(is_crash),i+4)):
                    draw_flow.append(flow[j])
                    draw_speed.append(speed[j])
                    draw_diff_flow.append(diff_flow[j])
                    draw_diff_speed.append(diff_speed[j])
                    draw_std_flow.append(std_flow[j])
                    draw_vari_speed.append(vari_speed[j])
                    draw_speed_on_last_seg.append(speed_on_last_seg[j])
                    draw_flow_on_last_seg.append(flow_on_last_seg[j]) 
                    size.append(0)
                    draw_time.append(time[j])

                plt.figure() 
                plt.ylabel(u'flow or speed')
                plt.xlabel(u'time')

                # plt.rcParams['font.sans-serif'] = ['SimHei']
                plt.xticks(rotation=45) 
            
                # time=draw_time
                
                plt.plot(draw_time,draw_flow,label=u'flow',zorder=1)
                plt.plot(draw_time,draw_speed,label=u'speed',zorder=1)
                plt.plot(draw_time,draw_diff_flow,label=u'diff_flow',zorder=1)
                plt.plot(draw_time,draw_diff_speed,label=u'diff_speed',zorder=1)
                plt.plot(draw_time,draw_std_flow,label=u'std_flow',zorder=1)
                plt.plot(draw_time,draw_vari_speed,label=u'vari_speed',zorder=1)
                plt.plot(draw_time,draw_speed_on_last_seg,label=u'speed_on_last_seg',zorder=1)
                plt.plot(draw_time,draw_flow_on_last_seg,label=u'flow_on_last_seg',zorder=1)
                

                plt.scatter(draw_time,draw_flow,c='blue',s=size,zorder=2,alpha=0.7)
                plt.scatter(draw_time,draw_speed,c='orange',s=size,zorder=2,alpha=0.7)
                plt.scatter(draw_time,draw_diff_flow,c="green",s=size,zorder=2,alpha=0.7)
                plt.scatter(draw_time,draw_diff_speed,c="red",s=size,zorder=2,alpha=0.7)
                plt.scatter(draw_time,draw_std_flow,c="purple",s=size,zorder=2,alpha=0.7)
                plt.scatter(draw_time,draw_vari_speed,c="saddlebrown",s=size,zorder=2,alpha=0.7)
                plt.scatter(draw_time,draw_speed_on_last_seg,c="deeppink",s=size,zorder=2,alpha=0.7)
                plt.scatter(draw_time,draw_flow_on_last_seg,c="black",s=size,zorder=1,alpha=0.7)
                

                plt.legend()
                plt.title("segment: "+str(segment)+" ,starttime: "+str(starttime))

                result_path = r'./pictures_3/' 
                imgname="segment_"+str(segment)+"_starttime_"+str(i)+".jpg"
                save_img_path = os.path.join(result_path,imgname)
                print(save_img_path)
                # plt.show()
                plt.savefig(save_img_path,dpi=600)  

                plt.close()
                size=[]
                draw_flow=[]
                draw_speed=[]
                draw_diff_flow=[]
                draw_diff_speed=[]
                draw_std_flow=[]
                draw_vari_speed=[]
                draw_speed_on_last_seg=[]
                draw_flow_on_last_seg=[]
                draw_time=[]
                starttime=0
                    


                







