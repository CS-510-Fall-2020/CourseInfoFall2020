#Course: CS510
#Assignment: Project draft (due Oct 19)


####What is this?####

#This is the project draft for CS510. This project was created in 2018 as the final of my first r course. 
#Three goals:
#1, apply the best pratice 
#2, Update the most recent data
#Fix the mistakes

####
#This dataset measures the happiness rank and score among 155 countries globally based on a several factors such as,
#Economy, generosity, life expectancy, family, trust in government,  and freedom. 
#The happiness score is a sum of these factors and the higher the happiness rank, the higher the happiness score.




#### Loads required packages ####
packages <- c("tree", "gbm","randomForest","testthat","rmarkdown")

package.check <- lapply(
  packages,
  FUN <- function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE, repos='http://cran.us.r-project.org')
      library(x, character.only = TRUE)
    }
  }
)

####import data####
getwd()
setwd("~/Happiness")
dir()
dat <- read.csv("Project_Data.csv")
names(dat)
dat1 = dat[,c(2:13)]
dat1 = na.omit(dat1)

#new data 
dat2015<- read.csv("2015.csv")
dat2016 <- read.csv("2016.csv")
dat2017 <- read.csv("2017.csv")
dat2018 <- read.csv("2018.csv")
dat2019 <- read.csv("2019.csv")

#Part I# Continous Dependent Variable
reg1 = lm(Happiness.score~., data = dat1)
options(scipen = 999)
summary(reg1)


#2019 updated data 
dat2019_new = dat2019[,c(3,5:9)] #delete unsless variable: Country.or.region, country and rank
names(dat2019_new)
reg2019 = lm(Score~., data = dat2019_new)
summary(reg2)



mean(dat1$Happiness.score)
sd(dat1$Happiness.score)
mean(dat1$Log.GDP.per.capita)
sd(dat1$Log.GDP.per.capita)
regfree = lm(Freedom.to.make.life.choices~., data = dat1)
summary(regfree)
plot(regfree)

regsocialsupport = lm(Social.support~., data = dat1)
summary(regsocialsupport)
plot(regsocialsupport)

regdemo = lm(Democratic.Quality~., data = dat1)
summary(regdemo)
plot(regdemo)

regconf = lm(Confidence.in.national.government~., data = dat1)
summary(regconf)
plot(regconf)

sd(dat1$Log.GDP.per.capita)
yhat.all = predict(reg1, dat1)
MSE.all = mean((dat1$Happiness.score-yhat.all)^2)
MSE.all
cor(dat1)
# Social support is the most significant, freedom to make life choices is the second
# MSE is 0.2326

reg2 <- lm(Happiness.score~Social.support+Freedom.to.make.life.choices+Population.Density, data = dat1)
summary(reg2)
anova(reg2, reg1, test = "Chisq")
# P-value is near zerp. Reject H0
# Reg1 is better

cor(dat1, use = "complete.obs")

#tree regression:
library(tree)
set.seed(1)
tree.all = tree(Happiness.score~., data = dat1)
plot(tree.all)
text(tree.all,pretty = 0)

#
tree.all
yhat.tree.all = predict(tree.all, dat1)
yhat.tree.all
MSE.tree.all = mean((dat1$Happiness.score-yhat.tree.all)^2)
MSE.tree.all
# MSE is 0.1663
#
#prune the tree:
prune.tree.all = prune.tree(tree.all)
prune.tree.all
plot(prune.tree.all)
#
prune.tree = prune.tree(tree.all,best = 6)
plot(prune.tree)
text(prune.tree, pretty = 0)
yhat.prune.tree = predict(prune.tree, dat1)
MSE.prune.tree  = mean((dat1$Happiness.score - yhat.prune.tree)^2)
MSE.prune.tree
#MSE.prune.tree in this case = 0.2009537

#
#
#create a training and test set to test:
dim(dat1)
122/2
set.seed(1)
train = sample(1:122,61)
dat.train = dat1[train,]
dim(dat.train)
#
set.seed(1)
dat1.other = dat1[-train,]
valid = sample(1:nrow(dat1.other),61)
dat.valid = dat1.other[valid,]
dim(dat.valid)

reg3 <- lm(Happiness.score~., data = dat.train)
summary(reg3)
yhat.train <- predict(reg3, dat.train)
mean((dat.train$Happiness.score-yhat.train)^2)
yhat.reg <- predict(reg3, dat.valid)
mean((dat.valid$Happiness.score-yhat.reg)^2)
#Test MSE is 0.30329

