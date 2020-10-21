getwd()
setwd()
dat <- read.csv("Project_Data.csv")
names(dat)
dat1 = dat[,c(2:13)]
dat1 = na.omit(dat1)
names(dat1)
#
reg1 = lm(Happiness.score~., data = dat1)
options(scipen = 999)
summary(reg1)

cor(dat1)
mean(dat1$Happiness.score)
mean(dat1$Social.support)

regsocial=lm(Social.support~.,data=dat1)
summary(regsocial)
regfree=lm(Freedom.to.make.life.choices~.,data=dat1)
summary(regfree)
regpoc=lm(Perceptions.of.corruption~.,data=dat1)
summary(regpoc)


names(dat1)
dat2=dat1[,c(1,2,3,4,5,6)]
names(dat2)
reg2=lm(Happiness.score~.,data=dat2)
summary(reg2)
reg3=glm(Happiness.score~.,data=dat2,family = binomial)
summary(reg3)

# R2:1 - (Residual Deviance/Null Deviance)
#1-(31.847/157.691) = 0.7980417  ----->almost same, use linear
reg2$coefficients
Happiness.score=-2.90122656+0.31494175*Log.GDP.per.capita+2.72292412*Social.support
+0.02711072*Social.support+1.92183687*Freedom.to.make.life.choices+0.31035172*Generosity


# Social support is the most significant, freedom to make life choices is the second
#

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
#create a training and test set to test the tree model:
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
#
#(2)finding the best pruned tree using cross-validation on the training set:
set.seed(1)
library(tree)
tree.train = tree(Happiness.score~., data = dat.train)
plot(tree.train)
text(tree.train,pretty = 0)
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
#MSE = 0.3229614
#the error rate of bagging = 31.8%
importance(bag.happiness)
#
yhat.bag = predict(bag.happiness,dat.valid)
MSE.bag.test = mean((dat.valid$Happiness.score - yhat.bag)^2)
MSE.bag.test
#test.MSE.bag = 0.2308.

#Create an indicator variable
high<-ifelse(dat1$Happiness.score>6,1,0)
dat2 <- cbind(dat1,high)
dat2 <- dat2[,c(13,2:12)]
str(dat2)
dat2$high <- as.factor(dat2$high)

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
set.seed(1)
train2 <- sample(1:122, 61)
dat.train2 <- dat2[train2,]
dat.test2 <- dat2[-train2,]

tree.high.train <-tree(high~.,data=dat.train2)
plot(tree.high.train)
text(tree.high.train,pretty=0)
summary(tree.high.train)
# The tree has a number of 6 termial nodes. 
# Used variables: life expectancy, freedom to make life choices and confidence in national government,
# gdp, and birth rate

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
# The error rate is 24.59.56%
# The tree perform bad on the test dataset in terms of the classification error. 
# Compare to previous, the error rate double. 
# The unpruned tree performs better because it splits more than the pruned tree. However, a disadvantage of 
# trees is overfitting, and pruning can help avoid that.

library(randomForest)
bag.high <- randomForest(high~., data=dat.train2, mtry = 28, importance=TRUE)
bag.high
varImpPlot(bag.high)
#Number of trees: 500
#No. of variables tried at each split: 11
#error rate:21.31%
#    Confusion matrix:
#      0   1 class.error
#    0 35  6   0.1463415
#    1  7  13  0.3500000
#The most important variable: freedom to make life choices and life expectancy

yhat.bag.high <- predict(bag.high,dat.test2, type = "class")
tab.bag.high.test<-table(dat.test2$high,yhat.bag.high, dnn=c("Actual","Predicted"))
tab.bag.high.test
mean(dat.test2$high != yhat.bag.high)
# The error rate is 6.58%

RF.high <- randomForest(high~., data=dat.train2, mtry = 8, importance=TRUE)
RF.high
varImpPlot(RF.high)
#Number of trees: 500
#No. of variables tried at each split: 8
#error rate:21.31%
#    Confusion matrix:
#      0   1 class.error
#    0 34  7   0.1707317
#    1  6 14   0.3000000
#The most important variable: freedom to make life choices and life expectancy

yhat.rf.high <- predict(RF.high,dat.test2, type="class")
tab.rf.high.test<-table(dat.test2$high,yhat.rf.high, dnn=c("Actual","Predicted"))
tab.rf.high.test
mean(dat.test2$high != yhat.rf.high)
# The error rate is 8.197%

library(gbm)
dat.train2[,1] <- as.numeric(dat.train2[,1])-1
str(dat.train2)
dat.test2[,1] <- as.numeric(dat.test2[,1])-1
str(dat.test2)
boost.high <- gbm(high~., data=dat.train2, distribution = "bernoulli", 
                  n.trees = 500, interaction.depth = 4)
summary(boost.high)
#Most important variables are temp, atemp, yr, hum and windspeed. 

yhat.boost.high <- predict(boost.high, dat.test2, n.trees=500, type = "response")
yhat.boost.class<-ifelse(yhat.boost.high>0.5,1,0)
tab.boost<-table(dat.test2$high,yhat.boost.class, dnn=c("Actual","Predicted"))
tab.boost
mean(dat.test2$high != yhat.boost.class)
# 14.75%