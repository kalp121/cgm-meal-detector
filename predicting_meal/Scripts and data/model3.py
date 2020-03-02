import numpy as np
import pandas as pd
from sklearn.model_selection import KFold
from sklearn import metrics
import random


def predict():
	
	#read csv data-----------------------------------------------------------------
	df = pd.read_csv('meal_final.csv',header=None)
	test_data=pd.read_csv('test_data.csv',header=None)
	df = df.sample(frac=1).reset_index(drop=True)
	
	X = df.iloc[:, 0:5].values
	y = df.iloc[:, 5].values
	test_data=test_data.iloc[:, 0:5].values
	
	# Feature Scaling
	from sklearn.preprocessing import StandardScaler
	
	#model-1 Random Forest---------------------------------------------------------
	cm_1=[]
	f1_1=[]
	precision_1=[]
	recall_1=[]
	accuracy_1=[]
	test_len=len(test_data)
	ypred_zero=[0]*test_len
	ypred_one=[0]*test_len
	ypred2=[0]*test_len
	
	from keras.models import Sequential
	from keras.layers import Dense
	
	classifier = Sequential()
	classifier.add(Dense(units = 32, kernel_initializer = 'uniform', activation = 'relu', input_dim = 5))
	classifier.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))
	classifier.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics = ['accuracy'])
	
	cv = KFold(n_splits=10, random_state=0, shuffle=False)
	for train_index, test_index in cv.split(X):
	   
	
	    X_train, X_test, y_train, y_test = X[train_index], X[test_index], y[train_index], y[test_index]
		
	    sc = StandardScaler()
	    X_train = sc.fit_transform(X_train)
	    X_test = sc.transform(X_test)
	    testdata=sc.transform(test_data)
		
	    classifier.fit(X_train, y_train, batch_size = 1, epochs = 25)
	    y_pred1 = classifier.predict(X_test)
	    y_pred1 = (y_pred1 > 0.5)
	    y_pred = classifier.predict(testdata)
	    y_pred = (y_pred > 0.5)
	    for i in range(test_len):
	        if y_pred[i]==0:ypred_zero[i]=ypred_zero[i]+1
	        else: ypred_one[i]=ypred_one[i]+1
    
	    cm_1.append(metrics.confusion_matrix(y_test, y_pred1))
	    f1_1.append(metrics.f1_score(y_test,y_pred1))
	    precision_1.append(metrics.precision_score(y_test,y_pred1))
	    recall_1.append(metrics.recall_score(y_test,y_pred1))
	    accuracy_1.append(metrics.accuracy_score(y_test,y_pred1))	
		
	for i in range(test_len):
		if ypred_zero[i]==ypred_one[i]:
			ypred2[i]=random.randint(0,1)
		elif ypred_zero[i]>ypred_one[i]:
			ypred2[i]=0
		else:
			ypred2[i]=1 
	    
	f1=np.mean(f1_1)
	precision=np.mean(precision_1)
	recall=np.mean(recall_1)
	accuracy=np.mean(accuracy_1)
	#print('f1',f1,'precision',precision,'recall',recall,'accuracy',accuracy)
	
	return ypred2

# Call to the function------------------------------------------------------------------------

answer=predict()