reg4 <- lm(Happiness.score~Social.support+Freedom.to.make.life.choices+Population.Density, data = dat.train)
summary(reg4)
yhat.train.4 <- predict(reg4, dat.train)
mean((dat.train$Happiness.score-yhat.train.4)^2)
yhat.reg.4 <- predict(reg4, dat.valid)
mean((dat.valid$Happiness.score-yhat.reg.4)^2)

anova(reg4,reg3, test = "Chisq")
#P value is near 0. reject H0
# REG3 is better

#
#(2)finding the best pruned tree using cross-validation on the training set:
set.seed(1)
library(tree)
tree.train = tree(Happiness.score~., data = dat.train)
plot(tree.train)
text(tree.train,pretty = 0)
tree <- predict(tree.train, dat.valid)
mean((dat.valid$Happiness.score - tree)^2)
#
prune.tree.train = prune.tree(tree.train)
plot(prune.tree.train)
#
cv.tree.train = cv.tree(tree.train)
plot(cv.tree.train$size,cv.tree.train$dev,type = "b")
#We will choose 6.
#
prune.tree.6 = prune.tree(tree.train,best=6)
plot(prune.tree.6)
text(prune.tree.6,pretty = 0)
#
yhat.prune.tree.6 = predict(tree.train,dat.train)
plot(yhat.prune.tree.6,dat.train$Happiness.score)
abline(0,1)
MSE.prune.tree.6 = mean((dat.train$Happiness.score - yhat.prune.tree.6)^2)
MSE.prune.tree.6
#MSE.prune.tree.6 = 0.12

#the MSE to the test data set:
yhat.tree.valid = predict(tree.train,dat.valid)
MSE.prune.tree.6.valid = mean((dat.valid$Happiness.score - yhat.tree.valid)^2)
MSE.prune.tree.6.valid
#MSE.prune.tree.6.valid = 0.4729


#bagging:
library(randomForest)
set.seed(1)
dim(dat1)
names(dat1)

bag.happiness = randomForest(Happiness.score~., data = dat1, subset = train,
                             mtry = 11,importance = TRUE)
bag.happiness

importance(bag.happiness)

#
yhat.bag = predict(bag.happiness,dat.valid)
MSE.bag.test = mean((dat.valid$Happiness.score - yhat.bag)^2)
MSE.bag.test
#test.MSE.bag = 0.2308.

library(gbm)
boost <- gbm(Happiness.score~., data = dat.train, distribution = "gaussian", 
             n.trees = 500, interaction.depth = 4)
summary(boost)
yhat.boost <- predict(boost, dat.valid, n.trees=500)
MSE.boost <- mean((dat.valid$Happiness.score - yhat.boost)^2)
MSE.boost
#test MSE = 0.4134877

#Create an indicator variable
high<-ifelse(dat1$Happiness.score>6,1,0)
dat2 <- cbind(dat1,high)
dat2 <- dat2[,c(13,2:12)]
str(dat2)
dat2$high <- as.factor(dat2$high)
str(dat2)

logregall<-glm(high~.,data = dat2,family = "binomial")
summary(logregall)
# Null deviance: 149.722  on 121  degrees of freedom
# Residual deviance:  52.209  on 110  degrees of freedom
# AIC: 76.209
yhat.logregall<-predict(logregall,dat2,type="response")
yhat.logregall.class<-ifelse(yhat.logregall>0.5,1,0)
tab.logregall<-table(dat2$high,yhat.logregall.class,dnn=c("Actual","Predicted"))
tab.logregall
mean(dat2$high != yhat.logregall.class)
# The error rate is 0.07377(7.38%).


library(tree)
tree.high <-tree(high~.,data=dat2)
plot(tree.high)
text(tree.high,pretty=0)
summary(tree.high)
tree.high
# The tree has a number of 8 termial nodes. 
# Used variables: social support, perceptions of corruption, life expectancy, gdp, and birth rate
yhat.tree.high <- predict(tree.high, dat2,type="class")
tree.high.tab<-table(dat2$high,yhat.tree.high,dnn=c("Actual","Predicted"))
tree.high.tab
mean(dat2$high != yhat.tree.high)
# The error rate is 0.07377(7.38%).


cv.high <- cv.tree(tree.high)
plot(cv.high$size,cv.high$dev,type="b")
# pick 4

prune.high<-prune.tree(tree.high, best = 4)
plot(prune.high)
text(prune.high, pretty=0)
yhat.prune.high <- predict(prune.high, dat2,type="class")
tab.high<-table(dat2$high,yhat.prune.high,dnn=c("Actual","Predicted"))
tab.high
mean(dat2$high != yhat.prune.high)
# The error rate is (0.08196) 8.20%
# The tree method has a higher error rate. It performs worse than the logistic regression on 
# predicting accuracy.


