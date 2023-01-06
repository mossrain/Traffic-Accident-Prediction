#-----------------------读文件，记得改文件路径----------------------------------------------
sourceData=read.csv("D:/DeskTop/update_traffic_data.csv")
str(sourceData) 
#-----------------------读文件结束----------------------------------------------------------

#-----------------------设置List数据结构----------------------------------------------------
dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      if(i-head==720){
        dataList[[count]]=sourceData[head:tail,c(2,4,5,6)]
        count=count+1
      }
      head=i
    }
    if(i==nrow(sourceData)){
      if(i-head==719){
        tail=i
        dataList[[count]]=sourceData[head:tail,c(2,4,5,6)]
      }
    }
  }
}
#-----------------------数据结构设置结束----------------------------------------------------

#-------------------------------数据分段----------------------------------------------------
StableList=NULL
Temp=NULL
WaveList=NULL
for (i in 1:length(dataList)) {
  StableList[[i]]=dataList[[i]][210:584,]
  WaveList[[i]]=dataList[[i]][1:345,]
  WaveList[[i]][,1]=c(dataList[[i]][585:720,][,1],dataList[[i]][1:209,][,1])
  WaveList[[i]][,2]=c(dataList[[i]][585:720,][,2],dataList[[i]][1:209,][,2])
  WaveList[[i]][,3]=c(dataList[[i]][585:720,][,3],dataList[[i]][1:209,][,3])
  WaveList[[i]][,4]=c(dataList[[i]][585:720,][,4],dataList[[i]][1:209,][,4])
}
#加载时间序列程序包
#install.packages("tseries")
#install.packages("forecast")
library(tseries)
library(forecast)

#-------------------------------------------------------------------------------f1
tsdisplay(dataList[[1]]$flow)
adf.test(dataList[[1]]$flow)
DataList_Flow=diff(dataList[[1]]$flow,1)
tsdisplay(DataList_Flow)
adf.test(DataList_Flow)
auto.arima(dataList[[1]]$flow)  #(0,1,1) AIC=5612.87

fit1<-arima(dataList[[1]]$flow,order=c(0,1,1))
tsdiag(fit1)

#预测
f.p1<-forecast(fit1,h=2,level=c(99.5))
#先看一下fit1的效果
plot(f.p1)
lines(ts(fkf.obj$att[1, ], start = start(y), frequency = frequency(y)),col="green")
lines(dataList[[1]]$flow,col="red")

plot(f.p1)
lines(f.p1$fitted,col="green")
lines(dataList[[1]]$flow,col="red")
#红色为原始数据，绿色为计算出来的原始数据拟合值，蓝色段为预测值
#-------------------------------------------------------------------------------f1


#-------------------------------------------------------------------------------f2
tsdisplay(dataList[[1]]$speed)
adf.test(dataList[[1]]$speed)
DataList_Speed=diff(dataList[[1]]$speed,2)
tsdisplay(DataList_Speed)
adf.test(DataList_Speed)
auto.arima(dataList[[1]]$speed) #(0,1,0) AIC=4627.38

fit2<-arima(dataList[[1]]$speed,order=c(0,1,0))
tsdiag(fit2)

#预测
f.p2<-forecast(fit2,h=2,level=c(99.5))
#先看一下fit2的效果
plot(f.p2)
lines(ts(fkf.obj$att[1, ], start = start(y), frequency = frequency(y)),col="green")
lines(dataList[[1]]$speed,col="red")

plot(f.p2)
lines(f.p2$fitted,col="green")
lines(dataList[[1]]$speed,col="red")
#红色为原始数据，绿色为计算出来的原始数据拟合值，蓝色段为预测值
#-------------------------------------------------------------------------------f2


#-------------------------------------------------------------------------------f3
tsdisplay(StableList[[1]]$flow)
adf.test(StableList[[1]]$flow)
StableList_Flow=diff(StableList[[1]]$flow,1)
tsdisplay(StableList_Flow)
adf.test(StableList_Flow)
StableList_Flow=StableList[[1]]$flow
auto.arima(StableList[[1]]$flow) #(0,1,4) AIC=3007.55

fit3<-arima(StableList[[1]]$flow,order=c(0,1,4))
tsdiag(fit3)

#预测
f.p3<-forecast(fit3,h=2,level=c(99.5))
#先看一下fit3的效果
plot(f.p3)
lines(ts(fkf.obj$att[1, ], start = start(y), frequency = frequency(y)),col="green")
lines(StableList[[1]]$flow,col="red")

plot(f.p3)
lines(f.p3$fitted,col="green")
lines(StableList[[1]]$flow,col="red")
#红色为原始数据，绿色为计算出来的原始数据拟合值，蓝色段为预测值
#-------------------------------------------------------------------------------f3


#-------------------------------------------------------------------------------f4
tsdisplay(StableList[[1]]$speed)
adf.test(StableList[[1]]$speed)
StableList_Speed=diff(StableList[[1]]$speed,2)
tsdisplay(StableList_Speed)
adf.test(StableList_Speed)
auto.arima(StableList[[1]]$speed) #(0,1,0) AIC=2574.87

fit4<-arima(StableList[[1]]$speed,order=c(0,1,0))
tsdiag(fit4)

#预测
f.p4<-forecast(fit4,h=2,level=c(99.5))
#先看一下fit4的效果
plot(f.p4)
lines(ts(fkf.obj$att[1, ], start = start(y), frequency = frequency(y)),col="green")
lines(StableList[[1]]$speed,col="red")

plot(f.p4)
lines(f.p4$fitted,col="green")
lines(StableList[[1]]$speed,col="red")
#红色为原始数据，绿色为计算出来的原始数据拟合值，蓝色段为预测值
#-------------------------------------------------------------------------------f4


#-------------------------------------------------------------------------------f5
tsdisplay(WaveList[[1]]$flow)
adf.test(WaveList[[1]]$flow)
WaveList_Flow=diff(WaveList[[1]]$flow,1)
tsdisplay(WaveList_Flow)
adf.test(WaveList_Flow)
auto.arima(WaveList[[1]]$flow) #(3,1,1) AIC=2539.06 (6,1,6) AIC=2532.88

