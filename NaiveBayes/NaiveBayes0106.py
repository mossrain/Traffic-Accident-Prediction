import pandas as pd
import matplotlib.pyplot as plt
from imblearn.under_sampling import RandomUnderSampler
from sklearn.naive_bayes import GaussianNB
import seaborn as sns
from sklearn.metrics import precision_score, recall_score, f1_score, roc_curve, accuracy_score, roc_auc_score, auc
from sklearn.model_selection import train_test_split

data = pd.read_csv('../featured_dataset.csv')

x = data.drop(['id', 'segment', 'is_crash'], axis=1)
y = data['is_crash']

# 1:1划分训练集测试集
x_train, x_test, y_train, y_test = train_test_split(x,
                                                 y,
                                                    test_size=0.5,
                                                    stratify=y,
                                                    random_state=20230105)

# 随机欠采样
print(y_train.value_counts())
print(y_test.value_counts())
rus = RandomUnderSampler(sampling_strategy={0: 129, 1: 129}, random_state=2023)
x_train, y_train = rus.fit_resample(x_train, y_train)

# 构建朴素贝叶斯预测模型
model_NB = GaussianNB()
model_NB.fit(x_train, y_train)
yuce = model_NB.predict(x_test)

# 输出模型评价指标
precision = precision_score(y_test, yuce, average='weighted')
recall = recall_score(y_test, yuce, average='weighted')
f1score = f1_score(y_test, yuce, average='weighted')
accuracy = accuracy_score(y_test, yuce)
y1_test_score = model_NB.predict_proba(x_test)
fpr, tpr, thresholds = roc_curve(y_test, y1_test_score[:, 1])
AUC = auc(fpr, tpr)
print("AUC:      ", '%.4f' % float(AUC))
print("Accuracy: ", '%.4f' % float(accuracy))
print("Precision:", '%.4f' % float(precision))
print("Recall:   ", '%.4f' % float(recall))
print("f1_score：", '%.4f' % float(f1score))

# 绘制混淆矩阵
plt.figure(dpi=300, figsize=(3, 3))
cm = pd.crosstab(yuce, y_test)
cm = pd.DataFrame(cm)
sns.heatmap(cm, annot=True, fmt='.5g')
plt.xlabel('Real Label')
plt.ylabel('Predict Label')
plt.tight_layout()
plt.savefig('Confusion Matrix.png', dpi=300)
plt.show()

# 绘制ROC曲线
def roc_curve_and_score(y_train, pred_proba):
    fpr, tpr, _ = roc_curve(y_train.ravel(), pred_proba.ravel())
    roc_auc = roc_auc_score(y_train.ravel(), pred_proba.ravel())
    return fpr, tpr, roc_auc
plt.figure(figsize=(6, 4), dpi=150)
plt.grid()
fpr, tpr, roc_auc = roc_curve_and_score(y_test, model_NB.predict_proba(x_test)[:, 1])
plt.plot(fpr, tpr, lw=1.5,
         label='AUC GaussianNB={0:.4f}'.format(roc_auc))

plt.plot([0, 1], [0, 1], lw=1, linestyle='--')
plt.legend(loc="lower right", fontsize=13)
plt.title('ROC Curve')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.0])
plt.xlabel('FPR')
plt.ylabel('TPR')
plt.savefig('ROC Curve.png', dpi=300)
plt.show()