#Create a training dataset and test dataset
set.seed(8)
train2 <- sample(1:122, 61)
dat.train2 <- dat2[train2,]
dat.test2 <- dat2[-train2,]

logregall.2<-glm(high~.,data = dat.train2,family = "binomial")
summary(logregall.2)
yhat.logregall.2<-predict(logregall,dat.test2,type="response")
yhat.logregall.class.2<-ifelse(yhat.logregall.2>0.5,1,0)
tab.logregall.2<-table(dat.test2$high,yhat.logregall.class.2,dnn=c("Actual","Predicted"))
tab.logregall.2
mean(dat.test2$high != yhat.logregall.class.2)
#Error rate of 0.6557

tree.high.train <-tree(high~.,data=dat.train2)
plot(tree.high.train)
text(tree.high.train,pretty=0)
summary(tree.high.train)
tree.train.2 <- predict(tree.high.train, dat.test2,type="class")
mean(dat.test2$high != tree.train.2)
# Test Error rate: 16.39%
# Misclassification error rate: 0.04918 in training
# The tree has a number of 5 termial nodes. 
# Used variables: social support, freedom to make life choice and confidence in national government


cv.high.train <- cv.tree(tree.high.train, FUN = prune.misclass)
plot(cv.high.train$size,cv.high.train$dev,type="b")
# pick 4 since the deviance is more stable after 3 splits.

prune.high.train<-prune.tree(tree.high.train, best = 4)
plot(prune.high.train)
text(prune.high.train, pretty=0)
yhat.prune.high.test <- predict(prune.high.train, dat.test2,type="class")
tab.high.test<-table(dat.test2$high,yhat.prune.high.test,dnn=c("Actual","Predicted"))
tab.high.test
mean(dat.test2$high != yhat.prune.high.test)
# The error rate is 16.39344%
# The prune tree perform wrose on the test dataset in terms of the classification error. 


library(randomForest)
bag.high <- randomForest(high~., data=dat.train2, mtry = 28, importance=TRUE)
bag.high
varImpPlot(bag.high)
#Number of trees: 500
#No. of variables tried at each split: 11
#error rate:14.75%
#    Confusion matrix:
#      0   1 class.error
#    0 39  5   0.1136364
#    1  6  11  0.3529411
#The most important variable: social support

yhat.bag.high <- predict(bag.high,dat.test2, type = "class")
tab.bag.high.test<-table(dat.test2$high,yhat.bag.high, dnn=c("Actual","Predicted"))
tab.bag.high.test
mean(dat.test2$high != yhat.bag.high)
# The error rate is 13.11475%

RF.high <- randomForest(high~., data=dat.train2, mtry = 8, importance=TRUE)
RF.high
varImpPlot(RF.high)
#Number of trees: 500
#No. of variables tried at each split: 8
#error rate:14.75%
#    Confusion matrix:
#      0   1 class.error
#    0 38  6   0.1363636
#    1  6 11   0.35294118
#The most important variable: social support and freedom to make life choices 

yhat.rf.high <- predict(RF.high,dat.test2, type="class")
tab.rf.high.test<-table(dat.test2$high,yhat.rf.high, dnn=c("Actual","Predicted"))
tab.rf.high.test
mean(dat.test2$high != yhat.rf.high)
# The error rate is 14.7541%

library(gbm)
dat.train2[,1] <- as.numeric(dat.train2[,1])-1
str(dat.train2)
dat.test2[,1] <- as.numeric(dat.test2[,1])-1
str(dat.test2)
boost.high <- gbm(high~., data=dat.train2, distribution = "bernoulli", 
                  n.trees = 500, interaction.depth = 4)
summary(boost.high)
#                                                               var    rel.inf
#Social.support                                       Social.support  36.655063
#Freedom.to.make.life.choices           Freedom.to.make.life.choices 14.102472
#Life.Span                                                 Life.Span 14.086785
#FDI                                                             FDI   6.740682



yhat.boost.high <- predict(boost.high, dat.test2, n.trees=500, type = "response")
yhat.boost.class<-ifelse(yhat.boost.high>0.5,1,0)
tab.boost<-table(dat.test2$high,yhat.boost.class, dnn=c("Actual","Predicted"))
tab.boost
mean(dat.test2$high != yhat.boost.class)
# 13.11475%