fit5<-arima(WaveList[[1]]$flow,order=c(3,1,1))
tsdiag(fit5)

f.p5<-forecast(fit5,h=2,level=c(99.5))
#先看一下fit5的效果
plot(f.p5)
lines(ts(fkf.obj$att[1, ], start = start(y), frequency = frequency(y)),col="green")
lines(WaveList[[1]]$flow,col="red")

plot(f.p5)
lines(f.p5$fitted,col="green")
lines(WaveList[[1]]$flow,col="red")
#红色为原始数据，绿色为计算出来的原始数据拟合值，蓝色段为预测值
#-------------------------------------------------------------------------------f5


#-------------------------------------------------------------------------------f6
tsdisplay(WaveList[[1]]$speed)
adf.test(WaveList[[1]]$speed)
WaveList_Speed=diff(WaveList[[1]]$speed,2)
tsdisplay(WaveList_Speed)
adf.test(WaveList_Speed)
auto.arima(WaveList[[1]]$speed) #(1,1,1) AIC=1877.46 (7,1,7) AIC=1872.52

fit6<-arima(WaveList[[1]]$speed,order=c(1,1,1))
tsdiag(fit6)

f.p6<-forecast(fit6,h=2,level=c(99.5))
#先看一下fit6的效果
plot(f.p6$x[329:345])
lines(ts(fkf.obj$att[1, ][329:345], start = start(y), frequency = frequency(y)),col="green")
lines(WaveList[[1]]$speed[329:345],col="red")

plot(f.p6)
lines(f.p6$fitted,col="green")
lines(WaveList[[1]]$speed,col="red")
#红色为原始数据，绿色为计算出来的原始数据拟合值，蓝色段为预测值
#-------------------------------------------------------------------------------f6





#-------------------------------Kalman滤波预测----------------------------------------------------
library(FKF)
##------------------------------------------------------------------------------单元
## <--------------------------------------------------------------------------->
## Example: Local level model for the Nile's annual flow.
## <--------------------------------------------------------------------------->
## Transition equation:
## alpha[t+1] = alpha[t] + eta[t], eta[t] ~ N(0, HHt)          
## Measurement equation:
## y[t] = alpha[t] + eps[t], eps[t] ~  N(0, GGt)

y = dataList[[1]]$flow    #----f1

y = dataList[[1]]$speed   #----f2

y = StableList[[1]]$flow  #----f3

y = StableList[[1]]$speed #----f4

y = WaveList[[1]]$flow    #----f5

y = WaveList[[1]]$speed   #----f6


## Set constant parameters:
notebook=rep(0,times=length(y))
for(i in 1:length(y)){
  if(y[i] %% 2 == 1){
    y[i] = y[i]+1
    notebook[i]=1
  }
}
dt = ct = matrix(0) 
Zt = Tt = matrix(1)
a0 = y[1]          # Estimation of the first year flow 
P0 = matrix((y[1]+mean(y))%/%2)     # Variance of 'a0'

for(i in 330:345){
  y[i]=NA
}
## Estimate parameters:
fit.fkf <- optim(c(HHt = var(y, na.rm = TRUE) * .5,
                   GGt = var(y, na.rm = TRUE) * .5),
                 fn = function(par, ...)
                   -fkf(HHt = matrix(par[1]), GGt = matrix(par[2]), ...)$logLik,
                 yt = rbind(y), a0 = a0, P0 = P0, dt = dt, ct = ct,
                 Zt = Zt, Tt = Tt)

## Filter Nile data with estimated parameters:
fkf.obj = fkf(a0, P0, dt, ct, Tt, Zt, HHt = matrix(fit.fkf$par[1]),
               GGt = matrix(fit.fkf$par[2]), yt = rbind(y))

for(i in 1:length(notebook)){
  if(notebook[i]==1){
    fkf.obj$att[1, ][i]=fkf.obj$att[1, ][i]-1
  }
}
## Compare with the stats' structural time series implementation:
fit.stats = StructTS(y, type = "level")

fit.fkf$par
fit.stats$coef

## Plot the flow data together with fitted local levels:
plot(y, main = "Nile flow")
lines(fitted(fit.stats), col = "green")
lines(ts(fkf.obj$att[1, ], start = start(y), frequency = frequency(y)), col = "blue")
legend("top", c("Nile flow data", "Local level (StructTS)", "Local level (fkf)"),
       col = c("black", "green", "blue"), lty = 1)


##------------------------------------------------------------------------------多元
#构建R语言函数kalman，对Kalman滤波算法进行实现
#A:状态转移矩阵，默认初始化为diag(ncol(Z))
#H:观测协方差矩阵，默认初始化为diag(ncol(Z))
#Q:系统噪声协方差矩阵，默认初始化为diag(ncol(Z))
#R:观测噪声协方差矩阵，默认初始化为diag(ncol(Z))
#X0:状态量初始值，默认初始化为diag(ncol(Z))
#P0:误差协方差矩阵，默认初始化为diag(ncol(Z))
#Z:观测量
library(FKF)
kalman <- function(Z,A=NULL,H=NULL,Q=NULL,R=NULL,X0=NULL,P0=NULL)
{
  dmt <- diag(ncol(Z))
  if(is.null(A))A <- dmt
  if(is.null(H))H <- dmt
  if(is.null(Q))Q <- dmt
  if(is.null(R))R <- dmt
  if(is.null(X0))X0 <- dmt
  if(is.null(P0))P0 <- dmt
  X <- list(X0)
  P <- list(P0)
  N <- nrow(Z)
  I <- diag(dim(A)[1])
  for (i in 1:N) {
    #均方误差的一步预测方程
    Pp <- A %*% P[[i]] %*% t(A) + Q 
    #滤波增益方程（权重）
    K <- Pp %*% t(H) %*% solve(H %*% Pp %*% t(H) + R)
    #状态的一步预测方程
    Xp <- A %*% X[[i]]
    #滤波估计方程（k时刻的最优值）
    X <- c(X, list(Xp + K %*% (diag(Z[i,]) - H %*% Xp)))
    #均方误差更新矩阵（k时刻的最优均方误差）
    P <- c(P, list((I - K %*% H) %*% Pp))
  }
  return(X)
}

