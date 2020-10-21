getwd()
setwd()
dat <- read.csv("Project_Data.csv")
names(dat)
dat1 = dat[,c(2:13)]
dat1 = na.omit(dat1)
#
reg1 = lm(Happiness.score~., data = dat1)
options(scipen = 999)
summary(reg1)
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
RMSE.tree.all = MSE.tree.all^(1/2)
RMSE.tree.all
#
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
#MSE.prune.tree in this case = 809415.2
RMSE.prune.tree = MSE.prune.tree^(1/2)
RMSE.prune.tree
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
#i will choose 6.
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
#MSE.prune.tree.6 = 0.19
RMSE.prune.tree.6 = MSE.prune.tree.6^(1/2)
RMSE.prune.tree.6
#RMSE.prune.tree.8 = 0.44
#the MSE to the test data set:
yhat.tree.valid = predict(tree.train,dat.valid)
MSE.prune.tree.6.valid = mean((dat.valid$Happiness.score - yhat.tree.valid)^2)
MSE.prune.tree.6.valid
#MSE.prune.tree.6.valid = 0.41
RMSE.prune.tree.6.valid = MSE.prune.tree.6.valid^(1/2)
RMSE.prune.tree.6.valid
#RMSE.prune.tree.8.valid = 0.64
#
#
#
#bagging:

library(randomForest)
set.seed(1)
dim(dat1)
names(dat1)



bag.happiness = randomForest(Happiness.score~., data = dat1, subset = train,
                             mtry = 11,importance = TRUE)
bag.happiness
#MSE = 0.318
#the error rate of bagging = 31.8%
importance(bag.happiness)
#
yhat.bag = predict(bag.happiness,dat.valid)
MSE.bag.test = mean((dat.valid$Happiness.score - yhat.bag)^2)
MSE.bag.test
#test.MSE.bag = 0.2484.