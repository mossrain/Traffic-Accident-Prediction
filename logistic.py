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

data=data.drop(columns=['Unnamed: 0.3','Unnamed: 0.2', 'Unnamed: 0.1', 'Unnamed: 0'])

# data["road"]=0
# data[""]

is_crash=data["is_crash"].values
noacc=0
hasacc=0
for i in range(0,len(data)):
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
X_train, X_test, y_train, y_test = train_test_split(X,y,random_state=0,test_size=0.3)

X_test = (X_test-X_test.min())/(X_test.max()-X_test.min())#简单实现标准化
X_train = (X_train-X_train.min())/(X_train.max()-X_train.min())#简单实现标准化


print(X_test)
print(y_test)
classifier = LogisticRegression(random_state=0,max_iter=1500)
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