#Z=Canada[1:84,]
Z=cbind(dataList[[9]]$flow,dataList[[9]]$speed,dataList[[10]]$flow,dataList[[10]]$speed,dataList[[11]]$flow,dataList[[11]]$speed)
X=kalman(Z)
n=ncol(Z)
outMatrix=matrix(unlist(lapply(X,diag)),ncol=n,byrow=T)
#par(mfrow=c(3,2))
setwd("D:/DeskTop/test")
for(i in 1:n)
{
  a=outMatrix[,i]
  b=Z[,i]
  rag=range(c(a,b))+c(-1,1)
  
  png(file = paste(as.character(i),".png"), width = 800, height = 600)
  plot(b,type='l')
  lines(a,type='l',lty=3,col='blue')
  lines(b,col='red')
  dev.off()
}
#par(mfrow=c(1,1))


#------------------------------------生成新数据-----------------------------------######################
sourceData=read.csv("D:/DeskTop/traffic_data.csv")
str(sourceData) 

dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      if(i-head==720){
        dataList[[count]]=sourceData[head:tail,c(1,2,3,4)]
        count=count+1
      }
      head=i
    }
    if(i==nrow(sourceData)){
      if(i-head==719){
        tail=i
        dataList[[count]]=sourceData[head:tail,c(1,2,3,4)]
      }
    }
  }
}
library(FKF)
notebook3=rep(0,times=214)
notebook4=rep(0,times=214)
for(j in 1:214){
  for(k in 1:720){
    if(dataList[[j]]$flow[k]*dataList[[j]]$speed[k]==0 && dataList[[j]]$flow[k]!=dataList[[j]]$speed[k]){
      notebook3[j]=1
      notebook4[j]=k
      #print(paste(" j is ",as.character(j),' k is ',as.character(k),' ',as.character(dataList[[j]]$segment[k])," flow is ",as.character(dataList[[j]]$flow[k])," speed is ",as.character(dataList[[j]]$speed[k])))
      break
    }
  }
}


notebook5=which(notebook3==1)

###################################################################
dataList=dataList[-notebook5]
###################################################################

which(notebook4!=0)
for(j in 1:length(notebook5)){
  print(paste(" j=",as.character(j),'----',as.character(dataList[[notebook5[j]]]$segment[1])," has ",as.character(length(which(dataList[[notebook5[j]]]$flow==0)))," NA flow and ",as.character(length(which(dataList[[notebook5[j]]]$speed==0)))," NA speed"))
}



lines=1
kalmanResult=data.frame(segment=rep(0,times=720*124),time=rep(0,times=720*124),flow=rep(0,times=720*124),speed=rep(0,times=720*124))
for(j in 1:length(dataList)){
  
  y = dataList[[j]]$flow    #----f1
  
  
  ## Set constant parameters:
  notebook=rep(0,times=length(y))
  for(i in 1:length(y)){
    if(y[i] %% 2 == 1){
      y[i] = y[i]+1
      notebook[i]=1
    }
  }
  dt = ct = matrix(0) 
  Zt = Tt = matrix(1)
  a0 = y[1]          # Estimation of the first year flow 
  P0 = matrix((y[1]+mean(y))%/%2)     # Variance of 'a0'

  ## Estimate parameters:
  fit.fkf <- optim(c(HHt = var(y, na.rm = TRUE) * .5,
                     GGt = var(y, na.rm = TRUE) * .5),
                   fn = function(par, ...)
                     -fkf(HHt = matrix(par[1]), GGt = matrix(par[2]), ...)$logLik,
                   yt = rbind(y), a0 = a0, P0 = P0, dt = dt, ct = ct,
                   Zt = Zt, Tt = Tt)
  
  ## Filter Nile data with estimated parameters:
  fkf.obj = fkf(a0, P0, dt, ct, Tt, Zt, HHt = matrix(fit.fkf$par[1]),
                GGt = matrix(fit.fkf$par[2]), yt = rbind(y))
  
  for(i in 1:length(notebook)){
    if(notebook[i]==1){
      fkf.obj$att[1, ][i]=fkf.obj$att[1, ][i]-1
    }
  }
  
  tmp1=fkf.obj$att[1, ]
  
  y = dataList[[j]]$speed    #----f1
  
  
  ## Set constant parameters:
  notebook=rep(0,times=length(y))
  for(i in 1:length(y)){
    if(y[i] %% 2 == 1){
      y[i] = y[i]+1
      notebook[i]=1
    }
  }
  dt = ct = matrix(0) 
  Zt = Tt = matrix(1)
  a0 = y[1]          # Estimation of the first year flow 
  P0 = matrix((y[1]+mean(y))%/%2)     # Variance of 'a0'
  
  ## Estimate parameters:
  fit.fkf <- optim(c(HHt = var(y, na.rm = TRUE) * .5,
                     GGt = var(y, na.rm = TRUE) * .5),
                   fn = function(par, ...)
                     -fkf(HHt = matrix(par[1]), GGt = matrix(par[2]), ...)$logLik,
                   yt = rbind(y), a0 = a0, P0 = P0, dt = dt, ct = ct,
                   Zt = Zt, Tt = Tt)
  
  ## Filter Nile data with estimated parameters:
  fkf.obj = fkf(a0, P0, dt, ct, Tt, Zt, HHt = matrix(fit.fkf$par[1]),
                GGt = matrix(fit.fkf$par[2]), yt = rbind(y))
  
  for(i in 1:length(notebook)){
    if(notebook[i]==1){
      fkf.obj$att[1, ][i]=fkf.obj$att[1, ][i]-1
    }
  }
  
  tmp2=fkf.obj$att[1, ]
  
  for(m in 1:720){
    kalmanResult[720*(lines-1)+m,1]=dataList[[j]]$segment[m]
    kalmanResult[720*(lines-1)+m,2]=dataList[[j]]$time[m]
    kalmanResult[720*(lines-1)+m,3]=tmp1[m]
    kalmanResult[720*(lines-1)+m,4]=tmp2[m]
  }
  
  print(lines)
  lines = lines+1
}

