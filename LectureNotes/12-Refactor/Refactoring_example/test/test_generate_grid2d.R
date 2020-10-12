# Testing refactored code with testthat
context("testing vertex and csv files")

library(testthat)

pre.hairs.csv<-read.csv("hairs1_test.csv")
pre.hairs.header<-read.table("hairs1_test.vertex",nrows=1)
pre.hairs.vertex<-read.table("hairs1_test.vertex",skip=1)

source("../post-refactoring_generate_grid2d.R")

post.hairs.csv <- read.csv("hairs1.csv")
post.hairs.header<-read.table("hairs1.vertex",nrows=1)
post.hairs.vertex<-read.table("hairs1.vertex",skip=1)

test_that("number of points", {
  expect_equal(pre.hairs.header$V1,post.hairs.header$V1)
  expect_equal(nrow(pre.hairs.vertex),nrow(post.hairs.vertex))
  expect_equal(pre.hairs.csv[1,1],post.hairs.csv[1,1])
  expect_equal(pre.hairs.csv[1,2],post.hairs.csv[1,2])
})

test_that("positions of hairs",{
  expect_equal(pre.hairs.vertex[1,],post.hairs.vertex[1,])
  expect_equal(pre.hairs.vertex,post.hairs.vertex)
})
