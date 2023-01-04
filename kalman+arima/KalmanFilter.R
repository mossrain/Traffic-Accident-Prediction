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




lines=1
kalmanResult=data.frame(segment=rep(0,times=720*124),flow=rep(0,times=720*124),speed=rep(0,times=720*124),is_crash=rep(0,times=720*124))
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