library(dplyr)
write.csv(kalmanResult,"D:/DeskTop/KalmanResult.csv",row.names = FALSE)




#------------------------------------相关系数计算-----------------------------------######################
#install.packages('dplyr')
##install.packages('Hmisc')
library(Hmisc)
library(dplyr)

sourceData=read.csv("D:/DeskTop/update_traffic_data_2.csv")
str(sourceData) 

dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      if(TRUE){
        dataList[[count]]=sourceData[head:tail,c(7,15,8,14,5)]
        count=count+1
      }
      head=i
    }
    if(i==nrow(sourceData)){
      if(TRUE){
        tail=i
        dataList[[count]]=sourceData[head:tail,c(7,15,8,14,5)]
      }
    }
  }
}

r_corData=NULL
p_corData=NULL

index=1
for(i in 1:length(dataList)){
  if(dataList[[i]]$flow_on_last_seg[1]!=0){
    corData = rcorr(as.matrix(dataList[[i]][,c(1,2)])) 
    #View(corData$r)
    
    #View(corData$P)
    
    r_tmp1=corData$r[1,2]  #r_corData存储相关系数的计算结果
    p_tmp1=corData$P[1,2]  #p_corData存储显著性检验的P值结果
    
    corData = rcorr(as.matrix(dataList[[i]][,c(3,4)])) 
    #View(corData$r)
    
    #View(corData$P)
    
    r_tmp2=corData$r[1,2]  #r_corData存储相关系数的计算结果
    p_tmp2=corData$P[1,2]  #p_corData存储显著性检验的P值结果
    
    r_corData[[index]]=c(round(r_tmp1,2),round(r_tmp2,2),dataList[[i]][1,5])
    p_corData[[index]]=c(round(p_tmp1,2),round(p_tmp2,2),dataList[[i]][1,5])
    
    index=index+1
  }

}

number=0
for(i in 1:length(r_corData)){
  if(r_corData[[i]][1]<0.8 && r_corData[[i]][2]<0.01){
    print(paste(as.character(r_corData[[i]][3])," r is ",as.character(r_corData[[i]][1])," p is ",as.character(r_corData[[i]][2])))
    
    number=number+1
  }
  
}

print(number)

#------------------------------------上下游道路空间信息-----------------------------------######################
sourceData=read.csv("D:/DeskTop/traffic_data.csv")
str(sourceData)

notebook=rep(0,times=nrow(sourceData))
for(i in 1:nrow(sourceData)){
  if(sourceData$flow[i]*sourceData$speed[i]==0 && sourceData$flow[i]!=sourceData$speed[i]){
    notebook[i]=1
  }
}
sourceData=sourceData[-which(notebook==1),]

#-------------------------------------------------------------------------------segment分段
dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}


#-------------------------------------------------------------------------------增加int_time,road_id,seg_id
oldMark=substr(dataList[[1]]$segment[1],1,2)
roadCount=1
segCount=0
for(i in 1:length(dataList)){
  int_time=data.frame(int_time=rep(0,times=nrow(dataList[[i]])))
  road_id=data.frame(road_id=rep(0,times=nrow(dataList[[i]])))
  seg_id=data.frame(seg_id=rep(0,times=nrow(dataList[[i]])))

  newMark=substr(dataList[[i]]$segment[1],1,2)
  if(newMark==oldMark){
    segCount=segCount+1
  }else{
    roadCount=roadCount+1
    segCount=1
  }
  oldMark=newMark
  
  for(j in 1:nrow(dataList[[i]])){
    int_time[j,1]=as.numeric(substr(dataList[[i]]$time[j],1,2))*3600+as.numeric(substr(dataList[[i]]$time[j],4,5))*60+as.numeric(substr(dataList[[i]]$time[j],7,8))
    road_id[j,1]=roadCount
    seg_id[j,1]=segCount
    }
  mtmp1=as.matrix(dataList[[i]])
  mtmp2=as.matrix(int_time)
  mtmp3=as.matrix(road_id)
  mtmp4=as.matrix(seg_id)
  mtmp=cbind(mtmp2,mtmp3,mtmp4,mtmp1)
  dataList[[i]]=as.data.frame(mtmp)
  print(i)
}


#-------------------------------------------------------------------------------将结果写入文件
TimeResult=data.frame(int_time=rep(0,times=nrow(sourceData)),road_id=rep(0,times=nrow(sourceData)),seg_id=rep(0,times=nrow(sourceData)),segment=rep(0,times=nrow(sourceData)),time=rep(0,times=nrow(sourceData)),flow=rep(0,times=nrow(sourceData)),speed=rep(0,times=nrow(sourceData)))
head=0
tail=0
for(i in 1:length(dataList)){
  tail=tail+nrow(dataList[[i]])
  for(j in 1:nrow(dataList[[i]])){
      TimeResult[head+j,1]=dataList[[i]]$int_time[j]
      TimeResult[head+j,2]=dataList[[i]]$road_id[j]
      TimeResult[head+j,3]=dataList[[i]]$seg_id[j]
      TimeResult[head+j,4]=dataList[[i]]$segment[j]
      TimeResult[head+j,5]=dataList[[i]]$time[j]
      TimeResult[head+j,6]=dataList[[i]]$flow[j]
      TimeResult[head+j,7]=dataList[[i]]$speed[j]
  }
  head=head+nrow(dataList[[i]])
  print(i)
}

library(dplyr)
write.csv(TimeResult,"D:/DeskTop/TimeResult1.csv",row.names = FALSE)


#------------------------------------------------------------------------------------------增加方差

sourceData=read.csv("D:/DeskTop/TimeResult.csv")
str(sourceData)

