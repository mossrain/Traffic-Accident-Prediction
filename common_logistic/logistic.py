# 2. 简单逻辑回归

import pandas as pd
import numpy as np
from sklearn import preprocessing
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
import random
from sklearn.utils import shuffle
from sklearn.metrics import confusion_matrix


data=pd.read_csv(r'dataset.csv')

# data=data.drop(columns=['Unnamed: 0.3','Unnamed: 0.2', 'Unnamed: 0.1', 'Unnamed: 0','road_id','seg_id'])
data=data.drop(columns=['time','Unnamed: 0','Unnamed: 0.1'])

is_crash=data["is_crash"].values
noacc=0
hasacc=0
for i in range(0,len(data)):
    data["segment"].values[i]=int(data["segment"].values[i])%1000
    if is_crash[i]==0:
        noacc+=1
    else:
        hasacc+=1
    
print('dataset对照/事故=',float(noacc)/float(hasacc))
print('全部预测为非事故的准确率=',float(noacc)/float(hasacc+noacc))


columns = list(data)
columns.insert(0, columns.pop(columns.index('is_crash')))
data= data.loc[:, columns]
# print(data.columns)

X = data.iloc[:,1:]
y = data.iloc[:,0]

column_num=len(X.columns)
# X_1=X.iloc[:,column_num-2:]
# X_2=X.iloc[:,0:column_num-2]
# X_2 = (X_2-X_2.min())/(X_2.max()-X_2.min())#简单实现标准化
# X = (X-X.min())/(X.max()-X.min())#简单实现标准化

# x1_col=X_1.columns.values

# X_1 = pd.get_dummies(X_1,columns=x1_col)
# print(X_1)
# print(X_2)

# X=pd.concat([X_1,X_2],axis=1)
X_train, X_test, y_train, y_test = train_test_split(X,y,random_state=0,test_size=0.3)

print(X_train)
print(X_test)
classifier = LogisticRegression(random_state=0,max_iter=100)
classifier.fit(X_train, y_train)

y_pred = classifier.predict(X_test)

confusion_matrix = confusion_matrix(y_test, y_pred)

tp=confusion_matrix[0][0]
fp=confusion_matrix[0][1]
fn=confusion_matrix[1][0]
tn=confusion_matrix[1][1]


print(confusion_matrix)
precision=float(tp)/float(tp+fp)
recall=float(tp)/float(tp+fn)
f1=2*precision*recall/(precision+recall)
acc=float(tp+tn)/float(fp+fn+tp+tn)
print("precision:",precision," recall:",recall," f1_measure:",f1," accucacy:",acc)
print('Accuracy of logistic regression classifier on test set: {:.2f}'.format(classifier.score(X_test, y_test)))


# 输出到r_dataset
r_dataset=pd.concat([X,y],axis=1)
# print(r_dataset)
r_dataset.to_csv(r'../contrast_sampled_dataset.csv')




