

%Reading No meal data -----------------------------------------------------

mealdata1=csvread('mealData1.csv');
mealdata1=mealdata1(:,1:30);

mealdata2=csvread('mealData2.csv');
mealdata2=mealdata2(:,1:30);

mealdata3=csvread('mealData3.csv');
mealdata3=mealdata3(:,1:30);

mealdata4=csvread('mealData4.csv');
mealdata4=mealdata4(:,1:30);

mealdata5=csvread('mealData5.csv');
mealdata5=mealdata5(:,1:30);

mealdata= vertcat(mealdata1,mealdata2,mealdata3,mealdata4,mealdata5);

%Reading No meal data------------------------------------------------------
nomeal1=csvread('Nomeal1.csv');
nomeal1=nomeal1(:,1:30);

nomeal2=csvread('Nomeal2.csv');
nomeal2=nomeal2(:,1:30);

nomeal3=csvread('Nomeal3.csv');
nomeal3=nomeal3(:,1:30);

nomeal4=csvread('Nomeal4.csv');
nomeal4=nomeal4(:,1:30);

nomeal5=csvread('Nomeal5.csv');
nomeal5=nomeal5(:,1:30);

nomeal= vertcat(nomeal1,nomeal2,nomeal3,nomeal4,nomeal5);



%pre-processing meal data -------------------------------------------------

mealdata = mealdata(all(mealdata,2),:);

mealdata(sum(isnan(mealdata), 2) > 3, :) = [];
%removing row with more than two NAN missing values 

mealdata_all = fillmissing(mealdata,'linear',2,'EndValues','nearest');
%Filling NAN missing values with nearest neighbour average
mealdata_all(any(mealdata_all>399,2),:)=[];


%pre-processing nomeal data -----------------------------------------------

nomeal = nomeal(all(nomeal,2),:);

nomeal(sum(isnan(nomeal), 2) > 3, :) = [];
%removing row with more than two NAN missing values 

nomealdata_all = fillmissing(nomeal,'linear',2,'EndValues','nearest');
%Filling NAN missing values with nearest neighbour average
nomealdata_all(any(nomealdata_all>399,2),:)=[];
%Merge both data -------------------------------------------
all_data=vertcat(mealdata_all,nomealdata_all);

%feature creation for meal data -------------------------------------------
a=int16(size(mealdata_all,1));
b=int16(size(nomealdata_all,1));
c=int16(size(all_data,1));
meal_feature_matrix=[];
for i=1:c
    
%Feature 1- IQR
meal_feature1=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(all_data(i,:),2) && k<=10)
    meal_feature1{k}=iqr(all_data(floor(i),floor(start):floor(end1)));
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
while(end1<= size(all_data(i,:),2) && k<=10)
    meal_feature2{k}=var(all_data(floor(i),floor(start):floor(end1)));
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
while(end1<= size(all_data(i,:),2) && k<=10)
    meal_feature3{k}=kurtosis(all_data(floor(i),floor(start):floor(end1)));
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
while(end1<= size(all_data(i,:),2) && k<=10)
    meal_feature4{k}=skewness(all_data(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

meal_feature=[meal_feature1 meal_feature2 meal_feature3 meal_feature4];
meal_feature_matrix=[meal_feature_matrix;meal_feature];

end

meal_feature_matrix=cell2mat(meal_feature_matrix);
[meal_coeff,meal_score]=pca(meal_feature_matrix);
meal_topEigens=meal_coeff(:,1:5);
meal_feature_pca=meal_feature_matrix*meal_topEigens;
c1=ones(a,1);
c2=zeros(b,1);
c3=vertcat(c1,c2);
meal_csv=[meal_feature_pca c3];

writematrix(meal_csv,'meal_final.csv')

writematrix(meal_topEigens,'top_eigens.csv')