#-------------------------------------------------------------------------------segment分段
dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}
#-------------------------------------------------------------------------------自身路段上的方差
gap=10
len=gap%/%2
VAR_flow=data.frame(var_flow=rep(-1,times=nrow(sourceData)))
VAR_speed=data.frame(var_speed=rep(-1,times=nrow(sourceData)))
flag=0

for(i in 1:length(dataList)){
  notebook=rep(-1,times=len)
  for(j in 1:nrow(dataList[[i]])){
    
    valid=TRUE
    currentTime=dataList[[i]]$int_time[j]
    
    for(k in 1:length(notebook)){
      if(valid==TRUE && gap>=2*k){
        if(k==1){
          notebook[k]=currentTime-2
        }else{
          notebook[k]=notebook[k-1]-2
        }
        if(notebook[k]<0){
          notebook[k]=1438
        }
        if(length(which(dataList[[i]]$int_time==notebook[k]))==0){
          valid=FALSE
          notebook[k]=-1
          break
        }
      }
    }
    
    
    if(length(which(notebook==-1))==0){
      for(m in 1:len) {
        timeIndex=notebook[m]
        notebook[m]=(which(dataList[[i]]$int_time==timeIndex))
      }
      num_flow=rep(0,times=len+1)
      num_speed=rep(0,times=len+1)
      for(n in 1:len){
        num_flow[n]=dataList[[i]]$flow[notebook[n]]
        num_speed[n]=dataList[[i]]$speed[notebook[n]]
      }
      num_flow[len+1]=dataList[[i]]$flow[j]
      num_speed[len+1]=dataList[[i]]$speed[j]
      VAR_flow$var_flow[flag+j]=var(num_flow)
      VAR_speed$var_speed[flag+j]=var(num_speed)
    }
  }
  flag=flag+nrow(dataList[[i]])
  print(i)
}

library(dplyr)
write.csv(VAR_flow,"D:/DeskTop/VAR_flow_6.csv",row.names = FALSE)
write.csv(VAR_speed,"D:/DeskTop/VAR_speed_6.csv",row.names = FALSE)

#-------------------------------------------------------------------------------包含上下游路段的方差
UP_flow=data.frame(up_flow=rep(-1,times=nrow(sourceData)))
UP_speed=data.frame(up_speed=rep(-1,times=nrow(sourceData)))
flag=0

for(i in 1:length(dataList)){
  len=nrow(dataList[[i]])
  if(i!=1 && (dataList[[i]]$segment[1]-1)==(dataList[[i-1]]$segment[1])){
    for(j in 1:len){
      if(length(which(dataList[[i-1]]$int_time==dataList[[i]]$int_time[j]))!=0){
        timeIndex=which(dataList[[i-1]]$int_time==dataList[[i]]$int_time[j])
        UP_flow$up_flow[flag+j]=dataList[[i-1]]$flow[timeIndex]
        UP_speed$up_speed[flag+j]=dataList[[i-1]]$speed[timeIndex]
      }
      
    }
  }
  flag=flag+len
  print(i)
}

library(dplyr)
write.csv(UP_flow,"D:/DeskTop/UP_flow.csv",row.names = FALSE)
write.csv(UP_speed,"D:/DeskTop/UP_speed.csv",row.names = FALSE)




DOWN_flow=data.frame(down_flow=rep(-1,times=nrow(sourceData)))
DOWN_speed=data.frame(down_speed=rep(-1,times=nrow(sourceData)))
flag=0

for(i in 1:length(dataList)){
  len=nrow(dataList[[i]])
  if(i!=length(dataList) && (dataList[[i]]$segment[1]+1)==(dataList[[i+1]]$segment[1])){
    for(j in 1:len){
      if(length(which(dataList[[i+1]]$int_time==dataList[[i]]$int_time[j]))!=0){
        timeIndex=which(dataList[[i+1]]$int_time==dataList[[i]]$int_time[j])
        DOWN_flow$down_flow[flag+j]=dataList[[i+1]]$flow[timeIndex]
        DOWN_speed$down_speed[flag+j]=dataList[[i+1]]$speed[timeIndex]
      }
      
    }
  }
  flag=flag+len
  print(i)
}

library(dplyr)
write.csv(DOWN_flow,"D:/DeskTop/DOWN_flow.csv",row.names = FALSE)
write.csv(DOWN_speed,"D:/DeskTop/DOWN_speed.csv",row.names = FALSE)



sourceData=read.csv("D:/DeskTop/UP_flow.csv")
str(sourceData)

#-------------------------------------------------------------------------------segment分段
dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}
#-------------------------------------------------------------------------------方差

gap=10
len=gap%/%2
VAR_SPACE_flow=data.frame(var_space_flow=rep(-1,times=nrow(sourceData)))
VAR_SPACE_speed=data.frame(var_space_speed=rep(-1,times=nrow(sourceData)))
flag=0

for(i in 1:length(dataList)){
  notebook=rep(-1,times=len)
  for(j in 1:nrow(dataList[[i]])){
    
    valid=TRUE
    currentTime=dataList[[i]]$int_time[j]
    
    for(k in 1:length(notebook)){
      if(valid==TRUE && gap>=2*k){
        if(k==1){
          notebook[k]=currentTime-2
        }else{
          notebook[k]=notebook[k-1]-2
        }
        if(notebook[k]<0){
          notebook[k]=1438
        }
        if(length(which(dataList[[i]]$int_time==notebook[k]))==0){
          valid=FALSE
          notebook[k]=-1
          break
        }
      }
    }
    
    
    if(length(which(notebook==-1))==0){
      for(m in 1:len) {
        timeIndex=notebook[m]
        notebook[m]=(which(dataList[[i]]$int_time==timeIndex))
      }
      repCount=3*(len+1)
      num_flow=rep(0,times=repCount)
      num_speed=rep(0,times=repCount)
      for(n in 1:len){
        num_flow[3*(n-1)+1]=dataList[[i]]$flow[notebook[n]]
        num_flow[3*(n-1)+2]=dataList[[i]]$up_flow[notebook[n]]
        num_flow[3*(n-1)+3]=dataList[[i]]$down_flow[notebook[n]]
        
        num_speed[3*(n-1)+1]=dataList[[i]]$speed[notebook[n]]
        num_speed[3*(n-1)+2]=dataList[[i]]$up_speed[notebook[n]]
        num_speed[3*(n-1)+3]=dataList[[i]]$down_speed[notebook[n]]
      }
      num_flow[3*len+1]=dataList[[i]]$flow[j]
      num_flow[3*len+2]=dataList[[i]]$up_flow[j]
      num_flow[3*len+3]=dataList[[i]]$down_flow[j]
      
      num_speed[3*len+1]=dataList[[i]]$speed[j]
      num_speed[3*len+2]=dataList[[i]]$up_speed[j]
      num_speed[3*len+3]=dataList[[i]]$down_speed[j]
      
      space_flow=num_flow[which(num_flow!=-1)]
      space_speed=num_speed[which(num_speed!=-1)]
      
      VAR_SPACE_flow$var_space_flow[flag+j]=var(space_flow)
      VAR_SPACE_speed$var_space_speed[flag+j]=var(space_speed)
    }
  }
  flag=flag+nrow(dataList[[i]])
  print(i)
}

