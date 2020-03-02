%Reading test data -----------------------------------------------------
testdata=csvread('mealData1.csv'); %enter file_name here
testdata=testdata(:,1:30);



topeigens=csvread('top_eigens.csv');

%pre-processing test data -------------------------------------------------

testdata = testdata(all(testdata,2),:);

testdata(sum(isnan(testdata), 2) > 3, :) = [];
%removing row with more than two NAN missing values 

test_data = fillmissing(testdata,'linear',2,'EndValues','nearest');
%Filling NAN missing values with nearest neighbour average
test_data(any(test_data>399,2),:)=[];


%feature creation for test data -------------------------------------------

a=int16(size(test_data,1));
test_feature_matrix=[];
for i=1:a
    
%Feature 1- IQR
meal_feature1=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(test_data(i,:),2) && k<=10)
    meal_feature1{k}=iqr(test_data(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

%Feature 2- Variance Over Window
meal_feature2=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(test_data(i,:),2) && k<=10)
    meal_feature2{k}=var(test_data(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

%feature 3 Kurtosis 

meal_feature3=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(test_data(i,:),2) && k<=10)
    meal_feature3{k}=kurtosis(test_data(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

%feature 4 Skewness
meal_feature4=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(test_data(i,:),2) && k<=10)
    meal_feature4{k}=skewness(test_data(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

meal_feature=[meal_feature1 meal_feature2 meal_feature3 meal_feature4];
test_feature_matrix=[test_feature_matrix;meal_feature];

end

test_feature_matrix=cell2mat(test_feature_matrix);
test_feature_pca=test_feature_matrix*topeigens;

test_feature_pca(sum(isnan(test_feature_pca), 2) > 0, :) = [];
%removing row with more than zero NAN missing values 

writematrix(test_feature_pca,'test_data.csv')


