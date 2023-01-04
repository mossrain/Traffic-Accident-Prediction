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
        dataList[[count]]=sourceData[head:tail,c(4,5,6)]
        count=count+1
      }
      head=i
    }
    if(i==nrow(sourceData)){
      if(i-head==719){
        tail=i
        dataList[[count]]=sourceData[head:tail,c(4,5,6)]
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