library(dplyr)
write.csv(VAR_SPACE_flow,"D:/DeskTop/VAR_SPACE_flow_10.csv",row.names = FALSE)
write.csv(VAR_SPACE_speed,"D:/DeskTop/VAR_SPACE_speed_10.csv",row.names = FALSE)


#-------------------------------------------------------------------------------简单差值
sourceData=read.csv("D:/DeskTop/UP_flow.csv")
str(sourceData)

#-------------------------------------------------------------------------------segment分段
dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}
#-------------------------------------------------------------------------------方差
gap=2
len=gap%/%2
DIFF_flow=data.frame(diff_flow=rep(-1,times=nrow(sourceData)))
DIFF_speed=data.frame(diff_speed=rep(-1,times=nrow(sourceData)))
flag=0

for(i in 1:length(dataList)){
  notebook=rep(-1,times=len)
  for(j in 1:nrow(dataList[[i]])){
    
    valid=TRUE
    currentTime=dataList[[i]]$int_time[j]
    
    for(k in 1:length(notebook)){
      if(valid==TRUE && gap>=2*k){
        if(k==1){
          notebook[k]=currentTime-2
        }else{
          notebook[k]=notebook[k-1]-2
        }
        if(notebook[k]<0){
          notebook[k]=1438
        }
        if(length(which(dataList[[i]]$int_time==notebook[k]))==0){
          valid=FALSE
          notebook[k]=-1
          break
        }
      }
    }
    
    
    if(length(which(notebook==-1))==0){
      for(m in 1:len) {
        timeIndex=notebook[m]
        notebook[m]=(which(dataList[[i]]$int_time==timeIndex))
      }
      num_flow=rep(0,times=len)
      num_speed=rep(0,times=len)
      for(n in 1:len){
        num_flow[n]=dataList[[i]]$flow[notebook[n]]
        num_speed[n]=dataList[[i]]$speed[notebook[n]]
      }

      DIFF_flow$diff_flow[flag+j]=dataList[[i]]$flow[j]-mean(num_flow)
      DIFF_speed$diff_speed[flag+j]=dataList[[i]]$speed[j]-mean(num_speed)
    }
  }
  flag=flag+nrow(dataList[[i]])
  print(i)
}

library(dplyr)
write.csv(DIFF_flow,"D:/DeskTop/DIFF_flow_2.csv",row.names = FALSE)
write.csv(DIFF_speed,"D:/DeskTop/DIFF_speed_2.csv",row.names = FALSE)


#-------------------------------------------------------------------------------############Kalman差值
sourceData=read.csv("D:/DeskTop/Kalman.csv")
str(sourceData)

#-------------------------------------------------------------------------------segment分段
dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}
#-------------------------------------------------------------------------------Kalman

library(FKF)


Kalman_flow=data.frame(kalman_flow=rep(-1,times=nrow(sourceData)))
flag=0

for(b in 1:length(dataList)){
  
  
  head=1
  tail=1
  len=nrow(dataList[[b]])
  
  if(b==168 || b==189 || b==190 || b==200){
    flag=flag+len
    next
  }
  
  while(tail<(len-1)){
    for(j in head:(len-1)){
      if((dataList[[b]]$int_time[j]+10)<dataList[[b]]$int_time[j+1]){
        tail=j
      }
      if(j==len-1){
        tail=len
      }
    }
    
    y = dataList[[b]]$speed[head:tail]    
    
    ## Set constant parameters:
    notebook=rep(0,times=length(y))
    for(i in 1:length(y)){
      if(y[i] %% 2 == 1){
        y[i] = y[i]+1
        notebook[i]=1
      }
    }
    dt = ct = matrix(0) 
    Zt = Tt = matrix(1)
    a0 = y[1]          # Estimation of the first year flow 
    P0 = matrix((y[1]+mean(y))%/%2)     # Variance of 'a0'
    
    ## Estimate parameters:
    fit.fkf <- optim(c(HHt = var(y, na.rm = TRUE) * .5,
                       GGt = var(y, na.rm = TRUE) * .5),
                     fn = function(par, ...)
                       -fkf(HHt = matrix(par[1]), GGt = matrix(par[2]), ...)$logLik,
                     yt = rbind(y), a0 = a0, P0 = P0, dt = dt, ct = ct,
                     Zt = Zt, Tt = Tt)
    
    ## Filter Nile data with estimated parameters:
    fkf.obj = fkf(a0, P0, dt, ct, Tt, Zt, HHt = matrix(fit.fkf$par[1]),
                  GGt = matrix(fit.fkf$par[2]), yt = rbind(y))
    
    for(i in 1:length(notebook)){
      if(notebook[i]==1){
        fkf.obj$att[1, ][i]=fkf.obj$att[1, ][i]-1
      }
    }
    ## Compare with the stats' structural time series implementation:
    fit.stats = StructTS(y, type = "level")
    
    fit.fkf$par
    fit.stats$coef
    
    ## Plot the flow data together with fitted local levels:
    setwd("D:/DeskTop/test")
    png(file = paste(as.character(b*1000+head),".png"), width = 800, height = 600)
    plot(y, main = "Nile flow")
    lines(fitted(fit.stats), col = "green")
    lines(ts(fkf.obj$att[1, ], start = start(y), frequency = frequency(y)), col = "blue")
    legend("top", c("Nile flow data", "Local level (StructTS)", "Local level (fkf)"),
           col = c("black", "green", "blue"), lty = 1)
    dev.off()
    
    for(a in 1:length(fkf.obj$att[1, ])){
      Kalman_flow$kalman_flow[flag+head+a-1]=fkf.obj$att[1, a]
    }

    head=tail+1
  }
  flag=flag+len
  print(b)
}


