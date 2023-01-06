# TrafficAccidentPrediction
同济大学软件学院统计分析与建模期末项目

## 数据集说明
1. contrast_sampled_dataset.csv 对照采样数据集
2. crash_data.csv 原数据
3. featured_dataset.csv 最终版的特征工程结果
4. traffic_data.csv 原数据

## 数据预处理

## 数据可视化
1. visualize.py  对应pictures
2. visualize_2.py对应pictures_2
3. visualize_3.py对应pictures_3
4. preprocess_1.py 将is_crash添加到traffic_data, time转秒数
5. preprocess_3.py 删除缺失值
6. preprocess_2.py 提取特征
（4.5.6做可视化用，最后的建模没有使用这个版本的特征工程）

## kalman+arima


## 非条件逻辑回归说明（common_logistic）
1. split_dataset.py（病例对照采样）
2. logistic.py (逻辑回归py版本，并生成r版本需要用的r_dataset.csv)
3. common_logistic.rmd（逻辑回归r版本）

## 条件逻辑回归说明（conditional_logistic）
1. logistic_test1.R为测试版本
2. logistic-final.R为最终建模版本

## 朴素贝叶斯说明（NaiveBayes)
2. NaiveBayes0106.py 最终建模版本






