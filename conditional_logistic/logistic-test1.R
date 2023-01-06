# setwd("E:\\PROGRAM\\R\\yjy-logistic")
library(survival)
library(tidyverse)
library(lubridate)
library(pROC)#ROC曲线函数

# 1、病例为车祸发生那一小时，对照为车祸发生那天其他时间的车流量------
df_crash <- read.csv("../crash_data.csv") %>% 
  mutate(
    Time=as.numeric(str_split(starttime,":",simplify = T)[,1]),
    Key=str_c(segment,Time,sep="-"),
    crash=1
  ) %>% 
  select(-2,-3,-Time)

df_traffic <- read.csv("../traffic_data.csv") %>% 
  mutate(
    Time=as.numeric(str_split(time,":",simplify = T)[,1]),
    Key=str_c(segment,Time,sep="-")
  ) %>% 
  filter(segment %in% df_crash$segment) %>% 
  group_by(Key) %>% 
  summarise(
    speed=mean(speed,na.rm = T),
    flow=mean(flow,na.rm=T),
    segment=mean(segment)
  )
df_all <- df_traffic %>% left_join(df_crash) %>% 
  mutate(crash=replace_na(crash,0))

# 2、将 speed,flow中的大于media+3倍IQR的转化为media+3倍IQR---------
df_all$speed[df_all$speed>median(df_all$speed)+3*IQR(df_all$speed)] <- median(df_all$speed)+3*IQR(df_all$speed)
df_all$flow[df_all$flow>median(df_all$flow)+3*IQR(df_all$flow)] <- median(df_all$flow)+3*IQR(df_all$flow)

# 3、将数据拆分为训练集和测试集,3/7分---------
set.seed(5210)
num <- sample(unique(df_all$segment),length(unique(df_all$segment))*0.7,replace = F)
df_train <- df_all[df_all$segment%in%num,]
df_test <- df_all[!df_all$segment%in%num,]

# 4、在训练集上构建模型---------------
clg <- clogit(crash~speed+flow+strata(segment),data = df_train )
summary(clg)

# 5、在测试集上验证模型-------------
df_test %>% 
  filter(crash==0) %>% 
  group_by(segment) %>% 
  summarise(
    m_flow=mean(flow),
    m_speed=mean(speed)
  ) %>% 
  ungroup() %>% 
  right_join(df_test) %>% 
  mutate(
    flow1=flow-m_flow,
    speed1=speed-m_speed
  )->df_test2

df_test2$predoct=exp(-0.067617*df_test2$speed1+0.008844*df_test2$flow1)# 根据公式6计算OR值

# 6、模型性能-------------
HH <- roc(df_test2$crash,df_test2$predoct) # 绘制ROC曲线
plot(HH)
#计算AUC
HH$auc
#计算预测准确度
plot(HH,print.auc=TRUE, print.ci=TRUE, print.thres=TRUE)
mean(as.numeric(df_test2$predoct>2.206)==df_test2$crash)
#混淆矩阵
table(as.numeric(df_test2$predoct>2.206),df_test2$crash)