library(dplyr)
write.csv(Kalman_flow,"D:/DeskTop/Kal_speed.csv",row.names = FALSE)

sourceData=read.csv("D:/DeskTop/Kalman.csv")
str(sourceData)

Diff_kalman=data.frame(diff_kalman=rep(0,times=nrow(sourceData)))
for(i in 1:nrow(sourceData)){
  if(sourceData$kalman_speed[i]!=-1){
    Diff_kalman$diff_kalman[i]=sourceData$speed[i]-sourceData$kalman_speed[i]
  }
  print(i)
}
library(dplyr)
write.csv(Diff_kalman,"D:/DeskTop/DIFF_kalman.csv",row.names = FALSE)

#-------------------------------------------------------------------------------###is_crash标注
crashData=read.csv("D:/DeskTop/crash_data.csv")
str(crashData)
sourceData=read.csv("D:/DeskTop/Kalman.csv")
str(sourceData)

dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}

LIMIT=4
CRASH=data.frame(crash=rep(0,times=nrow(sourceData)))


for(i in 1:nrow(crashData)){
  seg=crashData$segment[i]
  clock=as.numeric(substr(crashData$starttime[i],1,2))*60+as.numeric(substr(crashData$starttime[i],4,5))
  timeIndex=0
  flag=0
  
  for(j in 1:length(dataList)){
    timeIndex=0
    if(dataList[[j]]$segment[1]==seg){
      timeIndex=which(abs(dataList[[j]]$int_time-clock)<=2)[1]+1
      CRASH$crash[flag+timeIndex]=1
      for(k in 1:(LIMIT%/%2)){
        if(timeIndex-k>0){
          CRASH$crash[flag+timeIndex-k]=1
        }
        if(timeIndex+k<=nrow(dataList[[j]])){
          CRASH$crash[flag+timeIndex+k]=1
        }
      }
      break
    }
    flag=flag+nrow(dataList[[j]])
  }
  print(i)
}

library(dplyr)
write.csv(CRASH,"D:/DeskTop/CRASH.csv",row.names = FALSE)


#-------------------------------------------------------------------------------####预测

sourceData=read.csv("D:/DeskTop/features/8.csv")
str(sourceData)

dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}

PREDICT=data.frame(predict=rep(0,times=nrow(sourceData)))

gap=8
len=gap%/%2
PREDICT=data.frame(predict=rep(0,times=nrow(sourceData)))
flag=0

for(i in 1:length(dataList)){
  notebook=rep(-1,times=len)
  for(j in 1:nrow(dataList[[i]])){
    
    valid=TRUE
    currentTime=dataList[[i]]$int_time[j]
    
    for(k in 1:length(notebook)){
      if(valid==TRUE && gap>=2*k){
        if(k==1){
          notebook[k]=currentTime+2
        }else{
          notebook[k]=notebook[k-1]+2
        }
        if(notebook[k]>1438){
          notebook[k]=0
        }
        if(length(which(dataList[[i]]$int_time==notebook[k]))==0){
          valid=FALSE
          notebook[k]=-1
          break
        }
      }
    }
    
    
    if(length(which(notebook==-1))==0){
      for(m in 1:len) {
        timeIndex=notebook[m]
        notebook[m]=(which(dataList[[i]]$int_time==timeIndex))
      }
      num_flow=rep(0,times=len)
      for(n in 1:len){
        num_flow[n]=dataList[[i]]$result_flow[notebook[n]]
      }
      if(length(which(num_flow<=-45))>=1){
        PREDICT$predict[flag+j]=1
        PREDICT$predict[flag+j+1]=1
        PREDICT$predict[flag+j+2]=1
      }
    }
  }
  flag=flag+nrow(dataList[[i]])
  print(i)
}

library(dplyr)
write.csv(PREDICT,"D:/DeskTop/PREDICT.csv",row.names = FALSE)



#-------------------------------------------------------------------------------指标评估
sourceData=read.csv("D:/DeskTop/features/8.csv")
str(sourceData)

CHECK=data.frame(check=rep('0',times=nrow(sourceData)))
for(i in 1:nrow(sourceData)){
  if(sourceData$crash[i]==0 && sourceData$predict[i]==0){
    CHECK$check[i]='TP'
  }
  else if(sourceData$crash[i]==0 && sourceData$predict[i]==1){
    CHECK$check[i]='FN'
  }
  else if(sourceData$crash[i]==1 && sourceData$predict[i]==0){
    CHECK$check[i]='FP'
  }
  else if(sourceData$crash[i]==1 && sourceData$predict[i]==1){
    CHECK$check[i]='TN'
  }
  print(i)
}

library(dplyr)
write.csv(CHECK,"D:/DeskTop/CHECK.csv",row.names = FALSE)

#--------------------计算准确率Accuracy
TPnum=length(which(CHECK=='TP'))
FPnum=length(which(CHECK=='FP'))
FNnum=length(which(CHECK=='FN'))
TNnum=length(which(CHECK=='TN'))

acc=(TPnum+TNnum)/(TPnum+TNnum+FPnum+FNnum)
precision=(TPnum)/(TPnum+FPnum)
recall=(TPnum)/(TPnum+FNnum)
F1=(2*precision*recall)/(precision+recall)
FAR=1-(TNnum/(FPnum+TNnum))

