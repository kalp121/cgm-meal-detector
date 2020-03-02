%Reading No meal data------------------------------------------------------
nomeal1=csvread('CGMSeriesLunchPat1.csv');
nomeal1=nomeal1(:,1:30);

nomeal2=csvread('CGMSeriesLunchPat2.csv');
nomeal2=nomeal2(:,1:30);

nomeal3=csvread('CGMSeriesLunchPat3.csv');
nomeal3=nomeal3(:,1:30);

nomeal4=csvread('CGMSeriesLunchPat4.csv');
nomeal4=nomeal4(:,1:30);

nomeal5=csvread('CGMSeriesLunchPat5.csv');
nomeal5=nomeal5(:,1:30);

nomeal= vertcat(nomeal1,nomeal2,nomeal3,nomeal4,nomeal5);





%pre-processing nomeal data -----------------------------------------------

while any(nomeal(:)==0)
  i1=nomeal==0;
  i2=circshift(i1,[0 -1]);
  nomeal(i1)=nomeal(i2);
end
%Filling missing values with previous value

nomeal(sum(isnan(nomeal), 2) > 2, :) = [];
%removing row with more than two NAN missing values 

nomealdata_all = fillmissing(nomeal,'linear',2,'EndValues','nearest');
%Filling NAN missing values with nearest neighbour average
b=int16(size(nomeal,1));



for i=1:b
    
%Feature 1- IQR
nomeal_feature1=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(nomealdata_all(i,:),2) && k<=10)
    nomeal_feature1{k}=iqr(nomealdata_all(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

%Feature 2- Variance Over Window
nomeal_feature2=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(nomealdata_all(i,:),2) && k<=10)
    nomeal_feature2{k}=var(nomealdata_all(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

%feature 3 Kurtosis 

nomeal_feature3=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(nomealdata_all(i,:),2) && k<=10)
    nomeal_feature3{k}=kurtosis(nomealdata_all(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

%feature 4 Skewness
nomeal_feature4=[];
windowsize=5;
start=1;
end1=start+windowsize-1;
k=1;
while(end1<= size(nomealdata_all(i,:),2) && k<=10)
    nomeal_feature4{k}=skewness(nomealdata_all(floor(i),floor(start):floor(end1)));
    start=start+windowsize/2;
    end1=start+windowsize;
    k=k+1;
end

nomeal_feature=[nomeal_feature1 nomeal_feature2 nomeal_feature3 nomeal_feature4];
nomeal_feature_matrix=[nomeal_feature_matrix;nomeal_feature];



end														
nomeal_feature_matrix=cell2mat(nomeal_feature_matrix);     
[nomeal_coeff,nomeal_score]=pca(nomeal_feature_matrix);				
nomeal_topEigens=nomeal_coeff(:,1:5);
nomeal_feature_pca=nomeal_feature_matrix*nomeal_topEigens;

writematrix(nomeal_feature_pca,'nomeal_feature_pca.csv')





