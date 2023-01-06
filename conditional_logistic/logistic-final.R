# setwd("E:\\PROGRAM\\R\\yjy-logistic")
list.files()
rm(list = ls())
library(survival)
library(tidyverse)
library(lubridate)
library(caret)
library(pROC)#ROC曲线函数

df_all<-read_csv("../contrast_sampled_dataset.csv")[,-1]
summary(df_all)
set.seed(5210)
num<- createDataPartition(df_all$is_crash, p = 0.3, list = FALSE)
df_test <- df_all[num,]
df_train <- df_all[-num,]

# 4、在训练集上构建模型---------------
clg <- clogit(is_crash~.,data = df_train )
summary(clg)

# 5、在测试集上验证模型-------------

df_test$predoct=exp(0.0173950*df_test$time_id-0.0821578*df_test$road_id+
                    0.0039047*df_test$segment+
                      0.0093737*df_test$flow
                      -0.0449380*df_test$speed
                    -0.0001031*df_test$var_flow_8+
                      0.0039730*df_test$var_speed_8-
                      -0.0001290*df_test$var_space_flow_8+
                      0.0026929*df_test$var_space_speed_8-
                      0.0152194*df_test$diff_flow_8+
                      0.0525622*df_test$diff_speed_8-
                      0.0095031*df_test$diff_kalman_flow+
                      0.0033387*df_test$diff_kalman_speed+
                      0.0051230*df_test$result_flow)# 根据公式6计算OR值

# 6、模型性能-------------
HH <- roc(df_test$is_crash,df_test$predoct) # 绘制ROC曲线
plot(HH)
#计算AUC
HH$auc
#混淆矩阵
table(as.numeric(df_test$predoct>2.206),df_test$is_crash)
mean(as.numeric(df_test2$predoct>2.206)==df_test2$crash)
#计算accuracy
data1<-as.data.frame(table(as.numeric(df_test$predoct>2.206),df_test$is_crash))
accuracy<-(data1$Freq[1]+data1$Freq[4])/(sum(data1$Freq))
accuracy
#计算precision
precision<-data1$Freq[1]/(data1$Freq[1]+data1$Freq[2])
precision
#计算召回率
re_call<-data1$Freq[1]/(data1$Freq[1]+data1$Freq[3])
re_call
#计算F1score
F1_score<-2*re_call*precision/(re_call+precision)
F1_score