acc

precision

recall

F1

FAR
#-------------------------------------------------------------------------------调节参数
sourceData=read.csv("D:/DeskTop/Kalman.csv")
str(sourceData)

RESULT=data.frame(result=rep(0,times=nrow(sourceData)))
for(i in 1:nrow(sourceData)){
  if(sourceData$result_flow[i]<0 && sourceData$result_speed_2[i]!=0){
    RESULT$result[i]=abs(sourceData$result_flow[i]/sourceData$result_speed_2[i])
  }
  print(i)
}
for(d in 1:length(RESULT$result)){
  if(RESULT$result[d]>-18){
    RESULT$result[d]=0
  }
  print(d)
}
library(dplyr)
write.csv(RESULT,"D:/DeskTop/RESULT.csv",row.names = FALSE)




#-------------------------------------------------------------------------------time_id

sourceData=read.csv("D:/DeskTop/Kalman.csv")
str(sourceData)

TIMEID=data.frame(time_id=rep(0,times=nrow(sourceData)))
for(i in 1:nrow(sourceData)){
  if(sourceData$int_time[i]>=480 && sourceData$int_time[i]<=1200){
    TIMEID$time_id[i]=1
  }
  print(i)
}
library(dplyr)
write.csv(TIMEID,"D:/DeskTop/time_id.csv",row.names = FALSE)

#-------------------------------------------------------------------------------test
sourceData=read.csv("D:/DeskTop/features/6.csv")
POLD=data.frame(p_old=rep(0,times=nrow(sourceData)))
PNEW=data.frame(p_new=rep(0,times=nrow(sourceData)))
for(i in 1:nrow(sourceData)){
  if(TRUE){
    POLD$p_old[i]=sourceData$var_p_old_4[i]-sourceData$var_p_old_2[i]
  }
  if(TRUE){
    PNEW$p_new[i]=sourceData$var_p_new_4[i]-sourceData$var_p_new_2[i]
  }
  print(i)
}
library(dplyr)
write.csv(POLD,"D:/DeskTop/pold.csv",row.names = FALSE)
write.csv(PNEW,"D:/DeskTop/pnew.csv",row.names = FALSE)

sourceData=read.csv("D:/DeskTop/features/6.csv")
str(sourceData)

#-------------------------------------------------------------------------------segment分段
dataList=NULL
count=1
head=1
for(i in 1:nrow(sourceData)){
  if(i!=1){
    if(sourceData$segment[i]!=sourceData$segment[i-1]){
      tail=i-1
      dataList[[count]]=sourceData[head:tail,]
      count=count+1
      head=i
    }
    if(i==nrow(sourceData)){
      tail=i
      dataList[[count]]=sourceData[head:tail,]
    }
  }
}
#-------------------------------------------------------------------------------方差
gap=4
len=gap%/%2
DIFF_flow=data.frame(diff_flow=rep(-1,times=nrow(sourceData)))
DIFF_speed=data.frame(diff_speed=rep(-1,times=nrow(sourceData)))
flag=0

for(i in 1:length(dataList)){
  notebook=rep(-1,times=len)
  for(j in 1:nrow(dataList[[i]])){
    
    valid=TRUE
    currentTime=dataList[[i]]$int_time[j]
    
    for(k in 1:length(notebook)){
      if(valid==TRUE && gap>=2*k){
        if(k==1){
          notebook[k]=currentTime-2
        }else{
          notebook[k]=notebook[k-1]-2
        }
        if(notebook[k]<0){
          notebook[k]=1438
        }
        if(length(which(dataList[[i]]$int_time==notebook[k]))==0){
          valid=FALSE
          notebook[k]=-1
          break
        }
      }
    }
    
    
    if(length(which(notebook==-1))==0){
      for(m in 1:len) {
        timeIndex=notebook[m]
        notebook[m]=(which(dataList[[i]]$int_time==timeIndex))
      }
      num_flow=rep(0,times=len+1)
      num_speed=rep(0,times=len+1)
      for(n in 1:len){
        num_flow[n]=dataList[[i]]$p_old[notebook[n]]
        num_speed[n]=dataList[[i]]$p_new[notebook[n]]
      }
      num_flow[len+1]=dataList[[i]]$p_old[j]
      num_speed[len+1]=dataList[[i]]$p_new[j]
      
      DIFF_flow$diff_flow[flag+j]=var(num_flow)
      DIFF_speed$diff_speed[flag+j]=var(num_speed)
    }
  }
  flag=flag+nrow(dataList[[i]])
  print(i)
}

library(dplyr)
write.csv(DIFF_flow,"D:/DeskTop/DIFF_OLD_2.csv",row.names = FALSE)
write.csv(DIFF_speed,"D:/DeskTop/DIFF_NEW_2.csv",row.names = FALSE)


#########################################################################################
sourceData=read.csv("D:/DeskTop/features/8.csv")
str(sourceData)


LIMIT=8
CRASH=data.frame(crash=rep(0,times=nrow(sourceData)))
flag=0
for(i in 1:nrow(sourceData)){
  if(sourceData$is_crash[i]==1){
    CRASH$crash[i]=1
    for (j in 1:(LIMIT%/%2)) {
      CRASH$crash[i-j]=1
    }
  }
  print(i)
}

write.csv(CRASH,"D:/DeskTop/CRASH.csv",row.names = FALSE)

#-------------------------------------------------------------------------预测分类
sourceData=read.csv("D:/DeskTop/features/8.csv")
str(sourceData)


LIMIT=4
CRASH=data.frame(crash=rep(0,times=nrow(sourceData)))
flag=0
for(i in 1:nrow(sourceData)){
  if(sourceData$result_flow[i]<0){
    CRASH$crash[i]=1
    for (j in 1:(LIMIT%/%2)) {
      CRASH$crash[i+j]=1
    }
  }
  print(i)
}

write.csv(CRASH,"D:/DeskTop/PREDICT.csv",row.names = FALSE)

